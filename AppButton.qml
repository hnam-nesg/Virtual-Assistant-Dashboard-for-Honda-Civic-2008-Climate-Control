import QtQuick

MouseArea {
    id: root
    width: 505.6/3 //316
    height: 263 //2020/9 //526
    property string icon
    property string title
    scale: pressed ? 0.8 : 1.0
    Behavior on scale { NumberAnimation { duration: 50; } }
    Image {
        id: idBackgroud
        width: root.width
        height: root.height
        source: icon + "_n.png"
    }
    Text {
        id: appTitle
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenterOffset: 20
        anchors.verticalCenter: parent.verticalCenter
        y: 175 //1750/9 //350
        text: title
        font.pixelSize: 96/5 //36
        color: "white"
    }

    states: [
        State {
            name: "Focus"
            PropertyChanges {
                target: idBackgroud
                source: icon + "_f.png"
            }
        },
        State {
            name: "Pressed"
            PropertyChanges {
                target: idBackgroud
                source: icon + "_p.png"
            }
        },
        State {
            name: "Normal"
            PropertyChanges {
                target: idBackgroud
                source: icon + "_n.png"
            }
        }
    ]
    onPressed: root.state = "Pressed"
    onReleased: {
        root.focus = true
        root.state = "Focus"
    }
    onFocusChanged: {
        if (root.focus === true )
            root.state = "Focus"
        else
            root.state = "Normal"
    }
}
