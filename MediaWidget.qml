import QtQuick
import QtMultimedia
import QtQuick.Effects

MouseArea {
    id: mediaWidget
    property string sourceNext;
    property int playerPosition: player.position
    implicitWidth: 1016/3 //635
    implicitHeight: 285 //950/3 //57
    scale: pressed ? 0.8 : 1.0
    Behavior on scale { NumberAnimation { duration: 100; } }
    Rectangle {
        anchors{
            fill: parent
            margins: 16/3 //10
        }
        opacity: 0.7
        color: "#111419"
    }
    MediaPlayer{
        id: player
        source: ""
        audioOutput: audio

        autoPlay: true
    }

    AudioOutput{
        id: audio
        volume: 1
    }
    Image {
        id: bgBlur
        x: 16/3 //10
        y: 5 //50/9 //10
        width: 328 //615
        height: 275 //2750/9 //550
        source: ""
    }

    MultiEffect {
        source: bgBlur
        anchors.fill: bgBlur
        blurEnabled: true
        blurMax: 32
        blur: 0.5
    }
    Image {
        id: idBackgroud
        source: ""
        width: mediaWidget.width
        height: mediaWidget.height
    }
    Text {
        id: title
        anchors.horizontalCenter: parent.horizontalCenter
        y: 20 //200/9 //40
        text: "USB Music"
        color: "white"
        font.pixelSize: 272/15 //34
    }
    Image {
        id: bgInner
        x:536/5 //201
        y: 59.5 //595/9 //119
        width: 688/5 //258
        height: 129 //430/3 //258
        source: ""
    }
    Image{
        x: 536/5 //201
        y: 59.5 //595/9 //119
        width: 688/5 //258
        height: 129 //430/3 //258
        source: "Img/HomeScreen/widget_media_album_bg.png"
    }
    Text {
        id: txtSinger
        x: 112/5 //42
        y: 199.5 //665/3 //(56+343)
        width: 4408/15 //551
        horizontalAlignment: Text.AlignHCenter
        text: ""
        color: "white"
        font.pixelSize: 16 //30
    }
    Text {
        id: txtTitle
        x: 112/5 //42
        y: 227 //2275/9 //(56+343+55)
        width: 4408/15 //551
        horizontalAlignment: Text.AlignHCenter
        text: ""
        color: "white"
        font.pixelSize: 20 //48
    }
    Image{
        id: imgDuration
        x: 496/15 //62
        y: 258 //2585/9 //(56+343+55+62)
        width: 4408/15 //511
        source: "Img/HomeScreen/widget_media_pg_n.png"
    }
    Image{
        id: imgPosition
        x: 496/15 //62
        y: 258 //2585/9 //(56+343+55+62)
        width: 0
        source: "Img/HomeScreen/widget_media_pg_s.png"
    }

    states: [
        State {
            name: "Focus"
            PropertyChanges {
                target: idBackgroud
                source: "Img/HomeScreen/bg_widget_f.png"
            }
        },
        State {
            name: "Pressed"
            PropertyChanges {
                target: idBackgroud
                source: "Img/HomeScreen/bg_widget_p.png"
            }
        },
        State {
            name: "Normal"
            PropertyChanges {
                target: idBackgroud
                source: ""
            }
        }
    ]
    Connections{
        target: backend

        function onPossition(pos){
            player.possition = pos
        }
        function onPlayerTitle(title){
            txtTitle.text = title
        }
        function onPlayerSinger(singer){
            txtSinger.text = singer
        }
        function onPlayerIcon(icon){
            bgBlur.source = icon
            bgInner.source = icon
        }
        function onPlayerSource(source){
            player.source = source
        }
        function onPlaybackState(play){
            if (play == 1){
                player.play()
            }
            else if(play == 2){
                player.pause()
            }
        }
    }
    onPressed: mediaWidget.state = "Pressed"
    onReleased:{
        mediaWidget.focus = true
        mediaWidget.state = "Focus"
    }
    onFocusChanged: {
        if (mediaWidget.focus === true )
            mediaWidget.state = "Focus"
        else
            mediaWidget.state = "Normal"
    }
}
