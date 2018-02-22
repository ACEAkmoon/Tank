//-------------------------------------------------
//
//       Налаштування техніки
//
//-------------------------------------------------

import QtQuick 2.7

AnimatedImage {
    id: tankRoot
    height: 28
    width: 32
    fillMode: Image.Stretch
    source: "qrc:/dataFiles/Other/tiled/tankA.png"

    property int type: 0
    property int player: 0
    property int maxBullets: 1
    property int singleFire: 0
    property int speedBullet: 12
    property int speed: 4
    property int botDirection: 2
    property int xMap: Math.round(objectMap.typeTiled.length * x / (objectMap.width))
    property int yMap: Math.round(objectMap.typeTiled.length * y / (objectMap.height))
    property real byX: 0
    property real byY: 0
    property bool isBullet: false
    property bool changeDirection: false

    onBotDirectionChanged: changeDirection = false

    //Швидкість анімації танка
    Behavior on x {
        PropertyAnimation {
            easing.type: Easing.Linear
            duration: 55
        }
    }
    Behavior on y {
        PropertyAnimation {
            easing.type: Easing.Linear
            duration: 55
        }
    }

    function revive() {
        reviveTimer.restart()
    }

    Timer {
        id: reviveTimer
        running: false
        repeat: false
        interval: 200
        onTriggered:{
            visible = true
        }
    }

    function death() {}

    //Налаштування відображення кулі, вибуху, пострілу
    onVisibleChanged: {
        if (player > 1)
            playing = true

        if(!visible) {
            if(parent) {
                if(type !== -1 && tankRoot.parent.inputKeyboard)
                {
                    death()
                    var tankExp = Qt.createComponent("TankExp.qml");
                    var elseObj = tankExp.createObject(parent);
                    elseObj.finishedAnimation.connect(elseObj.destroy)
                    elseObj.anchors.centerIn = tankRoot
                    elseObj.width = tankRoot.width * 2
                    elseObj.height = tankRoot.height * 2.4
                    elseObj.startAnimation()

                    if(parent)
                        parent.activateEnemyTimer()
                }
            }
        }
    }

    //Функція часу зміни напрямку Бота
    function changeBotDirection() {
        var newDirection = botDirection;
        var rightProb = 1.35 * (1 - ((x + (width / 2)) / parent.width))
        var random = 0

        while(newDirection === botDirection) {
            random = Math.random()
            if(random < rightProb)
                newDirection = 1
            else if(random >= rightProb && random < 0.35)
                newDirection = 3
            else if(random >= 0.35 && random < 0.9)
                newDirection = 2
            else if(random >= 0.9)
                newDirection = 0
        }
        botDirection = newDirection
    }

    //Таймер пострілів Бота
    Timer {
        id: botShoot
        running: (player > 1) && visible && objectMap.inputKeyboard
        repeat: tankRoot.parent.inputKeyboard
        interval: 700
        onTriggered: {
            if(!botNoShootTimer.running) {
                isSettingFire()
                interval = 700 + 1500 * Math.random()
                restart()
            } else {
                interval = 100
                restart()
            }
        }
    }

    Timer {
        id: botNoShootTimer
        running: false
        repeat: false
        interval: 70
        onTriggered: {
            stop()
        }
    }

    //Створення кулі
    function createBullet(speed, angle) {
        var bullet = Qt.createComponent("Bullet.qml");
        var isObj = bullet.createObject(objectMap);
        isObj.player = player
        if(angle === 0) {
            isObj.x = x + width / 2 - isObj.width / 2
            isObj.y = y - isObj.height
        } else if(angle === 90) {
            isObj.x = x + width
            isObj.y = y + height / 2 - isObj.height / 2
        } else if(angle === 180) {
            isObj.x = x + width / 2 - isObj.width / 2
            isObj.y = y + height
        } else if(angle === 270) {
            isObj.x = x - isObj.width
            isObj.y = y + height / 2 - isObj.height / 2
        }

        var bulletExp = Qt.createComponent("BulletExp.qml");
        var elseObj = bulletExp.createObject(objectMap);
        isObj.rotation = angle;
        isObj.speed = speed;
        isObj.startAnimation();
        isObj.explosion.connect(elseObj.startAnimation)
        isObj.explosion.connect(isObj.destroy)
        settingInput.isSetting.connect(isObj.isSettingMovement)
        elseObj.finishedAnimation.connect(elseObj.destroy)
        elseObj.anchors.centerIn = isObj
        elseObj.width = objectMap.widthTiled * 3
        elseObj.height = elseObj.width * 1
    }

    function isSettingFire() {
        if(singleFire < maxBullets) {
            ++singleFire;
            createBullet(speedBullet, rotation)
        }
    }

    Timer {
        id: changeDirectionTimer
        running: parent.playing
        repeat: parent.playing
        interval: 2000
        onTriggered: changeDirection = true
    }

    //Налаштування руху героя по мапі
    function isSettingMovement(up, right, down, left) {
        if(player === 1) {
            var element = null

            if(up) {
                rotation = 0 //зміна напрямку в гору /////////////////
                freeDirection = 1;
                if(yMap > 0 && xMap < 50) {
                    for(var q = 0; q < 3; ++q) {
                        for(var z = 0; z < 2; ++z) {
                            if(objectMap.typeTiled[yMap - z * 1][xMap + q] === 1 || objectMap.typeTiled[yMap - z * 1][xMap + q] === 2)
                                freeDirection = 0
                        }
                    }
                }
                if(freeDirection) {
                    var elementA = parent.childAt(x + 2, y - objectMap.heightTiled)
                    var elementPlayer = -1
                    if(elementA)
                        elementPlayer = elementA.player
                    if(elementPlayer < 0) {
                        if(y - speed > 2)
                            y -= speed
                        else
                            y = 2;
                    }
                }
            }
           else if(right) {
                rotation = 90  //зміна напрямку праворуч /////////////////
                freeDirection = 1;
                if(xMap < 49 && yMap < 50) {
                    for(var q = 0; q < 3; ++q) {
                        for(var z = 0; z < 1; ++z) {
                            if(objectMap.typeTiled[yMap + q][xMap + 3 + z * 1] === 1 || objectMap.typeTiled[yMap + q][xMap + 3 + 1 * 2] === 2)
                                freeDirection = 0
                        }
                    }
                }
                if(freeDirection) {
                    var elementA = parent.childAt(x + width - 1 + objectMap.widthTiled, y + 2)
                    var elementPlayer = -1
                    if(elementA)
                        elementPlayer = elementA.player
                    if(elementPlayer < 0) {
                        if(x + speed < objectMap.width - width - 2)
                            x += speed
                        else
                            x = objectMap.width - width - 2
                    }
                }
            }
            else if(down) {
                rotation = 180 //зміна напрямку в низ /////////////////
                freeDirection = 1;
                if(yMap < 49 && xMap < 50) {
                    for(var q = 0; q < 3; ++q) {
                        for(var z = 0; z < 1; ++z) {
                            if(objectMap.typeTiled[yMap + 3 + z * 1][xMap + q] === 1 || objectMap.typeTiled[yMap + 3 + z * 1][xMap + q] === 2)
                                freeDirection = 0
                        }
                    }
                }
                if(freeDirection) {
                    var elementA = parent.childAt(x + 2, y + height - 1 + objectMap.heightTiled)
                    var elementPlayer = -1
                    if(elementA)
                        elementPlayer = elementA.player
                    if(elementPlayer < 0) {
                        if(y + speed < objectMap.height - height - 2)
                            y += speed
                        else
                            y = objectMap.height - height - 2;
                    }
                }
            }
            else if(left) {
                rotation = 270 //зміна напрямку ліворуч /////////////////
                freeDirection = 1;
                if(xMap > 1 && yMap < 50) {
                    for(var q = 0; q < 3; ++q) {
                        for(var z = 0; z < 1; ++z) {
                            if(objectMap.typeTiled[yMap + q][xMap - 1 - z * 1] === 1 || objectMap.typeTiled[yMap + q][xMap - 1 - z * 1] === 2)
                                freeDirection = 0
                        }
                    }
                }
                if(freeDirection) {
                    var elementA = parent.childAt(x - objectMap.widthTiled, y + 2)
                    var elementPlayer = -1
                    if(elementA)
                        elementPlayer = elementA.player
                    if(elementPlayer < 0) {
                        if(x - speed > 2)
                            x -= speed
                        else
                            x = 2
                    }
                }
            }
        }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //Налаштування руху ботів по мапі
        if(player > 1 && visible) {
            if(byX === x && byY === y){
                var freeDirection = 0
                var freeDirectionUp = 0
                var freeDirectionDown = 0
                var freeDirectionLeft = 0
                var freeDirectionRight = 0

                changeBotDirection()
            }
            byX = x
            byY = y

 /////////////зміна напрямку в гору
            if(botDirection === 0) {
                rotation = 0
                freeDirection = 1;
                if(yMap > 0 && xMap < 50) {
                    for(var q = 0; q < 3; ++q) {
                        for(var z = 0; z < 2; ++z) {
                            if(objectMap.typeTiled[yMap - z * 1][xMap + q] === 1 || objectMap.typeTiled[yMap - z * 1][xMap + q] === 2)
                                freeDirection = 0
                        }
                    }
                }
                if(freeDirection) {
                    var elementA = parent.childAt(x + 2, y - objectMap.heightTiled)
                    var elementPlayer = -1
                    if(elementA)
                        elementPlayer = elementA.player
                    if(elementPlayer < 0) {
                        if(y - speed > 2)
                            y -= speed
                        else
                            y = 2;
                    }
                }
            }

/////////////зміна напрямку праворуч
            else if(botDirection === 1) {
                rotation = 90
                freeDirection = 1;
                if(xMap < 49 && yMap < 50) {
                    for(var q = 0; q < 3; ++q) {
                        for(var z = 0; z < 1; ++z) {
                            if(objectMap.typeTiled[yMap + q][xMap + 3 + z * 1] === 1 || objectMap.typeTiled[yMap + q][xMap + 3 + 1 * 2] === 2)
                                freeDirection = 0
                        }
                    }
                }

                if(freeDirection) {
                    var elementA = parent.childAt(x + width - 1 + objectMap.widthTiled, y + 2)
                    var elementPlayer = -1
                    if(elementA)
                        elementPlayer = elementA.player
                    if(elementPlayer < 0) {
                        if(x + speed < objectMap.width - width - 2)
                            x += speed
                        else
                            x = objectMap.width - width - 2
                    }
                }
            }

 /////////////зміна напрямку в низ
            else if(botDirection === 2) {
                rotation = 180
                freeDirection = 1;
                if(yMap < 49 && xMap < 50) {
                    for(var q = 0; q < 3; ++q) {
                        for(var z = 0; z < 1; ++z) {
                            if(objectMap.typeTiled[yMap + 3 + z * 1][xMap + q] === 1 || objectMap.typeTiled[yMap + 3 + z * 1][xMap + q] === 2)
                                freeDirection = 0
                        }
                    }
                }
                if(freeDirection) {
                    var elementA = parent.childAt(x + 2, y + height - 1 + objectMap.heightTiled)
                    var elementPlayer = -1;
                    if(elementA)
                        elementPlayer = elementA.player
                    if(elementPlayer < 0) {
                        if(y + speed < objectMap.height - height - 2)
                            y += speed
                        else
                            y = objectMap.height - height - 2;
                    }
                }
            }

 /////////////зміна напрямку ліворуч
            else if(botDirection === 3) {
                rotation = 270
                freeDirection = 1;
                if(xMap > 1 && yMap < 50) {
                    for(var q = 0; q < 3; ++q) {
                        for(var z = 0; z < 1; ++z) {
                            if(objectMap.typeTiled[yMap + q][xMap - 1 - z * 1] === 1 || objectMap.typeTiled[yMap + q][xMap - 1 - z * 1] === 2)
                                freeDirection = 0
                        }
                    }
                }
                if(freeDirection) {
                    var elementA = parent.childAt(x - objectMap.widthTiled, y + 2)
                    var elementPlayer = -1
                    if(elementA)
                        elementPlayer = elementA.player
                    if(elementPlayer < 0) {
                        if(x - speed > 2)
                            x -= speed
                        else
                            x = 2
                    }
                }
            }
        }
    }
}
