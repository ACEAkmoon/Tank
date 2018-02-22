//-------------------------------------------------
//
//     Налаштування вибуху кулі
//
//-------------------------------------------------

import QtQuick 2.7
import QtMultimedia 5.8

AnimatedImage {
    id: explosionMiss
    width: 19
    height: 17
    fillMode: Image.Stretch
    source: "qrc:/dataFiles/Other/tiled/explosionMiss.gif"
    visible: playing
    playing: false
    opacity: 0.8

    property bool isExplosion: true
    property int player: -1

    property int xMap: Math.round(objectMap.typeTiled.length * x / (objectMap.width)) - 1
    property int yMap: Math.round(objectMap.typeTiled.length * y / (objectMap.height)) - 1

    signal finishedAnimation()

    function startAnimation() {
        bulletExpSound.play()
        playing = true;
        explosionTimer.restart();
    }

    //Звукове супроводження поцілення кулі
    SoundEffect {
        id: bulletExpSound
        source: "qrc:/dataFiles/Other/sound/bombExp.wav"
        volume: 0.8
    }

    Timer {
        id: explosionTimer
        interval: 300
        running: false
        repeat: false
        onTriggered: finishedAnimation()
    }
}
