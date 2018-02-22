//-------------------------------------------------
//
//       Налаштування екрану головного вікна
//
//-------------------------------------------------

import QtQuick 2.7
import QtMultimedia 5.8
import QtQuick.Controls 2.1
import "./"

Rectangle {
    id: isMainScreen
    radius: 7
    width: height
    height: window.height
    visible: true
    color: "black"
    focus: true

    property bool inputKeyboard: false

    //Анімація екрану
    SequentialAnimation {
        id: xAnimation
        running: true
        NumberAnimation {
            target: isMainScreen
            property: "x"
            from: -1000; to: 0
            duration: 6000
        }
    }

    //Налаштування музики екрану
    MediaPlayer {
        id: soundMenu
        autoLoad: true
        autoPlay: true
        source: "qrc:/dataFiles/Other/sound/soundMenu.mp3"
        volume: 1
    }

    //Фонове зображення меню
    Image {
        id: imageTanks
        width: parent.width / 1
        height: parent.height / 2
        source: "qrc:/dataFiles/Other/tiled/tankMenu.png"
        visible: true
        fillMode: Image.Stretch
        anchors.centerIn: parent

        MovingSmoke{
            x: 15
            y: 15
            width: 125
            height: 125
        }
    }

    //Функція вибору
    Selects {
        id: select
        width: 30
        height: 30
        type: -1
        visible: true
        anchors.right: startgame.left
        anchors.rightMargin: 4
        anchors.verticalCenter: state === 0 ? startgame.verticalCenter : state === 1 ? supportText.verticalCenter : state === 2 ? infoText.verticalCenter : state === 3 ? exit.verticalCenter : exit.verticalCenter

        property int state: 0

        xMap: 0
        yMap: 0
    }

    //наналаштування вибору в меню
    Keys.onPressed: {
        if(xAnimation.running) xAnimation.complete()

        else if(event.key === Qt.Key_Down) {
            if(select.state < 3) ++select.state
            else select.state = 0
        }
        else if(event.key === Qt.Key_Up) {
            if(select.state > 0) --select.state
            else select.state = 3
        }
        else if(event.key === Qt.Key_Return) {
            if(!select.state) pageLoader.setSource("canvas.qml")
            else if(select.state === 1) pageLoader.setSource("support.qml")
            else if(select.state === 2) pageLoader.setSource("info.qml")
            else if(select.state === 3) animationWindows.start()
        }
    }

    //Анімація виходу із гри
    PropertyAnimation {
        id: animationWindows
        target: window
        properties: "width"
        from: 800; to: 0
        duration: 1000
        running: false

        onStarted:{
            quit.start()
        }
    }

    Timer {
        id: quit
        running: false
        interval: 950
        onTriggered: Qt.quit()
    }

    //Позиція та відображення тексту головного вікна
    Text {
        id: startgame
        width: parent.width / 5
        text: qsTr("Заплави двигун")
        font.bold: true
        font.family: "Courier"
        visible: true
        font.pixelSize: parent.height / 35
        //select: true
        color: select ? "orange" : "red"
        opacity: select ? 1.0 : 0.7
        anchors.bottom: imageTanks.bottom
        anchors.bottomMargin: 80
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.left: parent.left
        anchors.leftMargin: parent.height / 20

        /*PropertyAnimation {
            id: propAnim
            target: startgame
            properties: "opacity"
            from: 1
            to: 0.4
            duration: 1000
            running: false
        }*/
    }

    Text {
        id: supportText
        width: parent.width / 5
        text: qsTr("Допомога")
        font.family: "Courier"
        font.bold: true
        visible: true
        font.pixelSize: parent.height / 50
        //Selects: true
        color: select ? "orange" : "red"
        opacity: select ? 1.0 : 0.7
        anchors.top: startgame.bottom
        anchors.left: parent.left
        anchors.leftMargin: parent.height / 20
        anchors.topMargin: parent.height / 145
        //opacity: 0.8
    }

    Text {
        id: infoText
        width: parent.width / 5
        text: qsTr("Інформація")
        font.family: "Courier"
        font.bold: true
        visible: true
        font.pixelSize: parent.height / 50
        //Selects: true
        color: select ? "orange" : "red"
        opacity: select ? 1.0 : 0.7
        anchors.top: supportText.bottom
        anchors.left: parent.left
        anchors.leftMargin: parent.height / 20
        anchors.topMargin: parent.height / 145
        //opacity: 0.8
    }

    Text {
        id: exit
        width: parent.width / 5
        text: qsTr("Вихід")
        font.family: "Courier"
        font.bold: true
        visible: true
        font.pixelSize: parent.height / 50
        //Selects: true
        color: select ? "orange" : "red"
        opacity: select ? 1.0 : 0.7
        anchors.top: infoText.bottom
        anchors.left: parent.left
        anchors.leftMargin: parent.height / 20
        anchors.topMargin: parent.height / 145
        //opacity: 0.8
    }
}
