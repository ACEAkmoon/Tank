//-------------------------------------------------
//
//       Налаштування вибуху техніки
//
//-------------------------------------------------

import QtQuick 2.7
import QtMultimedia 5.8

AnimatedImage {
    width: 12
    height: 12
    fillMode: Image.Stretch
    source: "qrc:/dataFiles/Other/tiled/explosion.gif"
    playing: false
    visible: playing
    opacity: 0.8

    property bool isExplosion: true
    property int player: -1

    signal finishedAnimation()

    function startAnimation() {
        if(!playing) {
            playing = true;
            explosionTimer.restart();
        }
    }

    Timer {
        id: explosionTimer
        interval: 700
        running: false
        repeat: false
        onTriggered: {
            finishedAnimation()
            visible = false
        }
    }
}
