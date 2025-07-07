import QtQuick
import QtQuick.Layouts
import QtQml

Item {
	id: barId
    width: 1024 //1920
    height: 52 //520/9 //104
    signal bntBackClicked
    property bool isShowBackBtn: false
    property var temp_incar: 0
    property var temp_evap: 0
    Button {
        anchors.left: parent.left
        icon: "Img/StatusBar/btn_top_back"
        width: 72 //135
        height: 50.5 //505/9 //101
        iconWidth: width
        iconHeight: height
        onClicked:{
            bntBackClicked()
        }
        visible: isShowBackBtn
    }

    // Item {
    //     id: clockArea
    //     x: 352 //660
    //     width: 500/3 //300
    //     height: parent.height
    //     Image {
    //         anchors.left: parent.left
    //         height: 52 //520/9 //104
    //         source: "Img/StatusBar/status_divider.png"
    //     }
    //     Text {
    //         id: clockTime
    //         text: "10:28"
    //         color: "white"
    //         font.pixelSize: 192/5 //72
    //         verticalAlignment: Text.AlignVCenter
    //         horizontalAlignment: Text.AlignHCenter
    //         anchors.centerIn: parent
    //     }
    //     Image {
    //         anchors.right: parent.right
    //         height: 52 //520/9 //104
    //         source: "Img/StatusBar/status_divider.png"
    //     }
    // }
    // Item {
    //     id: dayArea
    //     anchors.left: clockArea.right
    //     width: 160 //300
    //     height: parent.height
    //     Text {
    //         id: day
    //         text: "Jun. 24"
    //         color: "white"
    //         font.pixelSize: 192/5 //72
    //         verticalAlignment: Text.AlignVCenter
    //         horizontalAlignment: Text.AlignHCenter
    //         anchors.centerIn: parent
    //     }
    //     Image {
    //         anchors.right: parent.right
    //         height: 52 //520/9 //104
    //         source: "Img/StatusBar/status_divider.png"
    //     }
    // }

    // QtObject {
    //     id: time
    //     property var locale: Qt.locale()
    //     property date currentTime: new Date()

    //     Component.onCompleted: {
    //         clockTime.text = currentTime.toLocaleTimeString(locale, "hh:mm");
    //         day.text = currentTime.toLocaleDateString(locale, "MMM. dd");
    //     }
    // }

    // Timer{
    //     interval: 1000
    //     repeat: true
    //     running: true
    //     onTriggered: {
    //         time.currentTime = new Date()
    //         clockTime.text = time.currentTime.toLocaleTimeString(locale, "hh:mm");
    //         day.text = time.currentTime.toLocaleDateString(locale, "MMM. dd");
    //     }

    // }
    Rectangle{
        id: phan1
        width: window.width
        height: 52
        color:"#000000BA"
        Text {

            id: timeText
            color: "white"
            font.pixelSize: 20
            font.bold: true
            anchors.centerIn: parent
            text: Qt.formatDateTime(new Date(), "hh:mm:ss")
    	}

	Text{
		id: t_incar
		color:"white"
		font.pixelSize: 20
		font.bold: true
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.horizontalCenterOffset: 80
		anchors.verticalCenter: parent.verticalCenter
		text: barId.temp_incar + "°C"
	}

	Text{
		id: t_evap
		color: "white"
		font.pixelSize: 20
		font.bold: true
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.horizontalCenterOffset: -80
		anchors.verticalCenter: parent.verticalCenter
		text: barId.temp_evap + "°C"
	}

	Connections{
		target: backend

		function onTemp_incar(temp){
			barId.temp_incar = temp
		}

		function onTemp_evap(temp){
			barId.temp_evap = temp
		}
	}
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                timeText.text =  Qt.formatDateTime(new Date(), "hh:mm:ss")
            }
        }
        // Text {
        //     x: 40
        //     id: timeTextDate
        //     color: "white"
        //     font.pixelSize: 20
        //     font.bold: true
        //     anchors.verticalCenter: parent.verticalCenter
        //     text: Qt.formatDateTime(new Date(), "ddd, dd-MM-yy")
        // }

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                timeText.text =  Qt.formatDateTime(new Date(), "ddd, dd-MM-yy")
            }
        }
        Image{
            x: 960
            id: batteryid
            width: 30
            height: 30
            anchors.verticalCenter: parent.verticalCenter
            source: "Img/StatusBar/indi_battery_05.png"
        }
        Image{
            x: 920
            id: wifiid
            width: 25
            height: 25
            anchors.verticalCenter: parent.verticalCenter
            source: "Img/StatusBar/indi_wifi_04.png"
        }
        Image{
            x: 870
            id: rssiid
            width: 40
            height: 40
            anchors.verticalCenter: parent.verticalCenter
            source: "Img/StatusBar/indi_rssi_bt_06.png"
        }
        Image{
            x: 845
            id: blid
            width: 52/3
            height: 30
            anchors.verticalCenter: parent.verticalCenter
            source: "Img/StatusBar/indi_dial_bt.png"
        }
    }

}
