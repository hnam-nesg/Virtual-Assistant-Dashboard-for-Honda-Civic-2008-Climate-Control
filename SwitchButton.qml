import QtQuick

MouseArea {
    id: root
    property alias width1: img.width
    property alias height1 : img.height
    property string icon_on: ""
    property string icon_off: ""
    property int status: 0 //0-Off 1-On
    implicitWidth: img.width
    implicitHeight: img.height
    Image {
        id: img
        source: root.status === 0 ? icon_off : icon_on
        width: width1
        height: height1
    }
    onClicked: {
        if (root.status == 0){
            root.status = 1
        } else {
            root.status = 0
        }
    }
}
