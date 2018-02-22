//-------------------------------------------------
//
//     Налаштування бази гравця
//
//-------------------------------------------------

import QtQuick 2.7

AnimatedImage {
    width: 3.5 * objectMap.widthTiled
    height: 3.5 * objectMap.heightTiled

    source: "qrc:/dataFiles/Other/tiled/earth.gif"
    visible: true

    property int player: 0
    property bool isBullet: false
    property bool earth: true
    property bool concrete: true
    property bool brick: true
    property bool grass: true
    property bool water: true
}
