import os
import speech_recognition as sr
import playsound

from gtts import gTTS
import pygame
import re
import numpy as np
import torch
import torch.nn as nn
from pyvi import ViTokenizer
import os
from pytorch_model_summary import summary
import warnings

warnings.filterwarnings("ignore")

N = 10

model_path = 'C:/Users/PC/Music/pythonProject1'


def extract_number(text):
        matches = re.findall(r"\b\d+(?:\.\d+)?\b", text)
        for match in matches:
            number = float(match)  # Chuyển số sang dạng float
            # Kiểm tra nếu số nằm trong khoảng từ 16 đến 30
            if 16 <= number <= 30:
                numbers = adjust_for_half_degree(text, number)
                return numbers
            elif number <= 16:
                return 16
            else:
                return 30


def adjust_for_half_degree(text, number):
    # Kiểm tra nếu chuỗi có chứa "độ rưỡi" hoặc "độ gửi"
    if "độ rưỡi" in text or "độ gửi" in text:
        return number + 0.5
    return number

def load_checkpoint(filepath):
    checkpoint = torch.load(filepath)
    model = checkpoint["model"]
    model.load_state_dict(checkpoint["state_dict"])
    for parameter in model.parameters():
        parameter.requires_grad = False
    model.eval()
    return model


def tokenize(text):
    list_token = ViTokenizer.tokenize(text)
    return list_token.split(' ')


def encode_sentence(text, vocab2index, N):
    tokenized = tokenize(text)
    encoded = np.zeros(N, dtype=int)
    enc1 = np.array([vocab2index.get(word, vocab2index["unk"]) for word in tokenized])
    length = min(N, len(enc1))
    encoded[:length] = enc1[:length]
    return [encoded]


load_model = load_checkpoint(os.path.join(model_path, 'last.pth'))
vocab2index = torch.load(os.path.join(model_path, 'vocab.pth'))
tensor_cre = torch.zeros([4, N])


def model(text):
    #print(summary(load_model, torch.zeros([5, 10]).long(), show_input=True))
    vecto_text = encode_sentence(text, vocab2index, N)
    numpy_array = np.array(vecto_text)
    tensor_text = torch.tensor(numpy_array)
    text_pad = torch.cat([tensor_text, tensor_cre])
    pred = load_model(text_pad.long())
    prop_pred = nn.functional.softmax(pred, dim=1)
    pred_label = prop_pred[0].argmax().item()
    print(pred_label)
    print(prop_pred[0])

    # test
    if pred_label == 0:
        #if ac = "off":
            print("đã bật điều hòa")

    if pred_label == 1:
        print("đã tắt điều hòa ")
    if pred_label == 2:
        print("đã tăng nhiệt độ")
    if pred_label == 3:
        print("đã giảm nhiệt độ")
    if pred_label == 4:
        print("đã bật chế độ 1")
    if pred_label == 5:
        print("đã bật chế độ 2")
    if pred_label == 6:
        print("đã bật chế độ 3")
    if pred_label == 7:
        print("đã bật chế độ 4")
    if pred_label == 8:
        print("đã bật chế độ 5")
    if pred_label == 9:
        print("đã bật quạt ở mức 1")
    if pred_label == 10:
        print("đã tắt quạt")
    if pred_label == 11:
        print("đã bật sưởi kính sau")
    if pred_label == 12:
        print("đã tắt sưởi kính sau")

    if pred_label == 13:
        print("đã lấy gió trong")
    if pred_label == 14:
        print("đã lấy gió ngoài")
    if pred_label == 15:
        print("đã bật chế độ tự động, anh muốn cài đặt nhiệt độ bao nhiêu")
        number = extract_number(text)
        print("điều hòa tự động đã chỉnh đến" + str(number) + "độ")

    if pred_label == 16:
        print("em chưa hiểu anh nói lại đi")
        #call_model = model(text)

    if pred_label == 17:
        if "1" in text or "một" in text or "nhỏ nhất" in text or "thấp nhất" in text or "bé nhất" in text:
            print("đã bật quạt mức 1")
        if "2" in text or "hai" in text:
            print("đã bật quạt mức 2")
        if "3" in text or "bai" in text:
            print("đã bật quạt mức 3")
        if "4" in text or "bốn" in text:
            print("đã bật quạt mức 4")
        if "5" in text or "năm" in text:
            print("đã bật quạt mức 5")
        if "6" in text or "sáu" in text:
            print("đã bật quạt mức 6")
        if "7" in text or "bảy" in text or "lớn nhất" in text or "cao nhất" in text or "to nhất" in text:
            print("đã bật quạt mức 7")

    if pred_label == 18:
        print("đã tắt chế độ auto")

    if pred_label == 19:
        number = extract_number(text)
        print("đã điều chỉnh đến" + str(number) + "độ")  # number từ 16 - 30 độ
    if pred_label == 20:

        print("đã điều chỉnh đến nhiệt độ cao nhất 30 độ")  # number từ 16 - 30 độ

    if pred_label == 21:
        print("đã điều chỉnh đến nhiệt độ thấp nhất 16 độ")  # number từ 16 - 30 độ




while True:
    text = input()
    model(text)