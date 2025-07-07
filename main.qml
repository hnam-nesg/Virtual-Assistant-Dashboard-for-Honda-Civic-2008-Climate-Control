import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Effects

ApplicationWindow {
    id: window
    visible: true
    width: 1024 //1920
    height: 600 //1080
    visibility: Window.FullScreen
    Image {
        id: background
        width: 1024 //1920
        height: 600 //1200
        source: "Img/bg_full.png"
        fillMode: Image.PreserveAspectCrop
        //source: "Image/background.png"
    }
    MultiEffect {
        source: background
        anchors.fill: background
        blurEnabled: true
        blurMax: 32
        blur: 0.5
    }

    StatusBar {
        id: statusBar
        onBntBackClicked: stackView.pop()
        isShowBackBtn: stackView.depth === 1 ? false : true
    }

    StackView {
        id: stackView
        width: 1024 //1920
        anchors.top: statusBar.bottom
        initialItem: HomeWidget{}
        onCurrentItemChanged: {
            currentItem.forceActiveFocus()
        }
        pushExit: Transition {
            XAnimator {
                from: 0
                to: -1024 //-1920
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
    }
}
