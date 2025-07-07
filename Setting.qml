import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    property string currentSelection: ""
    width: 1024
    height: 548
    visible: true

    Image{
        id: title
        width: parent.width
        height: 70
        source: "Image/title.png"
        Text{
            anchors.centerIn: parent
            text: "Settings"
            font.pixelSize: 368/15
            color: "white"
        }
    }

    ListView{
        id: listSetting
        model: appModel
        y: 70
        width: 224
        height: 478
        spacing: 2
        clip: true
        delegate: MouseArea{
            property variant myData: model
            implicitHeight: listSettingItem.height
            implicitWidth: listSettingItem.width
            Image{
                id: listSettingItem
                width: 224
                height: 150
                source: "Image/playlist.png"
                opacity: 0.5
            }
            Text{
                id: textTitle
                text: model.title
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.pixelSize: 15
                Image{
                    anchors.verticalCenter: textTitle.verticalCenter
                    anchors.horizontalCenter: textTitle.horizontalCenter
                    anchors.verticalCenterOffset: 20
                    width: 150
                    height: 5
                    source: "Img/Climate/line_devider.png"
                }
            }
            onClicked: {
                listSetting.currentIndex = index
                if(index ==0){
                    stack.replace("SoundSetting.qml")
                }
                else {
                    stack.replace("DisplaySetting.qml")
                }
            }

            onPressed: {
                listSetting.source = "Image/hold.png"
            }
            onReleased: {
                listSetting.source = "Image/playlist.png"
            }
        }
        highlight: Image {
            source: "Image/bg_widget_f.png"
            Image {
                anchors.left: parent.left
                anchors.leftMargin: 8 //15
                anchors.verticalCenter: parent.verticalCenter
                width: 20
                height: 20
            }
        }
        ScrollBar.vertical: ScrollBar {
            parent: listSetting.parent
            anchors.top: listSetting.top
            anchors.left: listSetting.right
            anchors.bottom: listSetting.bottom
        }
    }
    ListModel{
        id: appModel
        ListElement{
            title: "Sound"
        }
        ListElement{
            title: "Display"
        }
        ListElement{
            title: "Bluetooth"
        }
        ListElement{
            title: "Connectiny"
        }
    }
    StackView {
           id: stack
           anchors.fill: parent
           initialItem: "SoundSetting.qml"
       }
}

