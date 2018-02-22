//-------------------------------------------------
//
//     Налаштування фону екрану інформації та допомоги
//
//-------------------------------------------------

import QtQuick 2.7
import QtMultimedia 5.8

Image {
    id: backgroundMain
    visible: true
    anchors.centerIn: parent
    width: parent.width / 1
    height: parent.height / 1
    source: "qrc:/dataFiles/Other/tiled/background.png"
    fillMode: Image.PreserveAspectFit

    MediaPlayer {
        id: backgroundSound
        autoLoad: true
        autoPlay: true
        source: "qrc:/dataFiles/Other/sound/soundBackground.mp3"
        volume: 1
    }
    AnimatedImage
    {
        id: fireBackground
        width: parent.width / 1
        height: parent.height / 2
        fillMode: Image.Stretch
        anchors.bottom: backgroundMain.bottom
        source: "qrc:/dataFiles/Other/tiled/fireBackground.gif"
        visible: true
        playing: true
        opacity: 0.8
    }
}
