import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import QtQuick.LocalStorage
import "DataMedia.js" as JS

Item {
    id: root
    property var db;
    property url sourceNext: ""
    width: 1024
    height: 548 //1200-104

    Image{
        id: bgid
        width: parent.width
        height: 600
        //source: "Image/background.png"
        //source: "Img/bg_full.png"
    }

    function str_pad_left(string,pad,length) {
        return (new Array(length+1).join(pad)+string).slice(-length);
    }
    function getTime(time){
        time = time/1000
        let minutes = Math.floor(time / 60 );
        let seconds = Math.floor(time - minutes * 60);

        return str_pad_left(minutes,'0',2)+':'+str_pad_left(seconds,'0',2);
    }


    MediaPlayer{
        id: player
        source: ""
        audioOutput: audio
        onPlaybackStateChanged: {
            if (player.playbackState == MediaPlayer.StoppedState && position == duration && repeater.status ==0){
                if (shuffer.status==1) {
                    var newIndex = Math.floor(Math.random() * mediaPlaylist.count)
                    while (newIndex === mediaPlaylist.currentIndex) {
                        newIndex = Math.floor(Math.random() * mediaPlaylist.count)
                    }
                    mediaPlaylist.currentIndex = newIndex
                } else if(mediaPlaylist.currentIndex < mediaPlaylist.count - 1 ) {
                    mediaPlaylist.currentIndex = mediaPlaylist.currentIndex + 1;
                }
                else{
                    mediaPlaylist.currentIndex = 0
                }
            }
            else if (player.playbackState == MediaPlayer.StoppedState && position == duration && repeater.status == 1){
                position = 0
                player.play()
            }
            backend.playerState(player.playbackState)
        }
        onPositionChanged:{
            backend.playerPossitionChanged(player.position)
        }

        autoPlay: true
    }
    AudioOutput{
        id: audio
        volume: 1
    }

    ListModel {
        id: appModel
        ListElement{title: "Gọi Cho Anh Đi"; singer: "AndreeRightHand" ; icon: "Image/AndreeRightHand.webp"; source: "Music/Goi-Cho-Anh-Di.mp3" }
        ListElement{title: "Sự Nghiệp Chướng"; singer: "Pháo NorthSide" ; icon: "Image/Phao.jpg"; source: "Music/Su-Nghiep-Chuong.mp3" }
        ListElement{title: "MammaMia"; singer: "Gerdnang" ; icon: "Image/mammamia.jpg"; source: "Music/MammaMia-HIEUTHUHAIHURRYKNGMANBONegavRex-7288215.mp3" }
        ListElement{title: "Trình" ; singer: "HIEUTHUHAI" ; icon: "Image/HIEUTHUHAI.jpg"; source: "Music/Trinh.mp3"}
        ListElement{title: "NOLOVENOLIFE" ; singer: "HIEUTHUHAI" ; icon: "Image/HIEUTHUHAI.jpg"; source: "Music/NOLOVENOLIFE-HIEUTHUHAI-11966374.mp3"}
        ListElement{title: "Không Phải Gu" ; singer: "HIEUTHUHAI" ; icon: "Image/HIEUTHUHAI.jpg"; source: "Music/KhongPhaiGu-HIEUTHUHAI-11966359.mp3"}
        ListElement{title: "Anh Vẫn Luôn Như Vậy"; singer: "Bray"; icon: "Image/anhvanluonnhuvay.jpg"; source: "Music/AnhLuonNhuVay-BRay-11853369.mp3"}
        ListElement{title: "Đa Nghi"; singer: "Ogenus"; icon: "Image/Danghi.jpg"; source: "Music/DaNghi-OgeNus-15942159.mp3"}
        ListElement{title: "Exit Sign"; singer: "HIEUTHUHAI"; icon: "Image/d4acc6335d41bd7164173312c6123706.jpg"; source: "Music/ExitSign-HIEUTHUHAI-11966367.mp3"}
        ListElement{title: "Chăm Hoa"; singer: "Mono"; icon: "Image/bzvn-mono-cham-hoa-3-1.jpg"; source: "Music/ChamHoa.mp3"}
        ListElement{title: "Chúng Ta Của Hiện Tại"; singer: "Sơn Tùng-MTP"; icon: "Image/Sontung.webp"; source: "Music/ChungTaCuaHienTai-SonTungMTP-6892340.mp3"}
        ListElement{title: "Ghé Qua"; singer: "Dick - Huỳnh Công Hiếu"; icon: "Image/ghequa.jpg"; source: "Music/GheQua-TaynguyenSoundTofuPC-7031399.mp3"}
        ListElement{title: "Phù Hộ Cho Con"; singer: "24k Right - Bray - Huỳnh Công Hiếu"; icon: "Image/phuhochocon.jpg"; source: "Music/PhuHoChoCon-24kRightBRayDickHipz-15754317.mp3"}
        ListElement{title: "Anh Đã Lớn Hơn Thế Nhiều"; singer: "Huỳnh Công Hiếu"; icon: "Image/AnhDaLonHonTheNhieu.webp"; source: "Music/Anhdalonhonthenhieu.mp3"}
        ListElement{title: "Anh Trai Hip Hop"; singer: "Gill - Bray - Robber"; icon: "Image/AnhTraiHipHop.jpg"; source: "Music/MayAnhTraiNayHipHop.mp3"}
        ListElement{title: "Bắc Bling"; singer: "Hòa Minzy"; icon: "Image/Bacbling.jpg"; source: "Music/BacBling.mp3"}
        ListElement{title: "Cơn Mưa Xa Dần"; singer: "Sơn Tùng-MTP"; icon: "Image/Conmuaxadan.jpg"; source: "Music/ConMuaXaDan.mp3"}
        ListElement{title: "Chờ Một Người"; singer: "Gill - Captain"; icon: "Image/Chomotnguoi.png"; source: "Music/ChoMotNguoi.mp3"}
        ListElement{title: "Chưa Từng Vì Nhau"; singer: "Karik"; icon: "Image/Chuatungvinhau.jpg"; source: "Music/Chuatungvinhau.mp3"}
        ListElement{title: "Dám Rực Rỡ"; singer: "GREY D - HIEUTHUHAI - Wren Evans - Obito "; icon: "Image/DamRucRo.jpg"; source: "Music/DamRucRo.mp3"}
        ListElement{title: "Đến Bao Giờ"; singer: "Datmaniac - Cá Hồi Hoang"; icon: "Image/DenBaoGio.png"; source: "Music/2018Denbaogio.mp3"}
        ListElement{title: "Đi Tìm Tình Yêu"; singer: "Mono"; icon: "Image/Ditimtinhyeu.jpg"; source: "Music/DiTimTinhYeu.mp3"}
        ListElement{title: "Ghệ Mới"; singer: "Bray"; icon: "Image/Ghemoi.jpg"; source: "Music/GheMoi.mp3"}
        ListElement{title: "Lần Cuối"; singer: "Karik"; icon: "Image/Lancuoi.jpg"; source: "Music/LanCuoi.mp3"}
        ListElement{title: "Qua Từng Khung Hình"; singer: "Ngắn - Robber"; icon: "Image/Quatungkhuhinh.jpg"; source: "Music/QuaTungKhungHinh.mp3"}
        ListElement{title: "Trước Khi Tuổi Trẻ Này Đóng Lối"; singer: "Dick - Xám"; icon: "Image/Truockhituoitrenaydongloi.jpg"; source: "Music/TruocKhiTuoiTreNayDongLoi.mp3"}
        ListElement{title: "Nắng Ấm Ngang Qua"; singer: "Sơn Tùng-MTP"; icon: "Image/Conmuaxadan.jpg"; source: "Music/NangAmNgangQua.mp3"}
        ListElement{title: "Nói Là Làm"; singer: "Danmy - Karik - Mason"; icon: "Image/Noilalam.jpg"; source: "Music/NoiLaLam.mp3"}
        ListElement{title: "Ngày Nào"; singer: "Datmaniac - Cá Hồi Hoang"; icon: "Image/Ngaynao.jpg"; source: "Music/Ngaynao.mp3"}
        ListElement{title: "Nhật Kí Vào Đời"; singer: "Karik - Thái VG"; icon: "Image/Nhatkivaodoi.jpg"; source: "Music/NhatKiVaoDoi.mp3"}
        ListElement{title: "Anh Đã Làm Gì Đâu"; singer: "Nhật Hoàng - Thùy Chi"; icon: "Image/Anhdalamgidau.jpg"; source: "Music/AnhDaLamGiDau.mp3"}
        ListElement{title: "Ôm Em Thật Lâu"; singer: "Mono"; icon: "Image/OmEmThatLau.jpg"; source: "Music/Omemthatlau.mp3"}


    }
    AppHeader{
        id: headerItem
        width: parent.width
        height: 235/3 //141
        playlistButtonStatus: drawer.opened ? 1 : 0
        onClickPlaylistButton: {
            if (!drawer.opened) {
                drawer.open()
            } else {
                drawer.close()
            }
        }
    }
    Image{
        id: playList_bg
        anchors.top: headerItem.bottom
        anchors.bottom: root.bottom
        width: 360 //675
        height: 478
        source: "Image/playlist.png"
        opacity: 0.2
    }

    Drawer {
        id: drawer
        modal: false
        closePolicy: Drawer.NoAutoClose
        y: 122
        width: 360 //675
        height: 478
        dim: false
        background: Rectangle{
            anchors.fill: parent
            color: "transparent"
        }
    ListView {
        id: mediaPlaylist
        model: appModel
        anchors.fill: parent
        clip: true
        spacing: 16/15 //2
        currentIndex: 0
        delegate: MouseArea {
            property variant myData: model
            implicitWidth: playlistItem.width
            implicitHeight: playlistItem.height
            Image {
                id: playlistItem
                width: 360 //675
                height: 119.5 //193
                source: "Image/playlist.png"
                opacity: 0.5
            }
            Text {
                text: model.title
                anchors.fill: parent
                anchors.leftMargin: 112/3 //70
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.pixelSize: 256/15 //32
            }
            onClicked: {
                mediaPlaylist.currentIndex = index
            }

            onPressed: {
                playlistItem.source = "Image/hold.png"
            }
            onReleased: {
                playlistItem.source = "Image/playlist.png"
            }
        }
        highlight: Image {
            source: "Image/playlist_item.png"
            Image {
                anchors.left: parent.left
                anchors.leftMargin: 8 //15
                anchors.verticalCenter: parent.verticalCenter
                width: 20
                height: 20
                source: "Image/playing.png"
            }
        }
        ScrollBar.vertical: ScrollBar {
            parent: mediaPlaylist.parent
            anchors.top: mediaPlaylist.top
            anchors.left: mediaPlaylist.right
            anchors.bottom: mediaPlaylist.bottom
        }
        onCurrentItemChanged: {
            player.source = mediaPlaylist.currentItem.myData.source
            album_art_view.currentIndex = mediaPlaylist.currentIndex
            player.play()
            play.source = "Image/pause.png"


            //backend.playerSourceChanged(player.source)
            backend.playerTitleChanged( mediaPlaylist.model.get(mediaPlaylist.currentIndex).title)
            backend.playerSingerChanged(mediaPlaylist.model.get(mediaPlaylist.currentIndex).singer)
            backend.playerIconChanged(mediaPlaylist.model.get(mediaPlaylist.currentIndex).icon)
        }
    }
}
    Text {
        id: audioTitle
        anchors.top: headerItem.bottom
        anchors.topMargin: 100/9 //20
        // anchors.left: mediaPlaylist.right
        // anchors.leftMargin: 32/3 //20
        x: drawer.opened ? 370 : 10
        Behavior on x {NumberAnimation{duration: 300; easing.type: Easing.Linear}}
        text: mediaPlaylist.model.get(mediaPlaylist.currentIndex).title
        color: "white"
        font.pixelSize: 96/5 //36
        onTextChanged: {
            textChangeAni.targets = [audioTitle,audioSinger]
            textChangeAni.restart()
        }
    }
    Text {
        id: audioSinger
        anchors.top: audioTitle.bottom
        anchors.left: audioTitle.left
        x: drawer.opened ? 370 : 10
        Behavior on x {NumberAnimation{duration: 300; easing.type: Easing.Linear}}
        text: mediaPlaylist.model.get(mediaPlaylist.currentIndex).singer
        color: "white"
        font.pixelSize: 256/15 //32
    }

    NumberAnimation {
        id: textChangeAni
        property: "opacity"
        from: 0
        to: 1
        duration: 400
        easing.type: Easing.InOutQuad
    }
    Text {
        id: audioCount
        anchors.top: headerItem.bottom
        anchors.topMargin: 100/9 //20
        anchors.right: parent.right
        anchors.rightMargin: 32/3 //20
        text: mediaPlaylist.model.count
        color: "white"
        font.pixelSize: 111/5 //36
    }
    Image {
        anchors.top: headerItem.bottom
        anchors.topMargin: 115/9 //23
        anchors.right: audioCount.left
        anchors.rightMargin: 16/3 //10
        source: "Image/music.png"
    }

    Component {
        id: appDelegate
        Item {
            // property variant myData: model
            width: 300//640/3 //400
            height: 300 //2000/9 //400
            scale: PathView.iconScale
            // Image {
            //     id: myIcon
            //     width: parent.width
            //     height: parent.height
            //     y: 100/9 //20
            //     anchors.horizontalCenter: parent.horizontalCenter
            //     source: album_art
            // }

            // MouseArea {
            //     anchors.fill: parent
            //     onClicked: album_art_view.currentIndex = index
            // }

            Image {
                id: myIcon
                width: parent.width
                height: parent.height
                y: 100/9 //20
                anchors.horizontalCenter: parent.horizontalCenter
                source: model.icon
                smooth: true
                scale: drawer.opened ? 0.7 : 1
                Behavior on scale { NumberAnimation { duration: 300; easing.type: Easing.Linear } }
                Behavior on width { NumberAnimation { duration: 300 } }
                Behavior on height { NumberAnimation { duration: 300 } }
            }

            MouseArea {
                anchors.fill: parent
                onClicked:{
                    album_art_view.currentIndex = index
                }
            }
        }
    }

    Path {
        id: pathOrginal
        startX: 10//16/3 //10
        startY: 10//250/9 //50
        PathAttribute { name: "iconScale"; value: 0.5 }
        PathLine { x: 412 ; y: 10 } //550 50
        PathAttribute { name: "iconScale"; value: 1.0 }
        PathLine { x: 825; y: 10 } //1100 50
        PathAttribute { name: "iconScale"; value: 0.5 }
    }
    Path{
        id: pathChanged
        startX: 16/3 //10
        startY: 250/9 //50
        PathAttribute { name: "iconScale"; value: 0.5 }
        PathLine { x: 880/3; y: 250/9 } //550 50
        PathAttribute { name: "iconScale"; value: 1.0 }
        PathLine { x: 5280/9; y: 250/9 } //1100 50
        PathAttribute { name: "iconScale"; value: 0.5 }
    }

    PathView {
        id: album_art_view
        width: drawer.opened ? 664 : 824//664
        height: 300//2000/9
        x: drawer.opened ? 400 : 100
        Behavior on x {
            NumberAnimation {
                duration: 300
                easing.type: Easing.Linear
            }}
        // anchors.left: mediaPlaylist.right
        //anchors.leftMargin: 80/3
        //anchors.top: headerItem.bottom
        //anchors.topMargin: 1500/9 //300
        y: 230
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        focus: true
        model: appModel
        delegate: appDelegate
        pathItemCount: 3
        path: drawer.opened ? pathChanged : pathOrginal
        // currentIndex: player.playlist.currentIndex
        // onCurrentIndexChanged: {
        //     if (currentIndex !== player.playlist.currentIndex) {
        //         player.playlist.currentIndex = currentIndex
        //     }
        // }
        highlightRangeMode: PathView.StrictlyEnforceRange
        onCurrentIndexChanged: {
            mediaPlaylist.currentIndex = album_art_view.currentIndex
        }

    }
    //Progress
    Text {
        id: currentTime
        // anchors.bottom: parent.bottom
        // anchors.bottomMargin: 110 //250
        anchors.left: shuffer.left
        anchors.bottom: shuffer.top
        anchors.verticalCenterOffset: 10
        anchors.verticalCenter: progressBar.verticalCenter
        // anchors.leftMargin: 64 //120
        text: root.getTime(player.position)
        color: "white"
        font.pixelSize: 64/5 //24
    }
    Slider{
        id: progressBar
        width: 824//*player.position // (1491 - 675)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 105 //245
        anchors.leftMargin: 96/9
        // from: 0
        // to: player.duration
        // value: player.position
        enabled: player.seekable
        value: player.duration > 0 ? player.position / player.duration : 0
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
        transform: Scale {
            xScale: drawer.opened ? 0.55 : 1.0
            yScale: drawer.opened ? 0.55 : 1.0
        }
        x: drawer.opened ? 465 : 100
        Behavior on scale { NumberAnimation { duration: 300; easing.type: Easing.Linear } }
        Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.Linear }}
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
        onMoved: {
            // if (player.seekable){
            //     player.setPosition(Math.floor(position*player.duration))
            // }
            player.position = player.duration * progressBar.position
        }
    }
    Text {
        id: totalTime
        // anchors.bottom: parent.bottom
        // anchors.bottomMargin: 110 //250
        anchors.verticalCenter: progressBar.verticalCenter
        anchors.verticalCenterOffset: 10
        anchors.bottom: repeater.top
        anchors.right: repeater.right
        // anchors.left: progressBar.right
        // anchors.leftMargin: 96/9 //20
        text: root.getTime(player.duration)
        color: "white"
        font.pixelSize: 64/5 //24
    }
    //Media control
    SwitchButton {
        id: shuffer
        width1: 70
        height1: 40
        x: drawer.opened ? 410 : 50
        Behavior on x {NumberAnimation{duration: 300; easing.type: Easing.Linear}}
        anchors.bottom: root.bottom
        anchors.bottomMargin: 50 //120
        icon_off: "Image/shuffle.png"
        icon_on: "Image/shuffle-1.png"
        status:  0
        onClicked: {
            // console.log(player.playlist.playbackMode)
            // if (player.playlist.playbackMode === Playlist.Random) {
            //     player.playlist.playbackMode = Playlist.Sequential
            // } else {
            //     player.playlist.playbackMode = Playlist.Random
            // }
        }
    }
    ButtonControl {
        id: prev
        width1: 70
        height1: 40
        anchors.right: play.left
        x: -10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50 //120
        icon_default: "Image/prev.png"
        icon_pressed: "Image/hold-prev.png"
        icon_released: "Image/prev.png"
        onClicked: {
            if (shuffer.status==1) {
                var newIndex = Math.floor(Math.random() * mediaPlaylist.count)
                while (newIndex === mediaPlaylist.currentIndex) {
                    newIndex = Math.floor(Math.random() * mediaPlaylist.count)
                }
                mediaPlaylist.currentIndex = newIndex
            }
            else if(mediaPlaylist.currentIndex >0 && mediaPlaylist.currentIndex <= mediaPlaylist.model.count - 1){
                mediaPlaylist.currentIndex -=1
            }
            else if (mediaPlaylist.currentIndex === 0){
                mediaPlaylist.currentIndex = mediaPlaylist.model.count - 1
            }
        }
    }
    ButtonControl {
        id: play
        width1: 70
        height1: 70
        anchors.verticalCenter: prev.verticalCenter
        x: drawer.opened ? 660 : 477
        Behavior on x {NumberAnimation{duration: 300; easing.type: Easing.Linear}}
        icon_default: player.playbackState == MediaPlayer.PlayingState ?  "Image/pause.png" : "Image/play.png"
        icon_pressed: player.playbackState == MediaPlayer.PlayingState ?  "Image/hold-play.png" : "Image/hold-pause.png"
        icon_released: player.playbackState == MediaPlayer.PlayingState ?  "Image/play.png" : "Image/pause.png"
        onClicked: {
            switch(player.playbackState){
            case MediaPlayer.PlayingState: player.pause();  break;
            case MediaPlayer.PausedState: player.play(); break;
            case MediaPlayer.StoppedState: player.play();  break;
            }
        }
    }
    ButtonControl {
        id: next
        width1: 70
        height1: 40
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50 //120
        anchors.left: play.right
        x:10
        icon_default: "Image/next.png"
        icon_pressed: "Image/hold-next.png"
        icon_released: "Image/next.png"
        onClicked: {
            if (shuffer.status==1) {
                var newIndex = Math.floor(Math.random() * mediaPlaylist.count)
                while (newIndex === mediaPlaylist.currentIndex) {
                    newIndex = Math.floor(Math.random() * mediaPlaylist.count)
                }
                mediaPlaylist.currentIndex = newIndex
            }
            else if(mediaPlaylist.currentIndex >=0 && mediaPlaylist.currentIndex < mediaPlaylist.model.count - 1){
                mediaPlaylist.currentIndex +=1
            }
            else if (mediaPlaylist.currentIndex === mediaPlaylist.model.count - 1){
                mediaPlaylist.currentIndex = 0
            }
        }
    }
    SwitchButton {
        id: repeater
        width1: 70
        height1: 40
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50 //120
        x: 904
        icon_on: "Image/repeat1_hold.png"
        icon_off: "Image/repeat.png"
        status: /*player.playlist.playbackMode === Playlist.Loop ? 1 : 0*/ 0
        onClicked: {
        }
    }

    Component.onCompleted: {
        JS.dbInit()
        JS.readData()
        player.play()
    }
    Component.onDestruction:{
        JS.storeData()
    }
}
