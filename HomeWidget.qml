import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQml.Models

Item {
    id: root
    width: 1024
    height: 548 //1096
    function openApplication(url){
        parent.pop()
        parent.push(url)
    }

   ListView {
       id: lvWidget
       spacing: 16/3 //10
       orientation: ListView.Horizontal
       width: 1024
       height: 285 //950/3 //570
       interactive: false

       displaced: Transition {
           NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
       }

       model: DelegateModel {
           id: visualModelWidget
           model: ListModel {
               id: widgetModel
               ListElement { type: "map" }
               ListElement { type: "climate" }
               ListElement { type: "media" }
           }

           delegate: DropArea {
               id: delegateRootWidget
               width: 1016/3 //635
               height: 285 //950/3 //570
               keys: ["widget"]

               onEntered: {
                   visualModelWidget.items.move(drag.source.visualIndex, iconWidget.visualIndex)
                   iconWidget.item.enabled = false
               }
               property int visualIndex: DelegateModel.itemsIndex
               Binding { target: iconWidget; property: "visualIndex"; value: visualIndex }
               onExited: iconWidget.item.enabled = true
               onDropped: {
                   console.log(drop.source.visualIndex)
               }

               Loader {
                   id: iconWidget
                   property int visualIndex: 0
                   width: 1016/3 //635
                   height: 285 //950/3 //570
                   anchors {
                       horizontalCenter: parent.horizontalCenter;
                       verticalCenter: parent.verticalCenter
                   }

                   sourceComponent: {
                       switch(model.type) {
                       case "map": return mapWidget
                       case "climate": return climateWidget
                       case "media": return mediaWidget
                       }
                   }

                   Drag.active: iconWidget.item.drag.active
                   Drag.keys: "widget"
                   Drag.hotSpot.x: delegateRootWidget.width/2
                   Drag.hotSpot.y: delegateRootWidget.height/2

                   states: [
                       State {
                           when: iconWidget.Drag.active
                           ParentChange {
                               target: iconWidget
                               parent: root
                           }

                           AnchorChanges {
                               target: iconWidget
                               anchors.horizontalCenter: undefined
                               anchors.verticalCenter: undefined
                           }
                       }
                   ]
               }
           }
       }

       Component {
           id: mapWidget
           MapWidget{
               onClicked: {openApplication("Media.qml")}
           }
       }
       Component {
           id: climateWidget
           ClimateWidget {
               onClicked: {openApplication("Climate.qml")}
           }
       }
       Component {
           id: mediaWidget
           MediaWidget{
               onClicked: {
                  openApplication("Media.qml")
               }
           }
       }
   }

    ListView {
        x: 0
        y: 285 //950/3 //570
        width: 1024; height: 302 //3020/9 //526
        orientation: ListView.Horizontal
        interactive: false
        spacing: 8/3 //5

        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }

        model: DelegateModel {
            id: visualModel
            model: appsModel
            delegate: DropArea {
                id: delegateRoot
                width: 2528/15 //316
                height: 302 //2630/9 //604
                keys: "AppButton"

                onEntered: visualModel.items.move(drag.source.visualIndex, icon.visualIndex)
                property int visualIndex: DelegateModel.itemsIndex
                Binding { target: icon; property: "visualIndex"; value: visualIndex }

                Item {
                    id: icon
                    property int visualIndex: 0
                    width: 2528/15 //316
                    height: 302 //2630/9 //604
                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter
                    }

                    AppButton{
                        id: app
                        anchors.fill: parent
                        title: model.title
                        icon: model.iconPath
                        onClicked: openApplication(model.url)
                        onReleased: {
                            app.focus = true
                            app.state = "Focus"
                            for (var index = 0; index < visualModel.items.count;index++){
                                if (index !== icon.visualIndex)
                                    visualModel.items.get(index).focus = false
                                else
                                    visualModel.items.get(index).focus = true
                            }
                        }
                    }

                    onFocusChanged: app.focus = icon.focus

                    Drag.active: app.drag.active
                    Drag.keys: "AppButton"

                    states: [
                        State {
                            when: icon.Drag.active
                            ParentChange {
                                target: icon
                                parent: root
                            }

                            AnchorChanges {
                                target: icon
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                }
            }
        }
    }
    ListModel {
        id: appsModel

        ListElement {
            title: "Map"
            iconPath: "Img/HomeScreen/btn_home_menu_map"
        }
        ListElement {
            title: "Video"
            iconPath: "Img/HomeScreen/btn_home_menu_climate"
            //url: "Video.qml"
        }
        ListElement {
            title: "Media"
            iconPath: "Img/HomeScreen/btn_home_menu_media"
            url: "Media.qml"
        }
        ListElement {
            title: "Phone"
            iconPath: "Img/HomeScreen/btn_home_menu_phone"
        }
        ListElement {
            title: "Radio"
            iconPath: "Img/HomeScreen/btn_home_menu_radio"
        }
        ListElement {
            title: "Settings"
            iconPath: "Img/HomeScreen/btn_home_menu_settings"
            url: "Setting.qml"
        }
    }

}
