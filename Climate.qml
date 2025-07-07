import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore
import QtQuick.LocalStorage
import "DataClimate.js" as JS

Item{
    id: window
    property var db;
    property var list: []
    property var list_auto: []
    property string condition1: "onface"
    property string condition2: "on"
    property var mode: 0
    property var mode_rec: 0
    property var temp_auto: 0
    Image {
        id: background
        width: 1024 //1920
        height: 600 //1200
        //source: "Image/background.png"
        //source: "Img/bg_full.png"
    }
    Column{
        id: columnId
        Item{
            id: phan2
            width:window.width
            height: 100
            Row{
                x:99.25
                spacing: 208.5
                Image{
                    id: imagefanid
                    y:15
                    width:50
                    height:50
                    source: "Image/rear.png"
                    scale: mousefanid.pressed ? 0.8 : 1.0
                    Behavior on scale { NumberAnimation { duration: 50; } }
                    Text{
                        id: textfanid
                        anchors.top:parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Front"
                        //font.bold: true
                        font.pointSize: 15
                        color:"white"
                    }
                    Connections{
                        target: backend
                        function onFanOn(sour, sourc, color, count){
                            imagefanid.source = sour
                            imagefancid.source = sourc
                            textfanid.color = color
                            mousefanid.count = count
                        }
                    }
                    Image{
                        id: imagefancid
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 12
                        width:248.5
                        height:100
                        source: "Image/bg_climate_info_01.png"
                        MouseArea{
                            id: mousefanid
                            property int count: 0
                            property url sour: ""
                            hoverEnabled: true
                            anchors.fill:parent
                            onClicked:{
                                if (count == 0){
                                    lightBeam1.opacity = 0
                                    lightBeam1.count = 0
                                    backend.modeUpChanged(0)
                                    count = 1
                                    imagefanid.source = "Image/rearb.png"
                                    sour= "Image/bg_widget_f.png"
                                    textfanid.color = "#00EAFF"
                                    if(lightBeam3.count == 1){
                                        backend.clickModeChanged(5.9-window.mode,7,4,5,6,8)
                                        backend.ReadPreMode(5.9)
                                        window.mode = 5.9
                                    }
                                    else{
                                        backend.clickModeChanged(7.8-window.mode,8,4,5,6,7)
                                        backend.ReadPreMode(7.8)
                                        window.mode = 7.8
                                    }
                                }
                                else if (lightBeam3.count == 1){
                                    imagefanid.source = "Image/rear.png"
                                    sour= ""
                                    textfanid.color = "white"
                                    count = 0
                                    backend.clickModeChanged(3.9-window.mode,6,4,5,7,8)
                                    backend.ReadPreMode(3.9)
                                    window.mode = 3.9
                                }
                            }
                            onEntered: {
                                imagefancid.source = "Image/bg_widget_f.png"
                            }
                            onExited: {
                                if(sour!= "" ){
                                    imagefancid.source = sour
                                }
                                else {
                                    imagefancid.source = "Image/bg_climate_info_01.png"
                                }
                            }
                        }
                    }
                }
                Image{
                    id: imagerearid
                    y:15
                    width:50
                    height:50
                    source: "Image/rear-icon.png"
                    scale: mouserearid.pressed ? 0.8 : 1.0
                    Behavior on scale { NumberAnimation { duration: 50; } }
                    Text{
                        id: textrearid
                        anchors.top: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Rear"
                        //font.bold: true
                        font.pointSize: 15
                        color:"white"
                    }
                    Connections{
                        target: backend
                        function onRearOn(sour, sourc, color, count){
                            imagerearid.source = sour
                            imagerearcid.source = sourc
                            textrearid.color = color
                            mouserearid.count = count

                        }
                    }
                    Image{
                        id: imagerearcid
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 12
                        width:248.5
                        height:100
                        source: "Image/bg_climate_info_01.png"

                        MouseArea{
                            id: mouserearid
                            property int count: 0
                            property url sour: ""
                            hoverEnabled: true
                            anchors.fill:parent
                            onClicked:{
                                if(count===1){
                                    imagerearid.source = "Image/rear-icon.png"
                                    sour= ""
                                    textrearid.color = "white"
                                    count=0
                                    backend.clickRear(12, 11)
                                }
                                else{
                                    imagerearid.source = "Image/rear-icon-blue.png"
                                    sour= "Image/bg_widget_f.png"
                                    textrearid.color = "#00EAFF"
                                    count=1
                                    backend.clickRear(11, 12)
                                }
                            }
                            onEntered: {
                                imagerearcid.source = "Image/bg_widget_f.png"
                            }
                            onExited: {
                                if(sour!= ""){
                                    imagerearcid.source = sour
                                }
                                else{
                                    imagerearcid.source = "Image/bg_climate_info_01.png"
                                }
                            }
                        }
                    }
                }

                Image{
                    id: imagerecirid
                    y:15
                    width:50
                    height:50
                    source: "Image/icons8-air-recirculation-100.png"
                    scale: mouserecirid.pressed ? 0.8 : 1.0
                    Behavior on scale { NumberAnimation { duration: 50; } }
                    Text{
                        id: textrecirid
                        anchors.top:parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Recirculation"
                        //font.bold: true
                        font.pointSize: 15
                        color: "white"
                    }
                    Connections{
                        target: backend

                        function onRecirOn(sour, sourc, color, count){
                            imagerecirid.source = sour
                            imagerecircid.source = sourc
                            textrecirid.color = color
                            mouserecirid.count = count
                        }
                    }
                    Image{
                        id: imagerecircid
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 12
                        width:248.5
                        height:100
                        source: "Image/bg_climate_info_01.png"

                        MouseArea{
                            id: mouserecirid
                            property int count: 0
                            property url sour: ""
                            hoverEnabled: true
                            anchors.fill:parent
                            onClicked:{
                                if(count===1){
                                    imagerecirid.source = "Image/icons8-air-recirculation-100.png"
                                    sour= ""
                                    textrecirid.color = "white"
                                    count=0
                                    backend.clickRecFrs(5,14,13)
                                    window.mode_rec = 5
                                }
                                else{
                                    imagerecirid.source = "Image/icons8-air-recirculation-100 (1).png"
                                    sour= "Image/bg_widget_f.png"
                                    textrecirid.color = "#00EAFF"
                                    count=1
                                    backend.clickRecFrs(0,13,14)
                                    window.mode_rec = 0
                                }
                            }
                            onEntered: {
                                imagerecircid.source = "Image/bg_widget_f.png"
                            }
                            onExited: {
                                if(sour!= ""){
                                    imagerecircid.source = sour
                                }
                                else{
                                    imagerecircid.source = "Image/bg_climate_info_01.png"
                                }
                            }
                        }
                    }
                }

                Image{
                    id: imageacid
                    y:15
                    width:50
                    height:50
                    source: "Image/AC.png"
                    scale: mouseacid.pressed ? 0.8 : 1.0
                    Behavior on scale { NumberAnimation { duration: 50; } }
                    Text{
                        id: textacid
                        anchors.top:parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "AC"
                        //font.bold: true
                        font.pointSize: 15
                        color:"white"
                    }
                    Connections{
                        target: backend

                        function onAcOn (sour, sourc, color, count){
                            imageacid.source = sour
                            imageaccid.source = sourc
                            textacid.color = color
                            mouseacid.count = count
                        }
                    }
                    Image{
                        id: imageaccid
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 12
                        width:248.5
                        height:100
                        source: "Image/bg_climate_info_01.png"

                        MouseArea{
                            id: mouseacid
                            property int count: 0
                            property url sour: ""
                            hoverEnabled: true
                            anchors.fill:parent
                            onClicked:{
                                if(count===1){
                                    imageacid.source = "Image/AC.png"
                                    sour= ""
                                    textacid.color = "white"
                                    count=0
                                    backend.clickAc(1, 1, 0)
                                }
                                else{
                                    imageacid.source = "Image/ACB.png"
                                    sour= "Image/bg_widget_f.png"
                                    textacid.color = "#00EAFF"
                                    count=1
                                    backend.clickAc(0, 0, 1)
                                }
                            }
                            onEntered: {
                                imageaccid.source = "Image/bg_widget_f.png"
                            }
                            onExited: {
                                if(sour!= ""){
                                    imageaccid.source = sour
                                }
                                else{
                                    imageaccid.source = "Image/bg_climate_info_01.png"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    Item{
        y:100
        width: 1024
        height:250
        Rectangle{
            id: item1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 100
            anchors.verticalCenterOffset: 0
            anchors.verticalCenter: parent.verticalCenter
            width: 500
            height:250
            color:"#00EAFF00"

            Canvas {
                id: lightBeam1
                property int count: 1
                property string color: "#0BC7EE"
                property real animationOffset: 0
                opacity: 1
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();

                    var gradient = ctx.createLinearGradient(animationOffset, height / 2, width + animationOffset, height / 2);
                    gradient.addColorStop(1, "transparent");
                    gradient.addColorStop(0.5, lightBeam1.color);
                    gradient.addColorStop(0.2, "transparent");

                    ctx.fillStyle = gradient;
                    ctx.beginPath();
                    ctx.moveTo(0, height * 0.5);
                    ctx.lineTo(width * 0.65, height * 0.3);
                    ctx.lineTo(width * 0.65, height * 0.1);
                    ctx.lineTo(width * 0.55, height * 0.1);
                    ctx.lineTo(0, height * 0.5);
                    ctx.closePath();
                    ctx.fill();
                }

                NumberAnimation on animationOffset {
                    from: -50
                    to: 100
                    duration: 500
                    loops: Animation.Infinite
                    easing.type: Easing.InOutQuad
                }

                onAnimationOffsetChanged: requestPaint()
            }
            Rectangle{
                id: rect1
                y: 50
                x: 50
                anchors.horizontalCenterOffset: 20
                width: 300
                height: 40
                rotation: -10
                color: "transparent"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if (lightBeam1.count ==0){
                            imagefanid.source = "Image/rear.png"
                            textfanid.color = "white"
                            imagefancid.source = "Image/bg_climate_info_01.png"
                            mousefanid.count = 0
                            mousefanid.sour = ""
                            lightBeam1.opacity = 1
                            lightBeam1.count = 1
                            backend.modeUpChanged(1)
                            if (lightBeam3.count == 1){
                                backend.clickModeChanged(1.9-window.mode,5,4,6,7,8)
                                backend.ReadPreMode(1.9)
                                window.mode = 1.9
                            }
                            else{
                                backend.clickModeChanged(0-window.mode,4,5,6,7,8)
                                backend.ReadPreMode(0)
                                window.mode = 0
                            }
                        }
                        else if (lightBeam3.count == 1){
                             lightBeam1.opacity = 0
                             lightBeam1.count = 0
                             backend.clickModeChanged(3.9-window.mode,6,4,5,7,8)
                             backend.ReadPreMode(3.9)
                             window.mode = 3.9
                        }
                    }
                }
            }

            Canvas {
                id: lightBeam2
                anchors.fill: parent
                property int count: 1
                property real animationOffset: 0
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();

                    var gradient = ctx.createLinearGradient(animationOffset, height / 2, width + animationOffset, height / 2);
                    gradient.addColorStop(1, "transparent");
                    gradient.addColorStop(0.5, "#0BC7EE");
                    gradient.addColorStop(0.2, "transparent");

                    ctx.fillStyle = gradient;
                    ctx.beginPath();
                    ctx.moveTo(0, height * 0.5);
                    ctx.lineTo(width * 0.7, height*0.3);
                    ctx.lineTo(width * 0.7, height*0.7);
                    ctx.lineTo(0, height * 0.5);
                    ctx.closePath();
                    ctx.fill();
                }
                NumberAnimation on animationOffset {
                    from: -50
                    to: 100
                    duration: 500
                    loops: Animation.Infinite
                    easing.type: Easing.InOutQuad
                }

                onAnimationOffsetChanged: requestPaint()
            }

            Canvas {
                id: lightBeam3
                anchors.fill: parent
                property int count: 1
                property real animationOffset: 0
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();

                    var gradient = ctx.createLinearGradient(animationOffset, height / 2, width + animationOffset , height / 2);
                    gradient.addColorStop(1, "transparent");
                    gradient.addColorStop(0.5, "#0BC7EE");
                    gradient.addColorStop(0.2, "transparent");

                    ctx.fillStyle = gradient;
                    ctx.beginPath();
                    ctx.moveTo(0, height * 0.5);
                    ctx.lineTo(width * 0.65, height * 0.7);
                    ctx.lineTo(width * 0.65, height * 0.9);
                    ctx.lineTo(width * 0.55, height * 0.9);
                    ctx.lineTo(0, height * 0.5);
                    ctx.closePath();
                    ctx.fill();
                }
                NumberAnimation on animationOffset {
                    from: -50
                    to: 100
                    duration: 500
                    loops: Animation.Infinite
                    easing.type: Easing.InOutQuad
                }

                onAnimationOffsetChanged: requestPaint()
            }
            Rectangle{
                id: rect3
                y: 160
                x: 50
                anchors.horizontalCenterOffset: 20
                width: 300
                height: 40
                rotation: 10
                color: "transparent"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if (lightBeam3.count == 1){
                            lightBeam3.opacity = 0
                            lightBeam3.count = 0
                            backend.modeDownChanged(0)
                            if (lightBeam1.count == 1){
                                backend.clickModeChanged(0-window.mode,4,5,6,7,8)
                                backend.ReadPreMode(0)
                                window.mode = 0
                            }
                            if(mousefanid.count == 1){
                                backend.clickModeChanged(7.8-window.mode,8,4,5,6,7)
                                backend.ReadPreMode(7.8) //6.36
                                window.mode = 7.8 //6.36
                            }
                        }
                        else{
                            lightBeam3.opacity = 1
                            lightBeam3.count = 1
                            backend.modeDownChanged(1)
                            if (lightBeam1.count == 1){
                                backend.clickModeChanged(1.9-window.mode,5,4,6,7,8)
                                backend.ReadPreMode(1.9)
                                window.mode = 1.9
                            }
                            else if(mousefanid.count == 1){
                                backend.clickModeChanged(5.9 - window.mode,7,4,5,6,8)
                                backend.ReadPreMode(5.9)
                                window.mode = 5.9
                            }
                        }
                    }
                }
            }

            Rectangle{
                id: rect2
                //y: 100
                anchors.verticalCenter: parent.verticalCenter
                x:60
                width: 300
                height: 60
                color: "transparent"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if (lightBeam2.count === 1){
                            lightBeam2.opacity = 0
                            lightBeam2.count = 0
                        }
                        else{
                            lightBeam2.opacity = 1
                            lightBeam2.count = 1
                        }
                    }
                }
            }
            Connections{
                target: backend

                function onDirectOnBody (opacity, count){
                    lightBeam2.opacity = opacity
                    lightBeam2.count = count
                }
                function onDirectOnFace (opacity, count){
                    lightBeam1.opacity = opacity
                    lightBeam1.count = count
                    window.mode = 0
                }
                function onDirectOnFoot (opacity, count){
                    lightBeam3.opacity = opacity
                    lightBeam3.count = count
                    window.mode = 3.9
                }
               function onGetmodeChanged(mode){
                    switch(mode){
                        case 0:
                            backend.ReadPreMode(0)
                            window.mode = 0
                            break
                        case 1:
                            backend.ReadPreMode(1.9)
                            window.mode = 1.9
                            break
                        case 2:
                            backend.ReadPreMode(3.9)
                            window.mode = 3.9
                            break
                        case 3:
                            backend.ReadPreMode(5.9)
                            window.mode = 5.9
                            break
                        case 4:
                            backend.ReadPreMode(7.8)
                            window.mode = 7.8
                            break
                    }
               }
            }
        }
        Image{
            width: 100
            height: 100
            x:250
            //y:250
            anchors.verticalCenter: parent.verticalCenter
            source: "Image/vecteezy_metal-exhaust-fan.png"
        }
        Image{
            width: 200
            height: 200
            x: 570//592
            //y:250
            anchors.verticalCenter: parent.verticalCenter
            source: "Image/vecteezy_generated-ai-showcasing-car-seat-with-black-and-white-design_46857291.png"
        }
    }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    Item{
        id: fanctrlid
        property int fanLevel: 2
        property int fanmemory: 0
        y:320
        width:1024
        height:100

        Item{
            width:100
            height:100
            Image{
                id: fandnid
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenterOffset: -10
                width:30
                height:30
                source:"Image/minfan.png"
            }
            Text{
                id: textdnid
                anchors.top: fandnid.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Off"
                color: "white"
                font.pointSize: 10
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    //if(fanctrlid.fanLevel>0 && fanctrlid.fanLevel <=5) fanctrlid.fanLevel -= 1
                    fanctrlid.fanLevel = 0
                    fanctrlid.fanmemory =0
                    backend.fanLevelChanged(0)
                    backend.clickSpeedFan(0)
                }
            }
        }
        Connections{
            target: backend
            function onFanLevelOn (fanLevel, fanmemory){
                fanctrlid.fanLevel = fanLevel
                fanctrlid.fanmemory = fanmemory
            }
        }

        Item{
            x:924
            width:100
            height:100
            Image{
                id: fanupid
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenterOffset: -10
                width:30
                height:30
                source:"Image/maxfan.png"

            }
            Text{
                id: textupid
                anchors.top: fanupid.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Max"
                color: "white"
                font.pointSize: 10
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    //if(fanctrlid.fanLevel>=0 && fanctrlid.fanLevel <5) fanctrlid.fanLevel += 1
                    fanctrlid.fanLevel = 5
                    fanctrlid.fanmemory = 5
                    backend.fanLevelChanged(5)
                    backend.clickSpeedFan(5)
                }
            }
        }

        Row {
            width: 804
            height: 50
            anchors.centerIn: parent
            spacing: 4
            Repeater {
                model: 5
                Image {
                    id: imagerepid
                    width: (794/5)
                    height: parent.height
                    source:  index < fanctrlid.fanLevel ? "Image/bg_widget_p.png" : "Image/bg_climate_info_01.png"
                    clip: true
                    scale: mouseFan.pressed ? 0.8 : 1.0
                    Behavior on scale { NumberAnimation { duration: 50; } }
                    MouseArea{
                        id: mouseFan
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked:{
                            switch(index){
                            case 0:
                                fanctrlid.fanLevel = 1
                                fanctrlid.fanmemory = 1
                                backend.fanLevelChanged(1)
                                backend.clickSpeedFan(1)
                                break
                            case 1:
                                fanctrlid.fanLevel = 2
                                fanctrlid.fanmemory = 2
                                backend.fanLevelChanged(2)
                                backend.clickSpeedFan(2)
                                break
                            case 2:
                                fanctrlid.fanLevel = 3
                                fanctrlid.fanmemory = 3
                                backend.fanLevelChanged(3)
                                backend.clickSpeedFan(3)
                                break
                            case 3:
                                fanctrlid.fanLevel = 4
                                fanctrlid.fanmemory = 4
                                backend.fanLevelChanged(4)
                                backend.clickSpeedFan(4)
                                break
                            case 4:
                                fanctrlid.fanLevel = 5
                                fanctrlid.fanmemory = 5
                                backend.fanLevelChanged(5)
                                backend.clickSpeedFan(5)
                                break
                            }
                        }

                        onEntered: {
                            switch(index){
                            case 0:
                                fanctrlid.fanLevel = 1
                                break
                            case 1:
                                fanctrlid.fanLevel = 2
                                break
                            case 2:
                                fanctrlid.fanLevel = 3
                                break
                            case 3:
                                fanctrlid.fanLevel = 4
                                break
                            case 4:
                                fanctrlid.fanLevel = 5
                                break
                            case 5:
                                fanctrlid.fanLevel = 6
                                break
                            case 6:
                                fanctrlid.fanLevel = 7
                                break
                            }
                        }
                        onExited: {
                            fanctrlid.fanLevel = fanctrlid.fanmemory
                        }
                    }
                }
            }
        }
    }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    Rectangle{
        y:420
        id: rectfootid
        width:1024
        height:100
        color:"#000000BA"
        Image{
            id: imagefootid
            width:300
            height:100
            anchors.centerIn: parent
            source:"Image/bg_climate_info_02.png"
            opacity:0.5
            scale: mouseAutoid.pressed ? 0.8 : 1.0
            Behavior on scale { NumberAnimation { duration: 50; } }
            MouseArea{
                id: mouseAutoid
                property int count: 0

                anchors.fill: parent
                onClicked: {
                    if(count===1){
                        imagefootid.source= "Image/bg_climate_info_02.png"
                        imagefootid.opacity = 0.5
                        textfootid.color = "white"
                        count=0
                        backend.clickAuto(0, 18, 15)
                        backend.autoChanged(0)
                    }
                    else{
                        imagefootid.source= "Image/bg_widget_f.png"
                        imagefootid.opacity = 1
                        textfootid.color = "#00EAFF"
                        count=1
                        backend.autoChanged(1)
                        backend.clickAuto(1, 15, 18)
                    }
                }
            }
        }
        Text{
            id: textfootid
            anchors.centerIn: parent
            text: " AUTO\nClimate"
            font.pointSize: 15
            color:"white"
            scale: mouseAutoid.pressed ? 0.8 : 1.0
            Behavior on scale { NumberAnimation { duration: 50; } }
        }
        Connections{
            target: backend

            function onAutoClimate(sour, color, opacity, count){
                imagefootid.source = sour
                textfootid.color = color
                imagefootid.opacity = opacity
                mouseAutoid.count = count
            }
        }
        Item{
            width:362
            height:100
            Text{
                id: seatdriverid
                property int temp: 20
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: -20
                anchors.verticalCenterOffset: -12
                text: temp + " °C"
                color:"white"
                font.pointSize: 25
            }
            Text{
                anchors.top: seatdriverid.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: -20
                text:"Driver"
                color:"white"
                font.pointSize: 15
            }
            Connections{
                target: backend
                function onTempOn(temp){
                    seatdriverid.temp = temp
                    backend.ReadTemp(seatdriverid.temp)
                }
                function onTempupChanged(){
                    if (seatdriverid.temp <30)
                    {
                        seatdriverid.temp += 1
                    }
                }
                function onTempdownChanged(){
                if (seatdriverid.temp !=16){
                        seatdriverid.temp -= 1
                    }
                }
                function onTemp_auto(temp){
                    window.temp_auto = temp
                }
            }

            Image{
                id: arrowdvuid
                width:50
                height:50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: 60
                source: "Image/ico_arrow_u_n.png"
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        if(seatdriverid.temp<30){
                            arrowdvuid.source = "Image/ico_arrow_u_p.png"
                            seatdriverid.temp +=1
                            seatpassid.temp +=1
                            backend.driverTempChanged(seatdriverid.temp)
                            backend.passengerTempChanged(seatpassid.temp)
                            backend.clickTempChanged(seatdriverid.temp)
                            if (mouseAutoid.count == 0){
                                backend.ReadTemp(seatdriverid.temp)
                            }
                        }
                        else{
                            arrowdvuid.source = "Image/ico_arrow_u_p.png"
                        }
                    }
                    onReleased: {
                        arrowdvuid.source = "Image/ico_arrow_u_n.png"
                    }
                }
            }
            Image{
                id: arrowdvdid
                width:50
                height:50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: 60
                anchors.top: arrowdvuid.bottom
                source: "Image/ico_arrow_d_n.png"
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        if(seatdriverid.temp!=16){
                            arrowdvdid.source = "Image/ico_arrow_d_p.png"
                            seatdriverid.temp -=1
                            seatpassid.temp -= 1
                            backend.driverTempChanged(seatdriverid.temp)
                            backend.passengerTempChanged(seatpassid.temp)
                            backend.clickTempChanged(seatdriverid.temp)
                            if (mouseAutoid.count == 0){
                                backend.ReadTemp(seatdriverid.temp)
                            }
                        }
                        else{
                            arrowdvdid.source = "Image/ico_arrow_d_p.png"
                        }
                    }
                    onReleased: {
                        arrowdvdid.source = "Image/ico_arrow_d_n.png"
                    }
                }
            }
        }

        Item{
            x:662
            width:362
            height:100
            Text{
                id: seatpassid
                property int temp: 20
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 20
                anchors.verticalCenterOffset: -12
                text: temp + " °C"
                color:"white"
                font.pointSize: 25
            }
            Text{
                anchors.top: seatpassid.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: 20
                text:"Passenger"
                color:"white"
                font.pointSize: 15
            }

            Connections{
                target: backend
                function onTempOn(temp){
                    seatpassid.temp = temp
                }
                function onTempupChanged(){
                    if (seatpassid.temp <30)
                    {
                        seatpassid.temp += 1
                    }
                }
                function onTempdownChanged(){
                if (seatpassid.temp !=16){
                        seatpassid.temp -= 1
                    }
                }
            }

            Image{
                id: arrowpsuid
                width:50
                height:50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: -60
                source: "Image/ico_arrow_u_n.png"
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        if(seatpassid.temp<30){
                            arrowpsuid.source = "Image/ico_arrow_u_p.png"
                            seatpassid.temp +=1
                            seatdriverid.temp +=1
                            backend.driverTempChanged(seatdriverid.temp)
                            backend.passengerTempChanged(seatpassid.temp)
                            backend.clickTempChanged(seatdriverid.temp)
                            if (mouseAutoid.count == 0){
                                backend.ReadTemp(seatdriverid.temp)
                            }
                        }
                        else{
                            arrowpsuid.source = "Image/ico_arrow_u_p.png"
                        }
                    }
                    onReleased: {
                        arrowpsuid.source = "Image/ico_arrow_u_n.png"
                    }
                }
            }
            Image{
                id: arrowpsdid
                width:50
                height:50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: -60
                anchors.top: arrowpsuid.bottom
                source: "Image/ico_arrow_d_n.png"
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        if(seatpassid.temp!=16){
                            arrowpsdid.source = "Image/ico_arrow_d_p.png"
                            seatpassid.temp -=1
                            seatdriverid.temp -=1
                            backend.driverTempChanged(seatdriverid.temp)
                            backend.passengerTempChanged(seatpassid.temp)
                            backend.clickTempChanged(seatdriverid.temp)
                            if (mouseAutoid.count == 0){
                                backend.ReadTemp(seatdriverid.temp)
                            }
                        }
                        else{
                            arrowpsdid.source = "Image/ico_arrow_d_p.png"
                        }
                    }
                    onReleased: {
                        arrowpsdid.source = "Image/ico_arrow_d_n.png"
                    }
                }
            }
        }
        Connections{
            target: backend
            function onSignal_auto(list){
                window.list_auto = list
            }
        }
    }
    Component.onCompleted:{
        JS.dbInit()
        JS.readData()
        backend.ReadPreMode(window.mode)
        if (mouseAutoid.count == 1){
            backend.ReadTempSetAuto(seatdriverid.temp)
            backend.ReadTemp(window.temp_auto)
        }
        else backend.ReadTemp(seatdriverid.temp)
        backend.ReadPreModeRec(window.mode_rec)
        backend.read_list(window.list)
        backend.List_auto(window.list_auto)
        backend.active_thread_fromqml()
    }
    Component.onDestruction:{
        var list_label = []
        list_label.push(mouserecirid.count== 0 ? 14:13)
        list_label.push(mouserearid.count==0 ? 12:11)
        list_label.push(mouseacid.count==0 ? 1:0)
        list_label.push(mouseAutoid.count==0 ? 18:15)
        list_label.push(20)
        if(mousefanid.count == 1 && lightBeam3.count == 0){
            list_label.push(8)
        }
        else if (lightBeam1.count ==1 && lightBeam3.count ==1 ){
            list_label.push(5)
        }
        else if(lightBeam1.count == 1 && lightBeam3.count==0){
            list_label.push(4)
        }
        else if(mousefanid.count == 0 && lightBeam3.count==1){
            list_label.push(6)
        }
        else if(lightBeam3.count ==1 && mousefanid.count ==1){
            list_label.push(7)
        }
        window.list = list_label
        JS.storeData()
    }
}

