//-------------------------------------------------
//
//       Налаштування інформації керування
//
//-------------------------------------------------

import QtQuick 2.7

Rectangle {
    id: rectanglePause
    height: window.height
    width: height
    anchors.centerIn: parent
    border.width: 4
    border.color: "black"
    radius: 7
    color: "black"
    visible: true
    focus: true

    Keys.onPressed: {
        pageLoader.setSource("mainScreen.qml")
    }

    Background {
        id: backgroundSupport
        anchors.centerIn: parent
        width: parent.width / 1
        height: parent.height / 1
        fillMode: Image.PreserveAspectFit
    }

    Column {
        anchors.top: parent.top
        anchors.topMargin: parent.height / 10
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 6

        Text {
            text: "Керування"
            font.family: "Courier"
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: parent.height / 10
            font.bold: true
            color: "orange"
        }

        Text {
            text: "Рухатись вгору - Кнопка Up\nРухатись вниз - кнопка Down\nРухатись вліво - кнопка Left\nРухатись вправо - кнопка Right\nВогонь - кнопка Space\r\n"
            font.family: "Courier"
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: parent.height / 30
            font.bold: true
            color: "white"
        }

        Text {
            id: pressAnyKeyText
            text: "НАТИСНИ ДЛЯ ПОВЕРНЕННЯ В ГОЛОВНЕ МЕНЮ"
            font.family: "Courier"
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize:  parent.height / 48
            font.bold: true
            color: "white"
        }
    }
    //Таймер мерехтіння кнопки
    Timer {
        id: timerPressKey
        running: true
        repeat: true
        interval: 800
        onTriggered: pressAnyKeyText.visible = !pressAnyKeyText.visible
    }
}
