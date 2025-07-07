import speech_recognition as sr
import pygame
import re
import numpy as np
import torch
import torch.nn as nn
from pyvi import ViTokenizer
import warnings
import sys
from pathlib import Path
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Signal, QThread, Property, Slot
from PySide6.QtQuickControls2 import QQuickStyle
from gtts import gTTS
import os
import queue
import sounddevice as sd
import json
import pvporcupine
import pyaudio
import struct
import serial
import time
import requests
import alsaaudio
import subprocess


class backend(QObject):
    def __init__(self):
        super().__init__()

        self._api_key = "AIzaSyAXe3BIa6WPZhJGZa2YxKPMXFUeo9Wzx5s"
        self._video_list = []

        self.worker = WorkerThread()
        self.sensor = ReadTempSensor()
        self.compare = None
        self.worker.update_fan.connect(self.fanOn.emit)
        self.worker.update_rear.connect(self.rearOn.emit)
        self.worker.update_recir.connect(self.recirOn.emit)
        self.worker.update_ac.connect(self.acOn.emit)
        self.worker.update_direct_face.connect(self.directOnFace.emit)
        self.worker.update_direct_body.connect(self.directOnBody.emit)
        self.worker.update_direct_foot.connect(self.directOnFoot.emit)
        self.worker.update_fanLevel.connect(self.fanLevelOn.emit)
        self.worker.update_auto.connect(self.autoClimate.emit)
        self.worker.update_temp.connect(self.tempOn.emit)
        self.worker.changedup_temp.connect(self.tempupChanged.emit)
        self.worker.changeddown_temp.connect(self.tempdownChanged.emit)
        self.worker.modeUp.connect(self.windUpChanged.emit)
        self.worker.modeDown.connect(self.windDownChanged.emit)
        self.worker.getmode.connect(self.getmodeChanged.emit)
        self.worker.remove_lb.connect(self.save_prevlb)
        self.worker.update_auto.connect(self.active_thread)
        self.worker.signal_automode.connect(self.signal_auto.emit)
        self.worker.active_thread.connect(self.active_thread)
        self.worker.tempAuto.connect(self.temp_auto.emit)
        self.sensor.tempin_signal.connect(self.temp_incar.emit) #hien thi nhiet do trong xe ra ngoai giao dien
        self.sensor.tempevap_signal.connect(self.temp_evap.emit)
        self.sensor.tempevap_signal.connect(self.worker.ReadTempEvap)
        self.sensor.pressac_signal.connect(self.worker.ReadPressAc)
        self.sensor.start()
        self.worker.start()

    def active_thread(self):
        if 15 in self.worker.prev_lb and self.compare is None:
            self.compare = CompareTemp()
            self.worker.target_temp.connect(self.compare.read_tempset)
            self.sensor.tempin_signal.connect(self.compare.read_tempsensor)
            self.worker.list_label.connect(self.compare.read_mode)
            self.compare.active_all.connect(self.worker.active)
            self.worker.speed_fan.connect(self.compare.prev_fan)
            self.compare.show_ac.connect(self.worker.update_ac.emit)
            self.compare.show_fan.connect(self.worker.update_fanLevel)
            self.compare.show_recfrs.connect(self.worker.update_recir)
            self.compare.remove_lb.connect(self.save_prevlb)
            self.compare.active_list.connect(self.worker.automode)
            self.worker.list_label.emit(self.worker.prev_lb)
            self.worker.target_temp.emit(self.worker.currentTemp)
            self.compare.active_fan.connect(self.worker.set_speedfan)
            self.compare.start()
        if 18 in self.worker.prev_lb and self.compare is not None:
            self.compare.stop()
            self.compare = None

    @Slot()
    def active_thread_fromqml(self):
        if any(x for x in self.worker.AUTOMODE) <= 1:
            self.active_thread()

    fanOn = Signal(str, str, str, int)
    rearOn = Signal(str, str, str, int)
    recirOn = Signal(str, str, str, int)
    acOn = Signal(str, str, str, int)
    directOnFace = Signal(int, int)
    directOnBody = Signal(int, int)
    directOnFoot = Signal(int, int)
    fanLevelOn = Signal(int, int)
    autoClimate = Signal(str, str, float, int)
    tempOn = Signal(int)
    tempupChanged = Signal()
    tempdownChanged = Signal()
    getmodeChanged = Signal(int)

    windUpChanged = Signal(int)
    windDownChanged = Signal(int)
    fanChanged = Signal(int)
    driverTemp = Signal(int)
    passengerTemp = Signal(int)
    auto = Signal(int)
    temp_incar = Signal(int)
    temp_auto = Signal(int)
    temp_evap = Signal(int)

    @Slot(int)
    def modeUpChanged(self, windmode):
        self.windUpChanged.emit(windmode)

    @Slot(int)
    def modeDownChanged(self, windmode):
        self.windDownChanged.emit(windmode)

    @Slot(int)
    def fanLevelChanged(self, level):
        self.fanChanged.emit(level)

    @Slot(int)
    def driverTempChanged(self, temp):
        self.driverTemp.emit(temp)

    @Slot(int)
    def passengerTempChanged(self, temp):
        self.passengerTemp.emit(temp)

    @Slot(int)
    def autoChanged(self, auto):
        self.auto.emit(auto)

    possition = Signal(int)
    playerIndex = Signal(int)
    playerTitle = Signal(str)
    playerSinger = Signal(str)
    playerIcon = Signal(str)
    playerSource = Signal(str)
    playbackState = Signal(int)

    @Slot(int)
    def playerPossitionChanged(self, pos):
        self.possition.emit(pos)

    @Slot(int)
    def playerIndexChanged(self, index):
        self.playerIndex.emit(index)

    @Slot(str)
    def playerTitleChanged(self, title):
        self.playerTitle.emit(title)

    @Slot(str)
    def playerSingerChanged(self, singer):
        self.playerSinger.emit(singer)

    @Slot(str)
    def playerIconChanged(self, icon):
        self.playerIcon.emit(icon)

    @Slot(str)
    def playerSourceChanged(self, source):
        self.playerSource.emit(source)

    @Slot(int)
    def playerState(self, play):
        self.playbackState.emit(play)

    def save_prevlb(self, mode1, mode2):
        if mode2 in self.worker.prev_lb:
            self.worker.prev_lb.remove(mode2)
        self.worker.prev_lb.append(mode1)
        if 15 in self.worker.prev_lb:
            self.worker.list_label.emit(self.worker.prev_lb)

    @Slot(list)
    def read_list(self, list_label):
        self.worker.prev_lb = list_label
        self.worker.list_label.emit(list_label)

    @Slot(int)
    def ReadTemp(self, temp):
        self.worker.CurrentTemp(temp)

    @Slot(int)
    def ReadTempSetAuto(self, temp):
        self.worker.temp_setauto = temp

    @Slot(float)
    def ReadPreMode(self, mode):
        self.worker.CurrentMode(mode)

    @Slot(int)
    def ReadPreModeRec(self, mode):
        self.worker.CurrentMode_Rec(mode)

    @Slot(float, int, int, int, int, int)
    def clickModeChanged(self, mode, lb1, lb2, lb3, lb4, lb5):
        self.worker.set_modeDirect(mode)
        self.worker.remove_label(lb1, lb2, lb3, lb4, lb5)

    @Slot(int, int, int)
    def clickRecFrs(self, mode, prev_lb1, prev_lb2):
        self.worker.AUTOMODE[1] =0
        self.worker.set_RecFrs(mode)
        self.save_prevlb(prev_lb1, prev_lb2)
        self.worker.signal_automode.emit(self.worker.AUTOMODE)
    @Slot(int)
    def clickTempChanged(self, temp):
        self.worker.AUTOMODE[2] = 0
        if 15 in self.worker.prev_lb:
            self.worker.target_temp.emit(temp)
            self.worker.temp_setauto = temp
        else:
            self.worker.signal_automode.emit(self.worker.AUTOMODE)
            self.worker.set_temperature(temp)

    @Slot(int)
    def clickSpeedFan(self, fan):
        self.worker.AUTOMODE[0] = 0
        self.worker.set_speedfan(fan)
        self.worker.speed_fan.emit(fan)

    @Slot(int, int)
    def clickRear(self, prev_lb1, prev_lb2):
        self.save_prevlb(prev_lb1, prev_lb2)

    @Slot(int, int, int)
    def clickAc(self, mode, prev_lb1, prev_lb2):
        self.worker.AUTOMODE[0] = 0
        self.worker.set_ac(mode)
        self.save_prevlb(prev_lb1, prev_lb2)
        self.worker.signal_automode.emit(self.worker.AUTOMODE)


    @Slot(int, int, int)
    def clickAuto(self, mode, prev_lb1, prev_lb2):
        for i in range(0,3):
            self.worker.AUTOMODE[i] += mode
        self.save_prevlb(prev_lb1, prev_lb2)
        self.active_thread()
        print(self.worker.currentTemp)
        if 18 in self.worker.prev_lb:
            self.worker.set_temperature(self.worker.temp_setauto)

    @Slot(int)
    def setVolume(self, volume):
        try:
            # Mở thiết bị mixer (Master hoặc thiết bị âm thanh mặc định)
            mixer = alsaaudio.Mixer('Master')
            # Kiểm tra và điều chỉnh âm lượng
            current_volume = mixer.getvolume()[0]
            print(f"Hiện tại âm lượng: {current_volume}%")

            # Điều chỉnh âm lượng
            new_volume = int(volume)
            mixer.setvolume(new_volume)
            print(f"Đã thay đổi âm lượng thành: {new_volume}%")

        except alsaaudio.ALSAAudioError as e:
            print("❌ Không thể điều chỉnh âm lượng:", e)

    @Slot(int)
    def setBright(self, brightness_percent):
        brightness = brightness_percent / 100.0
        try:
            # Lấy danh sách màn hình kết nối
            outputs = subprocess.check_output("xrandr | grep ' connected' | awk '{print $1}'",
                                              shell=True).decode().splitlines()
            for output in outputs:
                # Cố gắng đặt độ sáng cho từng màn hình đang kết nối
                subprocess.call(f"xrandr --output {output} --brightness {brightness}", shell=True)
        except Exception as e:
            print("Không thể đặt độ sáng:", e)

    signal_auto =Signal(list)
    @Slot(list)
    def List_auto(self, list):
        print(f"list_auto {list}")
        self.worker.AUTOMODE = list
class WorkerThread(QThread):
    update_fan = Signal(str, str, str, int)
    update_rear = Signal(str, str, str, int)
    update_recir = Signal(str, str, str, int)
    update_ac = Signal(str, str, str, int)
    update_direct_face = Signal(int, int)
    update_direct_body = Signal(int, int)
    update_direct_foot = Signal(int, int)
    update_fanLevel = Signal(int, int)
    update_auto = Signal(str, str, float, int)
    update_temp = Signal(int)
    changedup_temp = Signal()
    changeddown_temp = Signal()
    lable_control = -1

    remove_lb = Signal(int, int)
    modeUp = Signal(int)
    modeDown = Signal(int)
    target_temp = Signal(int)
    list_label = Signal(list)
    speed_fan = Signal(int)
    current_Temp = Signal(int)
    save_atwidget = Signal(list)
    tempAuto = Signal(int)
    currentTemp = 0
    temp_setauto = 0
    pre_mode = 0
    AUTOMODE = [0,0,0]
    signal_automode = Signal(list)
    active_thread = Signal()
    getmode = Signal(int)
    rec = 0
    frs = 5
    pre_mode_rec = 0
    prev_lb = []
    

    def thread_auto(self, mode, lb1, lb2):
        for i in range(0, 3):
            self.AUTOMODE[i] += mode
        self.remove_lb.emit(lb1, lb2)
        self.active_thread.emit()
        self.autoClimate()

    @Slot(int, int, int, int)
    def active(self, mode1, rec, mode2, temp):
        if self.AUTOMODE[0] <= 1:
            self.set_ac(mode1)
            self.AUTOMODE[0] += 1
            self.set_speedfan(mode2)
        if self.AUTOMODE[1]<=1:
            self.set_RecFrs(rec)
            self.AUTOMODE[1] += 1
        if self.AUTOMODE[2] <= 1:
            self.temp_setauto = self.currentTemp
            self.set_temperature(temp)
            self.tempAuto.emit(temp)
            self.AUTOMODE[2] += 1
        print(self.AUTOMODE)
        self.signal_automode.emit(self.AUTOMODE)

    @Slot(list)
    def automode(self, mode):
        self.AUTOMODE = mode

    @Slot(int)
    def ReadTempEvap(self, temp):
        print(temp)
        if temp < 0:
            self.update_ac.emit("Image/AC.png", "Image/bg_climate_info_01.png", "white", 0)
            self.remove_lb.emit(1, 0)
            self.set_ac(1)

    @Slot(float)
    def ReadPressAc(self, press):
        #print(press)
        if press < 0.684 or press > 4.575:
            self.update_ac.emit("Image/AC.png", "Image/bg_climate_info_01.png", "white", 0)
            self.remove_lb.emit(1, 0)
            self.set_ac(1)

    def run(self):
        self.connectPort()
        porcupine = pvporcupine.create(
            access_key=self.acces_key,
            keyword_paths=[self.wake_word_file]
        )

        pa = pyaudio.PyAudio()
        audio_stream = pa.open(
            rate=porcupine.sample_rate,
            channels=1,
            format=pyaudio.paInt16,
            input=True,
            frames_per_buffer=porcupine.frame_length
        )
        print("đang lắng nghe...")

        try:
            while True:
                pcm = audio_stream.read(porcupine.frame_length, exception_on_overflow=False)
                pcm = struct.unpack_from("h" * porcupine.frame_length, pcm)

                # Kiểm tra wake word
                result = porcupine.process(pcm)
                if result >= 0:
                    self.speak_text("honda nghe")
                    text = self.get_audio()
                    print(text)

                    if text is None:
                        self.speak_text("honda chưa nghe anh nói lại đi")
                        text = self.get_audio()
                    # number = self.extract_number(text)

                    # if number is not None
                    #    self.speak_text("tôi đã điều chỉnh đến" + str(number) + "độ")  # number từ 16 - 30 độ
                    else:
                        self.model(text)

        finally:
            audio_stream.close()
            pa.terminate()
            porcupine.delete()

    def imageFan(self):
        global sour, sourc, color, count
        if self.lable_control == 8 or self.lable_control == 7:
            sourc = "Image/bg_widget_f.png"
            sour = "Image/rearb.png"
            color = "#00EAFF"
            count = 1
        elif self.lable_control == 4 or self.lable_control == 5 or self.lable_control == 6:
            sourc = "Image/bg_climate_info_01.png"
            sour = "Image/rear.png"
            color = "white"
            count = 0
        self.update_fan.emit(sour, sourc, color, count)

    def imageRear(self):
        global sour, sourc, color, count
        if self.lable_control == 11:
            sourc = "Image/bg_widget_f.png"
            sour = "Image/rear-icon-blue.png"
            color = "#00EAFF"
            count = 1
        elif self.lable_control == 12:
            sourc = "Image/bg_climate_info_01.png"
            sour = "Image/rear-icon.png"
            color = "white"
            count = 0
        self.update_rear.emit(sour, sourc, color, count)

    def imageRecir(self):
        global sour, sourc, color, count
        if self.lable_control == 13:
            sour = "Image/icons8-air-recirculation-100 (1).png"
            sourc = "Image/bg_widget_f.png"
            color = "#00EAFF"
            count = 1
        elif self.lable_control == 14:
            sour = "Image/icons8-air-recirculation-100.png"
            sourc = "Image/bg_climate_info_01.png"
            color = "white"
            count = 0
        self.update_recir.emit(sour, sourc, color, count)

    def imageAc(self):
        global sour, sourc, color, count
        if self.lable_control in [0, 10]:
            sour = "Image/ACB.png"
            sourc = "Image/bg_widget_f.png"
            color = "#00EAFF"
            count = 1
        elif self.lable_control in [1, 9]:
            sour = "Image/AC.png"
            sourc = "Image/bg_climate_info_01.png"
            color = "white"
            count = 0
        self.update_ac.emit(sour, sourc, color, count)

    def directFace(self):
        global opacity_face, count_face
        if self.lable_control == 4 or self.lable_control == 5:
            opacity_face = 1
            count_face = 1
        elif self.lable_control == 6 or self.lable_control == 7 or self.lable_control == 8:
            opacity_face = 0
            count_face = 0
        self.update_direct_face.emit(opacity_face, count_face)

    def directBody(self):
        global opacity_body, count_body
        if self.lable_control == 4:
            opacity_body = 1
            count_body = 1
        elif self.lable_control != 4:
            opacity_body = 0
            count_body = 0
        self.update_direct_body.emit(opacity_body, count_body)

    def directFoot(self):
        if self.lable_control == 6 or self.lable_control == 7 or self.lable_control == 5:
            opacity_foot = 1
            count_foot = 1
        elif self.lable_control == 4 or self.lable_control == 8:
            opacity_foot = 0
            count_foot = 0
        self.update_direct_foot.emit(opacity_foot, count_foot)

    def fanLevel(self, level):
        fan_level = level
        fan_memory = level
        self.update_fanLevel.emit(fan_level, fan_memory)

    def autoClimate(self):
        global sour, color, opacity, count
        if self.lable_control == 15:
            sour = "Image/bg_widget_f.png"
            opacity = 1
            color = "#00EAFF"
            count = 1
        elif self.lable_control == 18:
            sour = "Image/bg_climate_info_02.png"
            opacity = 0.5
            color = "white"
            count = 0
        self.update_auto.emit(sour, color, opacity, count)

    def climate(self, climate):
        if climate > 30:
            climate = 30
            self.speak_text("đã chỉnh đến nhiệt độ tối đa là 30 độ")
        if climate < 16:
            climate = 16
            self.speak_text("đã chỉnh đến nhiệt độ tối thiểu là 16 độ")
        self.update_temp.emit(climate)

    def tempChanged(self):
        if self.lable_control == 2:
            self.changedup_temp.emit()
        if self.lable_control == 3:
            self.changeddown_temp.emit()


    def get_audio(self):
        with sr.Microphone() as source:
            recognizer = sr.Recognizer()
            audio = recognizer.adjust_for_ambient_noise(source, duration=0.2)
            audio = recognizer.record(source, duration=3)
            try:
                transcription = recognizer.recognize_google(audio, language="vi-VN")
                return transcription.lower()
            except sr.WaitTimeoutError:
                print("Lỗi: Không nghe thấy gì (timeout)")
            except sr.UnknownValueError:
                print("Lỗi: Không nhận dạng được giọng nói")
            except sr.RequestError as e:
                print(f"Lỗi kết nối đến Google: {e}")
            except Exception as e:
                print(f"Lỗi khác: {e}")
            return ""

    def speak_text(self, text):
        tts = gTTS(text=text, lang="vi")
        file_speak = "file_audio.mp3"
        tts.save(file_speak)
        pygame.mixer.init()
        pygame.mixer.music.load(file_speak)
        pygame.mixer.music.play()
        while pygame.mixer.music.get_busy():
            continue
        pygame.mixer.quit()
        os.remove(file_speak)

    def extract_number(self, text):
        matches = re.findall(r"\b\d+(?:\.\d+)?\b", text)
        for match in matches:
            number = int(match)
            return number
        return None

    def tokenize(self, text):
        list_token = ViTokenizer.tokenize(text)
        return list_token.split(' ')

    def encode_sentence(self, text, vocab2index, N):
        tokenized = self.tokenize(text)
        encoded = np.zeros(N, dtype=int)
        enc1 = np.array([vocab2index.get(word, vocab2index["unk"]) for word in tokenized])
        length = min(N, len(enc1))
        encoded[:length] = enc1[:length]
        return [encoded]

    def changed(self):
        self.directFace()
        self.directFoot()
        self.imageFan()

    def remove_label(self, label1, label2, label3, label4, label5):
        self.prev_lb.append(label1)
        if label2 in self.prev_lb:
            self.prev_lb.remove(label2)
        if label3 in self.prev_lb:
            self.prev_lb.remove(label3)
        if label4 in self.prev_lb:
            self.prev_lb.remove(label4)
        if label5 in self.prev_lb:
            self.prev_lb.remove(label5)
        print(self.prev_lb)

    def model(self, text):
        # print(summary(load_model, torch.zeros([5, 10]).long(), show_input=True))
        vecto_text = self.encode_sentence(text, self.vocab2index, self.N)
        numpy_array = np.array(vecto_text)
        tensor_text = torch.tensor(numpy_array)
        text_pad = torch.cat([tensor_text, self.tensor_cre])
        pred = self.load_model(text_pad.long())
        prop_pred = nn.functional.softmax(pred, dim=1)
        pred_label = prop_pred[0].argmax().item()
        print(pred_label)
        print(prop_pred[0])
        self.lable_control = pred_label
        # test
        if pred_label == 0:
            if 0 in self.prev_lb:
                self.speak_text("điều hòa đã được bật từ trước")
            else:
                self.imageAc()
                self.set_ac(0)
                self.speak_text("điều hòa đã bật")
                self.remove_lb.emit(0, 1)
        if pred_label == 1:
            if 1 in self.prev_lb:
                self.speak_text("điều hòa đã được tắt từ trước")
            else:
                self.imageAc()
                self.set_ac(1)
                self.speak_text("điều hòa đã tắt")
                self.remove_lb.emit(1, 0)
        if pred_label == 2:
            if self.currentTemp != 30:
                self.set_temperature(self.currentTemp + 1)
                self.tempChanged()
                self.speak_text(f"đã tăng đến {self.currentTemp} độ")
            else:
                self.speak_text("hiện đang ở nhiệt độ tối đa là 30 độ")
        if pred_label == 3:
            if self.currentTemp != 16:
                self.set_temperature(self.currentTemp - 1)
                self.tempChanged()
                self.speak_text(f"đã giảm đến {self.currentTemp} độ ")
            else:
                self.speak_text("hiện đang ở nhiệt độ tối thiểu là 16 độ")
        if pred_label == 4:
            if 4 in self.prev_lb:
                self.speak_text("chế độ hướng lạnh vào mặt đã được bật từ trước")
            else:
                self.changed()
                self.modeUp.emit(1)
                print("pre_mode: ", self.pre_mode)
                self.set_modeDirect(0 - self.pre_mode)
                self.speak_text("đã hướng lạnh vào mặt")
                self.getmode.emit(0)
                self.remove_label(4, 5, 6, 7, 8)
        if pred_label == 5:
            if 5 in self.prev_lb:
                self.speak_text("chế độ hướng lạnh vào chân và mặt đã được bật từ trước")
            else:
                self.changed()
                print("pre_mode: ", self.pre_mode)
                self.set_modeDirect(1.36 - self.pre_mode)
                self.speak_text("đã hướng lạnh vào chân và mặt")
                self.getmode.emit(1)
                self.remove_label(5, 4, 6, 7, 8)

        if pred_label == 6:
            if 6 in self.prev_lb:
                self.speak_text("chế độ hướng lạnh vào chân đã được bật từ trước")
            else:
                self.changed()
                self.modeDown.emit(1)
                print("pre_mode: ", self.pre_mode)
                self.set_modeDirect(3.36 - self.pre_mode)
                self.speak_text("đã hướng lạnh vào chân")
                self.getmode.emit(2)
                self.remove_label(6, 4, 5, 7, 8)
        if pred_label == 7:
            if 7 in self.prev_lb:
                self.speak_text("chế độ hướng vào chân và sưởi kính trước đã được bật từ trước")
            else:
                self.changed()
                print("pre_mode: ", self.pre_mode)
                self.set_modeDirect(5.36 - self.pre_mode)
                self.speak_text("đã hướng lạnh vào chân và sưởi kính trước")
                self.getmode.emit(3)
                self.remove_label(7, 4, 5, 6, 8)
        if pred_label == 8:
            if 8 in self.prev_lb:
                self.speak_text("chế độ sưởi kính trước đã được bật từ trước")
            else:
                self.changed()
                print("pre_mode: ", self.pre_mode)
                self.set_modeDirect(6.36 - self.pre_mode)
                self.speak_text("đã bật sưởi kính trước")
                self.getmode.emit(4)
                self.remove_label(8, 4, 5, 6, 7)
        if pred_label == 9:
            self.AUTOMODE[2] = 0
            self.climate(30)
            self.set_temperature(30)
            self.speak_text("đã chỉnh đến nhiệt độ tối đa là 30 độ")
        if pred_label == 10:
            self.AUTOMODE[2] = 0
            self.climate(16)
            self.set_temperature(16)
            self.speak_text("đã chỉnh đến nhiệt độ tối thiểu là 16 độ")
        if pred_label == 11:
            if 11 in self.prev_lb:
                self.speak_text("sưởi kính sau đã được bật từ trước")
            else:
                self.imageRear()
                self.speak_text("đã bật sưởi kính sau")
                self.remove_lb.emit(11, 12)
        if pred_label == 12:
            if 12 in self.prev_lb:
                self.speak_text("sưởi kính sau đã được tắt từ trước")
            else:
                self.imageRear()
                self.speak_text("đã tắt sưởi kính sau")
                self.remove_lb.emit(12, 11)
        if pred_label == 13:
            if 13 in self.prev_lb:
                self.speak_text("chế độ lấy gió trong đã được bật từ trước")
            else:
                self.AUTOMODE[1] = 0
                self.set_RecFrs(0)
                self.imageRecir()
                self.speak_text("đã chuyển sang chế độ lấy gió trong")
                self.remove_lb.emit(13, 14)
        if pred_label == 14:
            if 14 in self.prev_lb:
                self.speak_text("chế độ lấy gió ngoài đã được bật từ trước")
            else:
                self.AUTOMODE[1] = 0
                self.set_RecFrs(5)
                self.imageRecir()
                self.speak_text("đã chuyển sang chế độ lấy gió ngoài")
                self.remove_lb.emit(14, 13)
        if pred_label == 15:
            if 15 in self.prev_lb:
                self.speak_text("điều hòa tự động đã được bật từ trước")
            else:
                self.thread_auto(1, 15, 18)
                self.speak_text("điều hòa tự động đã bật")
        if pred_label == 16:
            self.speak_text("honda chưa hiểu anh nói lại đi")
            text = self.get_audio()
            print(text)
            while text is None:
                self.speak_text("honda chưa nghe rõ anh nói lại đi")
                text = self.get_audio()
                print(text)
                if text is not None:
                    break
            call_model = self.model(text)
        if pred_label == 17:
            if "1" in text or "một" in text or "nhỏ nhất" in text or "thấp nhất" in text or "bé nhất" in text or "tối thiểu" in text:
                self.set_speedfan(1)
                self.fanLevel(1)
                self.speak_text("quạt đã bật mức 1")
            if "2" in text or "hai" in text:
                self.set_speedfan(2)
                self.fanLevel(2)
                self.speak_text("quạt đã bật mức 2")
            if "3" in text or "ba" in text:
                self.set_speedfan(3)
                self.fanLevel(3)
                self.speak_text("quạt đã bật mức 3")
            if "4" in text or "bốn" in text:
                self.set_speedfan(4)
                self.fanLevel(4)
                self.speak_text("quạt đã bật mức 4")
            if "5" in text or "năm" in text or "lớn nhất" in text or "cao nhất" in text or "to nhất" in text or "tối đa" in text:
                self.set_speedfan(5)
                self.fanLevel(5)
                self.speak_text("quạt đã bật mức 5")
            else:
                self.set_speedfan(5)
                self.fanLevel(5)
                self.speak_text("quạt đã bật mức tối đa là mức 5")
            self.AUTOMODE[0] = 0
        if pred_label == 18:
            if 18 in self.prev_lb:
                self.speak_text("điều hòa tự động đã được tắt từ trước")
            else:
                self.set_temperature(self.temp_setauto)
                self.thread_auto(0, 18, 15)
                end = time.time()
                self.speak_text("điều hòa tự động đã tắt")
        if pred_label == 19:
            number = self.extract_number(text)
            self.climate(number)
            if number >= 16 and number <= 30:
                if 15 in self.prev_lb:
                    self.target_temp.emit(number)
                    self.temp_setauto = number
                else:
                    self.AUTOMODE[2] = 0
                    self.signal_automode.emit(self.AUTOMODE)
                    self.set_temperature(number)
                self.speak_text("đã chỉnh đến" + str(number) + "độ")  # number từ 16 - 30 độ

    def load_checkpoint(filepath):
        checkpoint = torch.load(filepath, weights_only=False)
        model = checkpoint["model"]
        model.load_state_dict(checkpoint["state_dict"])
        for parameter in model.parameters():
            parameter.requires_grad = False
        model.eval()
        return model

    warnings.filterwarnings("ignore")
    acces_key = "Vpi8tO9JYXy01nQhEzXlFpSlYzIrh/COo7owj8V+EDktNMM37YcHfA=="  # ZICAj/fRInyEfcDcu8gayhsyYdxZklP8XVYKggIO9JxCs2MbF66GTg==
    wake_word_file = "/home/nam/Downloads/pythonProject1/hey-honda_en_raspberry-pi_v3_0_0.ppn"  # hey-honda_en_raspberry-pi_v3_0_0
    N = 10
    model_path = '/home/nam/Downloads/pythonProject1'
    load_model = load_checkpoint(os.path.join(model_path, 'best.pth'))
    vocab2index = torch.load(os.path.join(model_path, 'vocab.pth'))
    tensor_cre = torch.zeros([4, N])

    def connectPort(self):
        try:
            self.serial = serial.Serial('/dev/ttyUSB1', 9600, timeout=1)
        except Exception as e:
            print(f"Lỗi kết nối")

    def CurrentTemp(self, temp):
        self.currentTemp = temp
    def CurrentMode(self, mode):
        self.pre_mode = mode
    def CurrentMode_Rec(self, mode):
        self.pre_mode_rec = mode

    def set_temperature(self, target_temp):
        diff = target_temp - self.currentTemp
        self.currentTemp = target_temp
        if diff != 0:
            command = f"temp:{diff}\n"
            self.serial.write(command.encode())
            print(command)
        print(f"Đã chỉnh tới {self.currentTemp}°C")

    def set_RecFrs(self, mode):
        diff = mode - self.pre_mode_rec
        self.pre_mode_rec = mode
        command = f"rec:{diff}\n"
        self.serial.write(command.encode())
        print(command) 
        print(f"Đã chỉnh tới mode {mode}")
    def set_modeDirect(self, mode):
        command = f"mode:{mode}\n"
        self.serial.write(command.encode())
        print(command)
        print(f"Đã chỉnh tới mode direct {mode}")

    def set_speedfan(self, fan):
        command = f"fan:{fan}\n"
        self.serial.write(command.encode())
        print(command)
        print(f"Đã chỉnh tới mức quạt{fan}")

    def set_ac(self, mode):
        command = f"ac:{mode}\n"
        self.serial.write(command.encode())
        print(command)
        print(f"Đã chỉnh AC: {mode}")
        

class ReadTempSensor(QThread):
    tempin_signal = Signal(int)
    tempevap_signal = Signal(int)
    pressac_signal = Signal(float)

    def __init__(self):
        super().__init__()
        self.running = True
        self.temp_in = 0
        self.temp_out = 0
        self.temp_evap = 0

    def run(self):
        self.connectPort()
        while self.running:
            if self.myserial.in_waiting:
                try:
                    raw = self.myserial.readline().decode().strip()
                    parts = raw.split(',')
                    if len(parts) == 2:
                        self.temp_in = int(parts[0])
                        self.temp_evap = int(parts[1])
                        self.tempin_signal.emit(self.temp_in)
                        self.tempevap_signal.emit(self.temp_evap)
                        #self.pressac_signal.emit(self.press_ac)
                except Exception:
                    print("loi")
                self.msleep(200)
    def connectPort(self):
        try:
            self.myserial = serial.Serial('/dev/ttyUSB0', 19200, timeout=1)
        except Exception as e:
            print(f"Lỗi kết nối")

    def stop(self):
        self.running = False
        self.wait()


class CompareTemp(QThread):
    active_ac = Signal(int)
    active_all = Signal(int, int, int, int)
    remove_lb = Signal(int, int)
    show_ac = Signal(str, str, str, int)
    show_fan = Signal(int, int)
    show_recfrs = Signal(str, str, str, int)
    active_list = Signal(list)
    active_fan = Signal(int)
    def __init__(self):
        super().__init__()
        self.running = True
        self.temp_sensor = 0
        self.temp_set = 0
        self.speed_fan = 0
        self.current_temp = 0
        self.list_mode = []
        self.AUTO = [0, 0, 0]

    def run(self):
        while self.running:
            if self.temp_sensor != 0:
                if self.temp_sensor - self.temp_set > 1:
                    self.active(0, 1, 0, 5, 20, 16)
                elif self.temp_sensor - self.temp_set < -2:
                    self.active(1, 0, 5, 5, 20, 30)
                else:
                    self.active_list.emit(self.AUTO)
                    self.active_fan.emit(1)
                    self.show_fan.emit(1,1)
                    self.list_mode.append(20)
                    self.msleep(5000)

    def active(self, cmd0, cmd1, rec, cmd5, cmd, temp):
        if all(x in self.list_mode for x in [cmd0, cmd]):
            self.list_mode.remove(cmd)
            self.show_fan.emit(5, 5)
            self.rec_frs(cmd1)
            self.active_all.emit(cmd0, rec, cmd5, temp)
        elif all(x in self.list_mode for x in [cmd1, cmd]):
            self.list_mode.remove(cmd)
            if cmd1 == 1:
                self.show_ac.emit("Image/ACB.png", "Image/bg_widget_f.png", "#00EAFF", 1)
                self.remove_lb.emit(0, 1)
            if cmd1 == 0:
                self.show_ac.emit("Image/AC.png", "Image/bg_climate_info_01.png", "white", 0)
                self.remove_lb.emit(1, 0)
            self.show_fan.emit(5, 5)
            self.rec_frs(cmd1)
            self.active_all.emit(cmd0, rec, cmd5, temp)

    def rec_frs(self, mode):
        if mode == 1:
            self.show_recfrs.emit("Image/icons8-air-recirculation-100 (1).png", "Image/bg_widget_f.png", "#00EAFF", 1)
        if mode == 0:
            self.show_recfrs.emit("Image/icons8-air-recirculation-100.png", "Image/bg_climate_info_01.png", "white", 0)

    @Slot(int)
    def prev_fan(self, lv):
        self.speed_fan = lv

    @Slot(int)
    def read_tempset(self, temp):
        self.temp_set = temp
        print(temp)

    @Slot(int)
    def read_tempsensor(self, temp):
        self.temp_sensor = temp

    @Slot(list)
    def read_mode(self, list_mode):
        self.list_mode = list_mode
        print(list_mode)

    def stop(self):
        self.running = False
        self.wait()


if __name__ == "__main__":
    app = QGuiApplication(sys.argv + ["-style", "Fusion"])
    engine = QQmlApplicationEngine()
    QQuickStyle.setStyle("Fusion")
    qml_file = Path(__file__).resolve().parent / "main.qml"
    backend = backend()
    engine.rootContext().setContextProperty("backend", backend)
    engine.load(qml_file)
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())

