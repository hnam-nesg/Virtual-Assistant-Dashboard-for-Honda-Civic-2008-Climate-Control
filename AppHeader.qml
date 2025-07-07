import QtQuick

Item {
    property alias playlistButtonStatus: playlist_button.status
    signal clickPlaylistButton
    Image {
        id: headerItem
        width: 1024
        height: 70
        source: "Image/title.png"
        SwitchButton {
            id: playlist_button
            width1: 20
            height1: 20
            anchors.left: parent.left
            anchors.leftMargin: 32/3 //20
            anchors.verticalCenter: parent.verticalCenter
            icon_off: "Image/drawer.png"
            icon_on: "Image/back.png"

            onClicked: {
                clickPlaylistButton()
                //playlist_button.status = (playlist_button.status === 0) ? 1 : 0;

            }
        }
        Text {
            anchors.left: playlist_button.right
            anchors.leftMargin: 5 //5
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Playlist")
            color: "white"
            font.pixelSize: 256/15 //32
        }
        Text {
            id: headerTitleText
            text: qsTr("Media Player")
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 368/15 //46
        }
    }
}
