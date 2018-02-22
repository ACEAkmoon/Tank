//-------------------------------------------------
//
//       Розташування плиток на карті
//
//-------------------------------------------------

import QtQuick 2.7
import QtQuick.Controls 2.1
import QtMultimedia 5.8
import QtLocation 5.0
import "./"

Rectangle {
    id: rootCanvas
    radius: 2
    color: "#001104"
    opacity: 0.85

    signal deleteTiled()

    property var typeTiled: [[]]
    property real widthTiled: width / typeTiled[0].length
    property real heightTiled: height / typeTiled.length
    property int player: -1
    property int pointRespawnEnemy: 0


    onPointRespawnEnemyChanged:{
        if(pointRespawnEnemy > 2)
            pointRespawnEnemy = 0;
    }

    function startTimer() {
        toPlaceTileTimer.restart()
    }

    Timer {
        id: toPlaceTileTimer
        running: false
        repeat: false
        interval: 1
        onTriggered: {
            toPlaceTile()
        }
    }

    //Функція створення плиток
    function toPlaceTile() {
        parent.visible = true;

        var imageWidth = rootCanvas.width / typeTiled[0].length
        var imageHeight = rootCanvas.height / typeTiled.length

        for(var a = 0; a < typeTiled.length; ++a)
            for(var b = 0; b < typeTiled[a].length; ++b) {
                var brick;
                var isConcrete;
                var isBrick;
                var isWater;
                var isGrass;

                //Плитка кірпіч
                if(typeTiled[a][b] === 1) {
                    isConcrete = true
                    isBrick = true

                    var tiled = Qt.createQmlObject ('import QtQuick 2.7;
                                                    import QtLocation 5.6;
                                                Image{
                                                    x: ' + b + ' * ' + imageWidth + ';
                                                    y: ' + a + ' * ' + imageHeight + ';
                                                    width: ' + imageWidth + ';
                                                    height: ' + imageHeight + ';

                                                    property int player: -1;
                                                    property int xMap: ' + a + ';
                                                    property int yMap: ' + b + ';
                                                    property bool isBullet: false;
                                                    property bool isExplosion: false;
                                                    property bool concrete: ' + isConcrete + ';
                                                    property bool brick: ' + isBrick + ';

                                                    fillMode: Image.Stretch;
                                                    source: "qrc:/dataFiles/Other/tiled/brick.png"
                                                }', rootCanvas);
                    rootCanvas.deleteTiled.connect(tiled.destroy);
                }
                //Плитка бетон
                else if(typeTiled[a][b] === 2) {
                    isConcrete = true

                    var tiled = Qt.createQmlObject ('import QtQuick 2.7;
                                                     import QtLocation 5.6;
                                                    Image{
                                                        x: ' + b + ' * ' + imageWidth + ';
                                                        y: ' + a + ' * ' + imageHeight + ';
                                                        width: ' + imageWidth + ';
                                                        height: ' + imageHeight + ';

                                                        property int player: -1;
                                                        property int xMap: ' + a + ';
                                                        property int yMap: ' + b + ';
                                                        property bool isBullet: false;
                                                        property bool concrete: ' + isConcrete + ';

                                                        fillMode: Image.Stretch;
                                                        source: "qrc:/dataFiles/Other/tiled/concrete.png"
                                                    }', rootCanvas);
                    rootCanvas.deleteTiled.connect(tiled.destroy);
                }
                //Плитка трава
                else if(typeTiled[a][b] === 3) {
                    isGrass = true

                    var tiled = Qt.createQmlObject ('import QtQuick 2.7;
                                                     import QtLocation 5.6;
                                                    AnimatedImage {
                                                        x: ' + b + ' * ' + imageWidth + ';
                                                        y: ' + a + ' * ' + imageHeight + ';
                                                        width: ' + imageWidth + ';
                                                        height: ' + imageHeight + ';

                                                        property int player: -1;
                                                        property int xMap: ' + a + ';
                                                        property int yMap: ' + b + ';
                                                        property bool isBullet: false;
                                                        property bool grass: ' + isGrass + ';

                                                        fillMode: Image.Stretch;
                                                        source: "qrc:/dataFiles/Other/tiled/grass.gif"
                                                        opacity: 0.7
                                                    }', rootCanvas);
                    rootCanvas.deleteTiled.connect(tiled.destroy);
                }
                //Плитка вода
                else if(typeTiled[a][b] === 4) {
                    isWater = true

                    var tiled = Qt.createQmlObject ('import QtQuick 2.7;
                                                     import QtLocation 5.6;
                                                    AnimatedImage {
                                                        x: ' + b + ' * ' + imageWidth + ';
                                                        y: ' + a + ' * ' + imageHeight + ';
                                                        width: ' + imageWidth + ';
                                                        height: ' + imageHeight + ';

                                                        property int player: -1;
                                                        property int xMap: ' + a + ';
                                                        property int yMap: ' + b + ';
                                                        property bool isBullet: false;
                                                        property bool water: ' + isWater + ';

                                                        fillMode: Image.Stretch;
                                                        source: "qrc:/dataFiles/Other/tiled/water.gif"
                                                        opacity: 0.9
                                                    }', rootCanvas);
                    rootCanvas.deleteTiled.connect(tiled.destroy);
                }
            }
    }
}
