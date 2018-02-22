//-------------------------------------------------
//
//       Налаштування механіки гри
//
//-------------------------------------------------

import QtQuick 2.7
import QtMultimedia 5.8
import "./"
import "map.js" as MapScreen

Rectangle {
    id: region
    radius: 10
    anchors.fill: parent
    focus: true
    color: "black"

    property int playerLife: 3
    property int enemiesLife: 36
    property bool isAnimation: false
    property bool playerDead: false
    property bool objectVisible: false

    Keys.onPressed: {
        if(event.key === Qt.Key_Return)
            animationGame.start()
    }

    Component.onCompleted: objectMap.startTimer()

    Timer {
        id: loading
        running: true
        interval: 150
        onTriggered: animationScreen.start()
    }

    //Анімація екрану
    PropertyAnimation {
        id: animationScreen
        target: startGameBackground
        properties: "width, height"
        from: 0; to: 900
        duration: 1000
        running: true
    }

    //Анімація екрану
    PropertyAnimation {
        id: animationGame
        target: startGameBackground
        properties: "width, height"
        from: 900; to: 0
        duration: 1000
        running: false

        onStarted:{
            settingInput.forceActiveFocus()
        }
        onStopped: {
            if(!isAnimation) {
                objectVisible = true
                settingInput.input = true
                isAnimation = true
                backgroundMain.visible = true
            }
        }
    }

    //Фон екрану переходу в гру
    Image {
        id: startGameBackground
        visible: true
        anchors.centerIn: parent
        width: parent.width / 0.9
        height: parent.height / 0.9
        source: "qrc:/dataFiles/Other/tiled/startGameBackground.png"
        fillMode: Image.PreserveAspectFit
        opacity: 1
    }

    //Фон екрану гри
    Image {
        id: backgroundMain
        visible: false
        anchors.centerIn: parent
        width: parent.width / 0.9
        height: parent.height / 0.9
        source: "qrc:/dataFiles/Other/tiled/backgroundRound.png"
        fillMode: Image.PreserveAspectFit
        opacity: 0.7
    }

    Rectangle {
        id: objectCanvasMap
        radius: 7
        color: "#00000000"
        anchors.topMargin: 5
        anchors.leftMargin: 5
        anchors.bottomMargin: 5
        anchors.rightMargin: 70
        anchors.fill: parent
        transformOrigin: Item.Center
        visible: false

        Map {
            id: objectMap
            radius: 7
            visible: objectVisible
            anchors.fill: objectCanvasMap
            typeTiled: MapScreen.level
            property bool canSpawnEnemy: !tankEnemyOne.visible || !tankEnemyTwo.visible || !tankEnemyThree.visible || !tankEnemyFour.visible
            property bool inputKeyboard: settingInput.input

            onInputKeyboardChanged: {
                if(inputKeyboard) {
                    oneEngineSound.play()
                    //twoEngineSound.play()
                    //threeEngineSound.play()
                    //fourEngineSound.play()
                } /*else {
                    oneEngineSound.stop()
                    //twoEngineSound.stop()
                    //threeEngineSound.stop()
                    //fourEngineSound.stop()
                }*/
            }

            function playerDelBullet(player) {
                if(player === 1)
                    --tankPlayer.singleFire;
                else if(player === 2)
                    --tankEnemyOne.singleFire;
                else if(player === 3)
                    --tankEnemyTwo.singleFire;
                else if(player === 4)
                    --tankEnemyThree.singleFire;
                else if(player === 5)
                    --tankEnemyFour.singleFire;
            }

            function activateEnemyTimer() {
                spawnNewEnemy.restart()
            }

            //Позиціонування та налаштування на карті бази гравця
            Earth {
                id: earth
                anchors.centerIn: objectMap

                onVisibleChanged: {
                    if(!earth.visible && isAnimation) {
                        settingInput.input = false
                        parent.inputKeyboard = false
                        timerPlayerLost.restart()
                    }
                }

                Timer {
                    id: timerPlayerLost
                    running: false
                    repeat: false
                    interval: 3000
                    onTriggered: pageLoader.setSource("endScreen.qml")
                }
            }
            //////////////////////////////////////////////////////////////////////////////
            //Позиція та створення нового бота
            Timer {
                id: spawnNewEnemy
                interval: 700
                running: parent.canSpawnEnemy && parent.inputKeyboard
                repeat: parent.canSpawnEnemy && parent.inputKeyboard
                onTriggered: {
                    interval = 2500
                    if(region.enemiesLife){
                        --region.enemiesLife
                        enemiesLifeModel.remove(0)
                        var positionX = 0
                        if(parent.pointRespawnEnemy === 0)
                            positionX = 4 + 3  * objectMap.width / 13
                        if(parent.pointRespawnEnemy === 1)
                            positionX = 4 + 12 * objectMap.width / 13
                        if(parent.pointRespawnEnemy === 2)
                            positionX = 4 + 9  * objectMap.width / 13
                        if(parent.pointRespawnEnemy === 3)
                            positionX = 4 + 6  * objectMap.width / 13
                        if(parent.pointRespawnEnemy === 4)
                            positionX = 4 + 3  * objectMap.width / 13
                        if(parent.pointRespawnEnemy === 5)
                            positionX = 4 + 12 * objectMap.width / 13

                        ++parent.pointRespawnEnemy

                        if(!tankEnemyOne.visible) {
                            tankEnemyOne.x = positionX
                            tankEnemyOne.y = 2 + 0 * objectMap.height / 13
                            tankEnemyOne.revive()
                        } else if(!tankEnemyTwo.visible) {
                            tankEnemyTwo.x = positionX
                            tankEnemyTwo.y =  2 + 0 * objectMap.height / 13
                            tankEnemyTwo.revive()
                        } else if(!tankEnemyThree.visible) {
                            tankEnemyThree.x = positionX
                            tankEnemyThree.y = 2 + 12 * objectMap.height / 13
                            tankEnemyThree.revive()
                        } else if(!tankEnemyFour.visible) {
                            tankEnemyFour.x = positionX
                            tankEnemyFour.y = 2 + 12 * objectMap.height / 13
                            tankEnemyFour.revive()
                        }
                    }
                    //Перехід до екрану перемоги, якщо всі танки невидимі
                    else {
                        if(!tankEnemyOne.visible && !tankEnemyTwo.visible && !tankEnemyThree.visible && !tankEnemyFour.visible) {
                            pageLoader.setSource("victoryScreen.qml")
                        }
                    }
                }
            }
            //////////////////////////////////////////////////////////////////////////////
            //Танк гравця
            TankIsMap {
                id: tankPlayer
                x: 3 + 1 * parent.width / 13
                y: 2 + 7 * parent.height / 13
                width: 3.25 * objectMap.widthTiled
                height: 3.25 * objectMap.heightTiled
                speed: 7
                player: 1
                playing: settingInput.moving && parent.inputKeyboard

                onPlayingChanged: {
                    if(playing)
                        playerSound.play()
                    else
                        playerSound.stop()
                }

                SoundEffect {
                    id: playerSound
                    source: "qrc:/dataFiles/Other/sound/enginePlayer.wav"
                    loops: SoundEffect.Infinite
                    volume: 0.4
                }

                signal noLife()

                Behavior on x {
                    SpringAnimation {
                        spring: 5
                        damping: 0.2
                    }
                }

                Behavior on y {
                    SpringAnimation {
                        spring: 5
                        damping: 0.2
                    }
                }

                onNoLife: {
                    region.playerDead = true
                    settingInput.input = false
                    parent.inputKeyboard = false
                    timerPlayerLost.restart()
                }

                function death() {
                    if(region.playerLife) {
                        --region.playerLife
                        waitRestart.restart()
                    } else noLife()
                }

                Timer {
                    id: waitRestart
                    interval: 2000
                    running: false
                    repeat: false
                    onTriggered: {
                        tankPlayer.rotation = 0
                        tankPlayer.x = 3 + 1 * objectMap.width / 13
                        tankPlayer.y = 2 + 7 * objectMap.height / 13
                        revivePlayer.restart()
                    }
                }

                Timer {
                    id: revivePlayer
                    interval: 1500
                    running: false
                    repeat: false
                    onTriggered: tankPlayer.visible = true
                }
            }
            //////////////////////////////////////////////////////////////////////////////
            //Ворожий танк 1
            TankIsMap {
                id: tankEnemyOne
                x: 4 + 6 * parent.width / 13
                y: 6 + 0 * parent.height / 13
                width: 3.25 * objectMap.widthTiled
                height: 3.25 * objectMap.heightTiled
                playing: parent.inputKeyboard
                visible: false
                rotation: 180
                source: "qrc:/dataFiles/Other/tiled/tankB.png"
                player: 2

                onPlayingChanged: {
                    if(playing)
                        oneEngineSound.play()
                    /*else
                        oneEngineSound.stop()*/
                }

                SoundEffect {
                    id: oneEngineSound
                    source: "qrc:/dataFiles/Other/sound/engineEnemyOne.wav"
                    loops: SoundEffect.Infinite
                    volume: 0.4
                }
            }
            //////////////////////////////////////////////////////////////////////////////
            //Ворожий танк 2
            TankIsMap {
                id: tankEnemyTwo
                x: 8 + 0 * parent.width / 13
                y: 6 + 0 * parent.height / 13
                width: 3.25 * objectMap.widthTiled
                height: 3.25 * objectMap.heightTiled
                playing: parent.inputKeyboard
                visible: false
                rotation: 180
                source: "qrc:/dataFiles/Other/tiled/tankB.png"
                player: 3

                /*onPlayingChanged: {
                    if(playing)
                        twoEngineSound.play()
                    else
                        twoEngineSound.stop()
                }

                MediaPlayer {
                    id: twoEngineSound
                    source: "qrc:/dataFiles/Other/sound/engineEnemyTwo.wav"
                    loops: MediaPlayer.Infinite
                    volume: 0.4
                }*/
            }
            //////////////////////////////////////////////////////////////////////////////
            //Ворожий танк 3
            TankIsMap {
                id: tankEnemyThree
                x: 4 + 12 * parent.width / 13
                y: 6 + 0 * parent.height / 13
                width: 3.25 * objectMap.widthTiled
                height: 3.25 * objectMap.heightTiled
                playing: parent.inputKeyboard
                visible: false
                rotation: 0
                source: "qrc:/dataFiles/Other/tiled/tankB.png"
                player: 4

                /*onPlayingChanged:{
                    if(playing)
                        threeEngineSound.play()
                    else
                        threeEngineSound.stop()
                }

                MediaPlayer {
                    id: threeEngineSound
                    source: "qrc:/dataFiles/Other/sound/engineEnemyOne.wav"
                    loops: MediaPlayer.Infinite
                    volume: 0.4
                }*/
            }
            //////////////////////////////////////////////////////////////////////////////
            //Ворожий танк 4
            TankIsMap {
                id: tankEnemyFour
                x: 4 + 6 * parent.width / 13
                y: 6 + 0 * parent.height / 13
                width: 3.25 * objectMap.widthTiled
                height: 3.25 * objectMap.heightTiled
                playing: parent.inputKeyboard
                visible: false
                rotation: 0
                source: "qrc:/dataFiles/Other/tiled/tankB.png"
                player: 5

                /*onPlayingChanged: {
                    if(playing)
                        fourEngineSound.play()
                    else
                        fourEngineSound.stop()
                }

                MediaPlayer {
                    id: fourEngineSound
                    source: "qrc:/dataFiles/Other/sound/engineEnemyTwo.wav"
                    loops: MediaPlayer.Infinite
                    volume: 0.4
                }*/
            }
        }
    }

    //Розташування інфо життя ворогів
    Text {
        id: enemyesNumber
        width: 68
        height: 38
        text: "кількість\n ворогів\r\n"
        font.capitalization: Font.AllLowercase
        font.family: "Verdana"
        font.bold: true
        font.pixelSize: parent.height / 60
        anchors.left: objectCanvasMap.right
        anchors.leftMargin: 4
        anchors.top: parent.top
        anchors.topMargin: 27
        color: "#f30707"
        visible: objectVisible

        Component.onCompleted: {
            for (var i = 0; i < region.enemiesLife; ++i) {
                enemiesLifeModel.append({})
            }
        }
    }

    GridView {
        id: canvasEnemiesLife
        width: 70
        height: 220
        anchors.top: enemyesNumber.bottom
        anchors.topMargin: 2
        anchors.left: objectCanvasMap.right
        anchors.leftMargin: 4
        cellWidth: 21
        cellHeight: 19
        visible: objectVisible

        model: ListModel {
            id: enemiesLifeModel
        }

        delegate: Component {
            id: enemiesImg
            Image {
                source: "qrc:/dataFiles/Other/tiled/livesEnemy.png"
                width: canvasEnemiesLife.cellWidth - 2
                height: canvasEnemiesLife.cellHeight
            }
        }
    }
    //Розташування інфо життя героя
    Text {
        id: playerLifeText
        width: 68
        height: 38
        text: "життя\nгравця\r\n"
        font.family: "Verdana"
        font.bold: true
        font.pixelSize: parent.height / 45
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.left: objectCanvasMap.right
        anchors.leftMargin: 2.7
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 70
        visible: objectVisible
        color: "green"
    }

    Image {
        id: imagePlayer
        width: 33
        height: 33
        anchors.left: objectCanvasMap.right
        anchors.leftMargin: 4
        anchors.top: playerLifeText.bottom
        visible: objectVisible
        source: "qrc:/dataFiles/Other/tiled/livesPlayer.png"
        fillMode: Image.Stretch
    }

    Text {
        id: numberLifePlayer
        width: 33
        height: 25
        font.pixelSize: parent.height / 25
        color: "green"
        text: playerLife.toString()
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.left: imagePlayer.right
        anchors.leftMargin: 2
        anchors.top: playerLifeText.bottom
        anchors.topMargin: 2
        visible: objectVisible
    }

    //Налаштування сигналу вводу
    Setting {
        id: settingInput

        onPlayerFire: {
            if (tankPlayer.visible) tankPlayer.isSettingFire();
        }
        onPlayerSignal: {
            tankPlayer.isSettingMovement(up, right, down, left)
            tankEnemyOne.isSettingMovement(0, 0, 0, 0)
            tankEnemyTwo.isSettingMovement(0, 0, 0, 0)
            tankEnemyThree.isSettingMovement(0, 0, 0, 0)
            tankEnemyFour.isSettingMovement(0, 0, 0, 0)
        }
    }
}
