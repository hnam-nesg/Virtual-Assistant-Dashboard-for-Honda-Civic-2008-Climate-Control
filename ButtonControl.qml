import QtQuick 2.0

MouseArea {
    property alias width1: img.width
    property alias height1 : img.height
    property string icon_default: ""
    property string icon_pressed: ""
    property string icon_released: ""
    property alias source: img.source
    implicitWidth: img.width
    implicitHeight: img.height
    Image {
        id: img
        source: icon_default
        width: width1
        height: height1
    }
    onPressed: {
        img.source = icon_pressed
    }
    onReleased: {
        img.source = icon_released
    }
}
