//-------------------------------------------------
//
//       Налаштування диму на головному екрані
//
//-------------------------------------------------

import QtQuick 2.7
import QtMultimedia 5.8
import "./"

Rectangle {
    id: smokeRectangle
    //x: 15
    //y: 15
    //width: 125
    //height: 125
    color: "#00000000"

    property int dx: 1
    property int dy: 1
    //property int da: 3 //Обертання на 3 градуса "rotation"

    function move() {
        x += dx
        y += dy
        //rotation += da
    }

    function checkBounds() {
        if (x + width >= imageTanks.width)
            dx = -1
        else if (x < 0)
            dx = 1
        if (y + height >= imageTanks.height)
            dy = -1
        else if (y < 0)
            dy = 1
    }

    AnimatedImage {
        id: smoke
        source: "qrc:/dataFiles/Other/tiled/smokeMenu.gif"
        playing: true
        visible: playing
        opacity: 0.9
        anchors.fill: smokeRectangle

        /*signal finishedAnimation()

        function startAnimation()
        {
            smokeTimer.running = true;
            //smokeTimer.restart();
        }*/

        Timer {
            id: smokeTimer
            interval: 4400
            running: true
            //repeat: true
            onTriggered: {
                smoke.playing = false
                //finishedAnimation()
                //smokeTimer.restart()
            }
        }
    }

    Timer {
        id: smokeChangeDirectionTimer
        interval: 200
        running: true
        repeat: true

        onTriggered: {
            smoke.playing = true
            checkBounds()
            move()
            //smoke.playing = false
        }
    }
}
