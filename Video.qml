import QtQuick
import QtQuick.Controls
import QtWebEngine

Item {
    id: root
    visible: true
    width: 1024
    height: 548
    property string selectedVideoId: ""
    property int width_view: 0
    property int height_view: 0
    Column {
        anchors.fill: parent
        spacing: 10
        padding: 10

         Rectangle {
            y: 10
            width: parent.width
            height: 50
            color: "transparent"
                Image {
                    id:imageytb
                    x: 80
                    anchors.verticalCenter: searchField.verticalCenter
                    source: "https://www.gstatic.com/youtube/img/branding/youtubelogo/svg/youtubelogo.svg"
                    width: 120
                    height: 40
                    fillMode: Image.PreserveAspectFit
                    anchors.leftMargin: 10
                }
                TextField {
                    id: searchField
                    x: 250
                    placeholderText: "Nhập từ khóa tìm kiếm video..."
                    width: parent.width - 500
                    height: parent.height -10
                    verticalAlignment: Text.AlignVCenter
                    color: "white"
                    font.family: "Roboto"
                    font.pointSize: 12
                    background: Rectangle {
                    radius: 8
                    color: "black"
                    border.color: "gray"
                    border.width: 1
                    }
                }
                Button {
                    text: "Tìm kiếm"
                    x: 900
                    anchors.verticalCenter: searchField.verticalCenter
                    onClicked: {
                        backend.searchVideos(searchField.text)
                    }
                }
            }

        ListView {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 450
            model: backend.videoList

            delegate: Item {
                width: parent.width
                height: 40
                    Text {
                        x: 70
                        id: titleVideo
                        text: modelData.title
                        font.pixelSize: 14
                        width: 800
                        elide: Text.ElideRight
                        color: "white"
                    }

                    Button {
                        id: playvideo
                        x: 900
                        text: "Xem"
                        anchors.verticalCenter: titleVideo.verticalCenter
                        onClicked: {
                            selectedVideoId = modelData.videoId
                            root.width_view = 1024
                            root.height_view = 350
                        }
                    }
                }
            }
     WebEngineView {
                //anchors.fill: parent
                anchors.bottom: parent.bottom
                width: root.width_view
                height: root.height_view
                url: selectedVideoId !== "" ? "https://www.youtube.com/embed/" + selectedVideoId : ""
            }
}
}