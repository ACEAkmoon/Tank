//-------------------------------------------------
//
//       Налаштування інформації про гру
//
//-------------------------------------------------

import QtQuick 2.7

Rectangle {
    id: infoScreen
    height: window.height
    width: height
    anchors.centerIn: parent
    border.width: 4
    border.color: "black"
    color: "black"
    radius: 7
    visible: true
    focus: true

    property bool inputKeyboard: false

    Keys.onPressed: {
        pageLoader.setSource("mainScreen.qml")
    }
    Background {
        id: backgroundInfo
        anchors.centerIn: parent
        width: parent.width / 1
        height: parent.height / 1
        fillMode: Image.PreserveAspectFit
    }
    Text {
        id: infoText
        text: "Інформація"
        font.family: "Courier"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height / 10
        font.pixelSize: parent.height / 20
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
        text: "НАТИСНИ ДЛЯ ПОВЕРНЕННЯ В ГОЛОВНЕ МЕНЮ"
        font.family: "Courier"
        visible: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: sourceObj.bottom
        anchors.topMargin: 70
        font.pixelSize: parent.height / 48
        font.bold: true
        color: "white"
    }
    //Таймер мерехтіння кнопки
    Timer {
        id: timerPressKey
        running: true
        repeat: true
        interval: 800
        onTriggered: pressKey.visible = !pressKey.visible
    }
}
