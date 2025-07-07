import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item{
    id: layoutSetting
    width: 800
    height: 478
    Rectangle{
        id: settingLanguage
        width: 800
        height: 200
        color: "transparent"
        y: 70
        x: 224
        Image{
            id: image1
            width: 200
            height: 60
            source: "Image/hold.png"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenterOffset: -100
            Text{
                anchors.centerIn: parent
                text: "Vietnamese"
                color: "white"
                font.pixelSize: 15
            }

        }
        Image{
            id: image2
            width: 200
            height: 60
            source: "Image/hold.png"
            anchors.left: image1.right
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            Text{
                anchors.centerIn: parent
                text: "English"
                color: "white"
                font.pixelSize: 15
            }

        }
        Text{
            id: textSetting
            text: "Language"
            x: 20
            font.pixelSize: 20
            color: "white"
            Image{
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenterOffset: 20
                width: 120
                height: 5
                source: "Img/Climate/line_devider.png"
            }
        }
    }


    Rectangle{
        id: settingAudio
        width: 800
        height: 278
        anchors.top: settingLanguage.bottom
        color: "transparent"
        y: 70
        x: 224
        Slider{
            id: progressBar
            width: 600//*player.position // (1491 - 675)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -20
            from: 0
            to: 100
            value: 30
            background: Rectangle {
                x: progressBar.leftPadding
                y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
                implicitWidth: 200 //960/9 //200
                implicitHeight: 4 //20/9 //4
                width: progressBar.availableWidth
                height: implicitHeight
                radius: 2
                color: "gray"

                Rectangle {
                    width: progressBar.visualPosition * parent.width
                    height: parent.height
                    color: "white"
                    radius: 2
                }
            }
            handle: Image {
                anchors.verticalCenter: parent.verticalCenter
                x: progressBar.leftPadding + progressBar.visualPosition * (progressBar.availableWidth - width)
                y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
                source: "Image/point.png"
                Image {
                    anchors.centerIn: parent
                    source: "Image/center_point.png"
                }
            }
            onValueChanged:{
                backend.setVolume(value)
            }
            onMoved:{
            }
        }
        Text{
            id: audioText
            x: 20
            anchors.top: settingLanguage.bottom
            text: "Volume"
            color: "white"
            font.pixelSize: 20
            Image{
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenterOffset: 20
                width: 120
                height: 5
                source: "Img/Climate/line_devider.png"
            }
        }

    }

    Rectangle{
        //id:
    }
}
