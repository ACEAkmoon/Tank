//-------------------------------------------------
//
//       Налаштування керування
//
//-------------------------------------------------

import QtQuick 2.7

Item {
    anchors.fill: parent
    focus: true

    signal isSetting()
    signal playerSignal(bool up, bool down, bool left, bool right)
    signal playerFire()

    property bool input: false
    property bool moving: false
    property bool inputUp: false
    property bool inputDown: false
    property bool inputLeft: false
    property bool inputRight: false
    property bool inputFire: false

    onInputChanged: {
        if(!input) timerInput.stop;
    }

    //Якщо отримуємо сигнал вводу, змінюємо налаштування на правду  (дія розпочинається)
    Keys.onPressed: {
        if(!event.isAutoRepeat) {
            if(event.key === Qt.Key_Up) {
                inputUp = true
            } else if(event.key === Qt.Key_Down) {
                inputDown = true
            } else if(event.key === Qt.Key_Left) {
                inputLeft = true
            } else if(event.key === Qt.Key_Right) {
                inputRight = true
            } if (event.key === Qt.Key_Space){
                if(!fireInterval.running){
                    inputFire = true
                }
            }
        }
    }

    //Якщо отримуємо сигнал вводу, змінюємо налаштування на неправду (дія припиняється)
    Keys.onReleased: {
        if(!event.isAutoRepeat) {
            if(event.key === Qt.Key_Up) {
                inputUp = false
            } else if(event.key === Qt.Key_Down) {
                inputDown = false
            } else if(event.key === Qt.Key_Left) {
                inputLeft = false
            } else if(event.key === Qt.Key_Right) {
                inputRight = false
            } if(event.key === Qt.Key_Space) {
                inputFire = false
            }
        }
    }

    //Функція провіряє чи були внесені зміни вводу, якщо так то подає сигнал на відтворення дій
    Timer {
        id: timerInput
        running: input
        repeat: input
        interval: 50

        onTriggered: {
            isSetting();
            if(!(inputUp || inputDown || inputLeft || inputRight))
                moving = false
            else
                moving = true

            playerSignal(inputUp, inputDown, inputLeft, inputRight)

            if(inputFire && !fireInterval.running) {
                fireInterval.restart()
                playerFire();
            }
        }
    }

    Timer {
        id: fireInterval
        running: false
        repeat: false
        interval: 70
        onTriggered: inputFire = false
    }
}

