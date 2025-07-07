import QtQuick
import QtQuick.Controls
import QtLocation
import QtPositioning

Item {
    id: root
    width: 1024
    height: 600

    Item {
        id: startAnimation
        XAnimator{
            target: root
            from: 1024
            to: 0
            duration: 200
            running: true
        }
    }

    Plugin {
        id: mapPlugin
        name: "mapboxgl"
        PluginParameter { name: "mapboxgl.access_token"; value: "pk.eyJ1IjoiaG9haW5hbTE2MTE5IiwiYSI6ImNtOHZwN3ljMjBrbjcycnEwZzl2Z2lsZ3IifQ.unjVZcWgvFaqTLEzopGEog"}




    }
    MapQuickItem {
        id: marker
        anchorPoint.x: image.width/4
        anchorPoint.y: image.height
        coordinate: QtPositioning.coordinate(21.03, 105.78)

        sourceItem: Image {
            id: image
            source: "qrc:/Img/Map/car_icon.png"
        }
    }
    Map {
        id: map
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(21.03, 105.78)
        zoomLevel: 14
        copyrightsVisible: false
        Component.onCompleted: {
            map.addMapItem(marker)
        }
    }
}
