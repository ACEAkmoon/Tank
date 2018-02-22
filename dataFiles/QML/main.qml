//-------------------------------------------------
//
//       Головне вікно
//
//-------------------------------------------------

import QtQuick 2.7
import QtMultimedia 5.8
import QtQuick.Controls 2.1
import QtQuick.Window 2.0
import "./"

ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 700
    title: qsTr("Tank-ACE")
    color: "black"
    /*minimumHeight: height
    maximumHeight: height
    minimumWidth: width
    maximumWidth:  width*/

    property string source: "mainScreen.qml"

    //Анімація екрану вікна
    PropertyAnimation {
        id: animationWindows
        target: window
        properties: "width"
        from: 0; to: 800
        duration: 1000
        running: true
    }

    //Корегування позиції завантажувача сторінки в головному вікні
    Item {
        id: scene
        anchors.fill: parent

        Loader {
            id: pageLoader
            width: parent.width
            height: parent.height
            focus: true
            source: window.source
            anchors.centerIn: parent
        }
    }
}

