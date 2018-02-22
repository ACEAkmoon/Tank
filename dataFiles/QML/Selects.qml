//-------------------------------------------------
//
//       Налаштування ефекту вибору
//
//-------------------------------------------------

import QtQuick 2.7

Rectangle {
    id: splash
    height: 28
    width: 32
    radius: 7
    color: "#00000000"

    property int type: 0
    property int xMap: Math.round(objectMap.typeTiled.length * x / (objectMap.width)) - 1
    property int yMap: Math.round(objectMap.typeTiled.length * y / (objectMap.height)) - 1

    Behavior on y {
        SpringAnimation {
            spring: 5
            damping: 0.2
        }
    }

    AnimatedImage
    {
        id: splashAnimations
        anchors.fill: splash
        source: "qrc:/dataFiles/Other/tiled/selects.gif"
    }
}
