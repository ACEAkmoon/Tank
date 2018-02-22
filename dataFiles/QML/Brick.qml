//-------------------------------------------------
//
//       Розташування плиток по осі X
//
//-------------------------------------------------

import QtQuick 2.7
import QtLocation 5.0
import "./"

Image{
    x: ' + b + ' * ' + imageWidth + '
    y: ' + a + ' * ' + imageHeight + '
    width: ' + imageWidth + '
    height: ' + imageHeight + '

    property int player: -1
    property int xMap: ' + a + '
    property int yMap: ' + b + '
    property bool base: false
    property bool isBullet: false
    property bool isExplosion: false
    property bool concrete: ' + isconcrete + '
    property bool brick: ' + isbrick + '

    fillMode: Image.Stretch
    source: "qrc:/dataFiles/Other/tiled/brick.png"


}
