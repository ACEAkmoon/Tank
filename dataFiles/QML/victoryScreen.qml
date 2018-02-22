//-------------------------------------------------
//
//     Налаштування кінцевого екрану
//
//-------------------------------------------------

import QtQuick 2.7
import QtMultimedia 5.8
import "./"

Rectangle {
    id: victoryIsScreen
    radius: 7
    width: height
    height: window.height
    anchors.horizontalCenter: window.horizontalCenter
    visible: true
    color: "black"
    focus: true

    property bool inputKeyboard: false

    Keys.onPressed: {
        animationWindowsExit.start()
    }

    //Анімація екрану
    SequentialAnimation {
        id: yAnimation
        running: true
        NumberAnimation {
            target: victoryIsScreen
            property: "y"
            from: 850; to: 0
            duration: 20000
        }
    }

    AnimatedImage {
        id: imageTanks
        width: parent.width / 1
        height: parent.height / 2
        source: "qrc:/dataFiles/Other/tiled/victory.gif"
        visible: true
        fillMode: Image.Stretch
        anchors.top: victoryIsScreen.top
        anchors.topMargin: parent.height / 250
        anchors.left: parent.left
    }

    //Налаштування музики кінцевого екрану
    MediaPlayer {
        id: soundGameOver
        autoLoad: true
        autoPlay: true
        source: "qrc:/dataFiles/Other/sound/soundVictory.mp3"
        volume: 1
    }

    //Анімація виходу із гри
    PropertyAnimation {
        id: animationWindowsExit
        target: window
        properties: "height"
        from: 800; to: 0
        duration: 2000
        running: false

        onStarted:{
            quitExit.start()
        }
    }

    Timer {
        id: quitExit
        running: false
        interval: 1900
        onTriggered: Qt.quit()
    }

    Text {
        id: infoText
        text: "Інформація"
        font.family: "Courier"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: imageTanks.bottom
        font.pixelSize: imageTanks.height / 20
        font.bold: true
        color: "white"
    }
    Text {
        id: creator
        width: 490
        height: 18
        text: "Розробник: Крушинський Олександр"
        font.family: "Courier"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: infoText.bottom
        anchors.topMargin: 15
        font.pixelSize: parent.height / 30
        font.bold: true
        color: "#fdc73e"
    }
    Text {
        id: email
        width: 490
        height: 18
        text: "Поштова скринька: alexkrush.ak@gmail.com"
        font.family: "Courier"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: creator.bottom
        anchors.topMargin: 15
        font.pixelSize: parent.height / 30
        font.bold: true
        color: "#fdc73e"
    }
    Text {
        id: sourceObj
        width: 490
        height: 130
        text: "Музика: із гри <S.T.A.L.K.E.R.-Тіні Чорнобиля>\n       від Української студія <GSC Game World>\nЗвукові ефекти та зображення:\n       із пошукового ресурсу www.google.com.ua\n\nРозроблено згідно ТЗ компанії<Luxoft>\nдля відбірного туру на інтерна\r\n"
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignLeft
        font.family: "Courier"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: email.bottom
        anchors.topMargin: 15
        font.pixelSize: parent.height / 30
        font.bold: true
        color: "#fdc73e"
    }
    Text {
        id: pressKey
        text: "НАТИСНИ ДЛЯ ВИХОДУ"
        font.family: "Courier"
        visible: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: sourceObj.bottom
        anchors.topMargin: 50
        font.pixelSize:  parent.height / 48
        font.bold: true
        color: "white"
    }
    //Таймер мерехтіння кнопки
    Timer {
        id: timerPressKey
        running: true
        repeat: true
        interval: 1500
        onTriggered: pressKey.visible = !pressKey.visible
    }
}
