//-------------------------------------------------
//
//     Налаштування кінцевого екрану
//
//-------------------------------------------------

import QtQuick 2.7
import QtMultimedia 5.8
import "./"

Rectangle {
    id: isEndScreen
    radius: 7
    width: height
    height: window.height
    anchors.horizontalCenter: window.horizontalCenter
    visible: true
    color: "black"
    focus: true

    property bool inputKeyboard: false

    //Анімація екрану
    SequentialAnimation {
        id: yAnimation
        running: true
        NumberAnimation {
            target: isEndScreen
            property: "y"
            from: 1000; to: 0
            duration: 1000
        }
    }

    Image {
        id: imageGameOver
        width: parent.width / 1
        height: parent.height / 2
        source: "qrc:/dataFiles/Other/tiled/gameOver.png"
        visible: true
        fillMode: Image.Stretch
        anchors.top: isEndScreen.top
        anchors.topMargin: parent.height / 250
        anchors.left: parent.left
    }

    //Налаштування музики кінцевого екрану
    MediaPlayer {
        id: soundGameOver
        autoLoad: true
        autoPlay: true
        source: "qrc:/dataFiles/Other/sound/fail.wav"
        volume: 1
    }

    //Функція переходу на інший екран
    Keys.onPressed: {
        if(yAnimation.running) yAnimation.complete()

        else if(event.key === Qt.Key_Down) {
            if(select.state < 2) ++select.state;
            else select.state = 0;
        }
        else if(event.key === Qt.Key_Up) {
            if(select.state > 0) --select.state;
            else select.state = 2;
        }
        else if(event.key === Qt.Key_Return) {
            if(!select.state) pageLoader.setSource("canvas.qml")
            else if(select.state === 1) pageLoader.setSource("mainScreen.qml")
            else if(select.state === 2) animationWindowsExit.start()  //Qt.quit ({"timerExit":true})
        }
    }

    //Анімація виходу із гри
    PropertyAnimation {
        id: animationWindowsExit
        target: window
        properties: "height"
        from: 800; to: 0
        duration: 700
        running: false

        onStarted:{
            quitExit.start()
        }
    }

    Timer {
        id: quitExit
        running: false
        interval: 650
        onTriggered: Qt.quit()
    }

    //Функція вибору
    Selects{
        id: select
        type: -1
        anchors.right: returngame.left
        anchors.rightMargin: 4
        anchors.verticalCenter: state === 0 ? returngame.verticalCenter : state === 1 ? mainManu.verticalCenter : state === 2 ? exitgame.verticalCenter : exitgame.verticalCenter

        property int state: 0
        xMap: 0
        yMap: 0
    }

    //Позиція та відображення тексту кінцевого вікна
    Text {
        id: returngame
        width: parent.width / 5
        text: qsTr("Cпробувати знову")
        font.pixelSize: 150
        font.bold: true
        font.family: "Courier"
        visible: true
        color: "Red"

        anchors.top: imageGameOver.bottom
        anchors.topMargin: parent.height / 100
        anchors.left: parent.left
        anchors.leftMargin: parent.height / 2.3
    }

    Text {
        id: mainManu
        width: parent.width / 5
        text: qsTr("Повернутись в меню")
        font.pixelSize: 150
        font.bold: true
        font.family: "Courier"
        visible: true
        color: "Red"

        anchors.top: returngame.bottom
        anchors.topMargin: parent.height / 145
        anchors.left: parent.left
        anchors.leftMargin: parent.height / 2.3
    }

    Text {
        id: exitgame
        width: parent.width / 2
        text: qsTr("Вийти")
        font.pixelSize: 150
        font.bold: true
        font.family: "Courier"
        color: "Red"

        anchors.top: mainManu.bottom
        anchors.topMargin: parent.height / 145
        anchors.left: parent.left
        anchors.leftMargin: parent.height / 2.3

        Timer {
            id: timerReturn
            running: false
            repeat: true
            interval: 30
            onTriggered: exitgame.visible = !exitgame.visible
        }
    }
}
