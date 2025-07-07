import QtQuick 2.11

MouseArea {
    id: root
    onEnabledChanged: state = ""
    antialiasing: true

    property string     icon
    property alias      label:          text.text
    property alias      labelSize:      text.font.pixelSize
    property alias      labelColor:     text.color
    property alias      labelFont :     text.font.family
    property int        labelYOffset :  0

    property int iconWidth: 0
    property int iconHeight: 0
    property bool usingMirror: false

    onPressed: {
        root.state= "Pressed"
    }
    onReleased: {
        if (containsMouse)
            root.state="Focus";
        else
            root.state= "";
    }
    onEntered: { root.state = "Focus"}
    onExited: { root.state = ""}
    Keys.onSpacePressed: clicked()

    Image {
        mirror: usingMirror
        id: bg
        anchors.fill:parent
        source: icon + "_n.png"
        width: iconWidth
        height: iconHeight
    }
    states: [
        State {
            name: "Focus"
            PropertyChanges {
                target: bg
                source: icon + "_f.png"
            }
            PropertyChanges {
                target: text
                color: "white"
            }
        },
        State {
            name: "Pressed"
            PropertyChanges {
                target: bg
                source: icon + "_p.png"
            }
            PropertyChanges {
                target: text
                color: "grey"
            }
        },
        State {
            name: "Disable"
            PropertyChanges {
                target: bg
                source: icon + "_d.png"
            }
            PropertyChanges {
                target: text
                color: "red"
            }
        }
    ]

    Text {
        id: text
        z:3
        color: "white"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: labelYOffset
        horizontalAlignment: Text.AlignHCenter
    }
}
