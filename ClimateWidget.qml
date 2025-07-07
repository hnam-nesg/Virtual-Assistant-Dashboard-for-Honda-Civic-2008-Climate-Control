import QtQuick
import QtCore
import QtQuick.LocalStorage
import "Database.js" as JS
MouseArea {
    id: root
    property var db;
    implicitWidth: 1016/3 //635
    implicitHeight: 285 //950/3 //570
    scale: pressed ? 0.8 : 1.0
    Behavior on scale { NumberAnimation { duration: 100; }}
    Rectangle {
        anchors{
            fill: parent
            margins: 16/3 //10
        }
        opacity: 0.7
        color: "#111419"
    }
    Image {
        id: idBackgroud
        source: ""
        width: root.width
        height: root.height
    }
    Text {
        id: title
        anchors.horizontalCenter: parent.horizontalCenter
        y: 20 //200/9 //40
        text: "Climate"
        color: "white"
        font.pixelSize: 163.2/9 //34
    }

    Text {
        x: 68.8/3 //43
        y: 67.5 //75 //135
        width: 294.4/3 //184
        text: "DRIVER"
        color: "white"
        font.pixelSize: 163.2/9 //34
        horizontalAlignment: Text.AlignHCenter
    }
    Image {
        x:68.8/3 //43
        y: 88 //880/9 //(135+41)
        width: 883.2/9 //184
        source: "Img/HomeScreen/widget_climate_line.png"
    }
    Image {
        x: 169.6/3 //(55+25+26)
        y: 102.5 //1025/9 //205
        width: 176/3 //110
        height: 60 //200/3 //120
        source: "Img/HomeScreen/widget_climate_arrow_seat.png"
    }
    Image {
        id: driver_up
        x: 128/3 //(55+25)
        y: 119.5 //1195/9 //(205+34)
        width: 112/3 //70
        height: 25 //250/9 //50
        source: "Img/HomeScreen/widget_climate_arrow_01_n.png"

    }
    Image {
        id: driver_down
        x: 88/3 //55
        y: 132.5 //1325/9 //(205+34+26)
        width: 112/3 //70
        height: 250/9 //50
        source: "Img/HomeScreen/widget_climate_arrow_02_n.png"
    }
    Text {
        id: driver_temp
        property int temp: 0
        x: 68.8/3 //43
        y: 177.5 //1775/9 //(248 + 107)
        width: 883.2/9 //184
        text: temp + "°C"
        color: "white"
        font.pixelSize: 73.6/3 //46
        horizontalAlignment: Text.AlignHCenter
    }

    Text {
        x: 3272/15 //(43+184+182)
        y: 67.5 //75 //135
        width: 883.2/9 //184
        text: "PASSENGER"
        color: "white"
        font.pixelSize: 272/15 //34
        horizontalAlignment: Text.AlignHCenter
    }
    Image {
        x: 3272/15 //(43+184+182)
        y: 88 //880/9 //(135+41)
        width: 883.2/9  //184
        source: "Img/HomeScreen/widget_climate_line.png"
    }
    Image {
        x: 251.2 //(55+25+26+314+25+26)
        y: 102.5 //1025/9 //205
        width: 176/3 //110
        height: 60 //200/3 //120
        source: "Img/HomeScreen/widget_climate_arrow_seat.png"
    }
    Image {
        id: passenger_up
        x: 712/3 //(55+25+26+314+25)
        y: 119.5 //(205+34)
        width: 112/3 //70
        height: 25 //250/9 //50
        source: "Img/HomeScreen/widget_climate_arrow_01_n.png"
    }
    Image {
        id: passenger_down
        x: 224 //(55+25+26+314)
        y: 132.5 //1325/9 //(205+34+26)
        width: 112/3 //70
        height: 25 //250/9 //50
        source: "Img/HomeScreen/widget_climate_arrow_02_n.png"
    }
    Text {
        id: passenger_temp
        property int temp: 0
        x: 3272/15 //(43+184+182)
        y: 177.5 //1775/9 //(248 + 107)
        width: 883.2/9 //184
        text: temp + "°C"
        color: "white"
        font.pixelSize: 368/15 //46
        horizontalAlignment: Text.AlignHCenter
    }

    Image {
        x: 1376/15 //172
        y: 124 //1240/9 //248
        width: 464/3 //290
        height: 50 //500/9 //100
        source: "Img/HomeScreen/widget_climate_wind_level_bg.png"
    }
    Image {
        id: fan_level
        x: 1376/15 //172
        y: 124 //1240/9 //248
        width: 464/3 //290
        height: 50 //500/9 //100
        source: "Img/HomeScreen/widget_climate_wind_level_bg.png"
    }
    Connections{
        target: backend
        function onFanLevelOn (level, lv) {
            if (level < 1) {
                fan_level.source = "Img/HomeScreen/widget_climate_wind_level_bg.png"
            }
            else if (level < 5) {
                fan_level.source = "Img/HomeScreen/widget_climate_wind_level_0"+level*2+".png"
            } else {
                fan_level.source = "Img/HomeScreen/widget_climate_wind_level_"+level*2+".png"
            }
        }
        function onTempOn(temp){
            driver_temp.temp = temp
            passenger_temp.temp = temp
        }
        function onTempupChanged (){
            driver_temp.temp += 1
            passenger_temp.temp +=1
        }
        function onTempdownChanged(){
            driver_temp.temp -= 1
            passenger_temp.temp -=1
        }
        function onAutoClimate(sour,a,b,c){
            textAuto.color = c === 1 || 0 ? "white" : "gray"
        }
        function onWindUpChanged(windmode){
            driver_up.source = windmode === 1 | 0 ? "Img/HomeScreen/widget_climate_arrow_01_s_b.png" : "Img/HomeScreen/widget_climate_arrow_01_n.png"
            passenger_up.source = windmode === 1 | 0 ? "Img/HomeScreen/widget_climate_arrow_01_s_b.png" : "Img/HomeScreen/widget_climate_arrow_01_n.png"
        }
        function onWindDownChanged(windmode){
            driver_down.source = windmode === 1 | 0 ? "Img/HomeScreen/widget_climate_arrow_02_s_b.png" : "Img/HomeScreen/widget_climate_arrow_02_n.png"
            passenger_down.source = windmode === 1 | 0 ? "Img/HomeScreen/widget_climate_arrow_02_s_b.png" : "Img/HomeScreen/widget_climate_arrow_02_n.png"
        }
        function onFanChanged(level){
            if (level < 1) {
                fan_level.source = "Img/HomeScreen/widget_climate_wind_level_bg.png"
            }
            else if (level < 5) {
                fan_level.source = "Img/HomeScreen/widget_climate_wind_level_0"+level*2+".png"
            } else {
                fan_level.source = "Img/HomeScreen/widget_climate_wind_level_"+level*2+".png"
            }
        }
        function onDriverTemp(temp){
            driver_temp.temp = temp
        }
        function onPassengerTemp(temp){
            passenger_temp.temp = temp
        }
        function onAuto(auto){
            textAuto.color = auto === 1 || 0 ? "white" : "gray"
        }
        function onTemp_incar(temp){
            tempincar.temp = temp
        }
    }

    Image {
        x: 6888/45 //(172 + 115)
        y: 94 //1775/9 //(248 + 107)
        width: 32 //60
        height: 30 //100/3 //60
        source: "Img/HomeScreen/widget_climate_ico_wind.png"
    }

    Text {
        id: textAuto
        x: 16 //30
        y: 242 //2420/9 //(466 + 18)
        width: 1376/15 //172
        horizontalAlignment: Text.AlignHCenter
        text: "AUTO"
        color: "gray"
        font.pixelSize: 368/15 //46
    }
    Text {
        x: 1856/15 //(30+172+30)
        y: 233 //2330/9 //466
        width: 95 //171
        horizontalAlignment: Text.AlignHCenter
        text: "INSIDE"
        color: "white"
        font.pixelSize: 208/15 //26
    }
    Text {
        property var temp: 0
        id: tempincar
        x: 1856/15 //(30+172+30)
        y: 252.5 //2525/9 //(466 + 18 + 21)
        width: 95 //171
        horizontalAlignment: Text.AlignHCenter
        text: temp + "°C"
        color: "white"
        font.pixelSize: 304/15 //38
    }
    Text {
        x: 3464/15 //(30+172+30+171+30)
        y: 242 //2420/9 //(466 + 18)
        width: 95 //171
        horizontalAlignment: Text.AlignHCenter
        text: "SYNC"
        color: "white"
        font.pixelSize: 368/15 //46
    }
    //
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
    onPressed: root.state = "Pressed"
    onReleased:{
        root.focus = true
        root.state = "Focus"
    }
    onFocusChanged: {
        if (root.focus === true )
            root.state = "Focus"
        else
            root.state = "Normal"
    }
    Component.onCompleted:{
        JS.dbInit()
        JS.readData()
    }
    Component.onDestruction:{
        JS.storeData()
    }
}

