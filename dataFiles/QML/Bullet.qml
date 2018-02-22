//-------------------------------------------------
//
//     Налаштування кулі
//
//-------------------------------------------------

import QtQuick 2.7
import QtMultimedia 5.8

Image {
    id: tankBullet
    width: 11
    height: 13

    source: "qrc:/dataFiles/Other/tiled/bullet.png"
    visible: false

    property bool concrete: false
    property bool isBullet: true
    property int player: 0
    property int speed: 33

    signal explosion()

    //Швидкість анімації кулі
    Behavior on x {
        PropertyAnimation {
            easing.type: Easing.Linear
            duration: 40
        }
    }
    Behavior on y {
        PropertyAnimation {
            easing.type: Easing.Linear
            duration: 40
        }
    }

    SoundEffect {
        id: fireSingle
        volume: 0.8
        source: "qrc:/dataFiles/Other/sound/fireSingle.wav"
    }

    Component.onCompleted: fireSingle.play()

    function isSettingMovement() {
        if(visible){
            var element = null
            if(rotation === 0)
                y -= speed
            else if(rotation === 90)
                x += speed
            else if(rotation === 180)
                y += speed
            else if(rotation === 270)
                x -= speed
        }
    }

    function startAnimation() {
        startAnimationTimer.restart()
    }

    Timer {
        id: startAnimationTimer
        running: false
        repeat: false
        interval: 45
        onTriggered: visible = true
    }

    onExplosion: {
        parent.playerDelBullet(player);
        settingInput.isSetting.disconnect(isSettingMovement)
    }

//////куля по осі "Y"////////////////////////////////////////////////////////////////////////////
    onYChanged:{
        if(visible) {
            if(y <= 0 || y >= parent.height - height)
                explosion()
            else {
                var element = null
                var reckonY
                var latterY
                var elementConcrete = false
                var elementEnemy = 0
                var elementBullet = false

                //зміна напрямку в гору /////////////////
                if(rotation === 0) {
                    element = parent.childAt(x + width / 3, y - height / 3)
                    if(element) {
                        elementConcrete = element.concrete
                        elementEnemy = element.player
                        elementBullet = element.isBullet
                    } if(elementConcrete) {
                        visible = false
                        reckonY = 0
                        latterY = y;
                        if(element) {
                            while (element) {
                                latterY = y + reckonY;
                                element = parent.childAt(x - 1, y + reckonY);
                                reckonY += parent.heightTiled
                            }
                            latterY -= parent.heightTiled
                        }

                        for(var z = 0; z < 1; ++z) {
                            for(var q = 0; q < 4; ++q) {
                                element = parent.childAt(x + width / 2 - (1.75 * parent.widthTiled - parent.widthTiled * q), latterY - (parent.heightTiled * z));
                                if(element) {
                                    if(element.brick) {
                                        if(element.player === -1)
                                            objectMap.typeTiled[element.xMap][element.yMap] = 0
                                        if(element.earth === false)
                                            element.destroy();
                                        else {
                                            element.visible = false
                                        }
                                    }
                                }
                            }
                        }
                        explosion()
                    }
                    else {
                        if(player === 1) {
                            if(elementEnemy > 1) {
                                element.visible = false;
                                explosion()
                            }
                        }
                        else if(player > 1) {
                            if((elementEnemy <= 1 && elementEnemy > 0)) {
                                element.visible = false;
                                explosion()
                            }
                        }
                    }
                }
                //зміна напрямку в низ /////////////////
                else if (rotation === 180) {
                    elementConcrete = false
                    element = parent.childAt(x + width / 3, y + 4 * height / 3)

                    if(element) {
                        elementConcrete = element.concrete
                        elementEnemy = element.player
                        elementBullet = element.isBullet
                    } if(elementConcrete) {
                        visible = false
                        reckonY = 0
                        latterY = y;
                        if(element) {
                            while (element) {
                                latterY = y + height + 1 + reckonY;
                                element = parent.childAt(x - 1, y + height + 1 + reckonY);
                                reckonY -= parent.heightTiled
                            }
                            latterY += parent.heightTiled
                        }

                        for(var z = 0; z < 1; ++z) {
                            for(var q = 0; q < 4; ++q) {
                                element = parent.childAt(x + width / 2 - (1.75 * parent.widthTiled - parent.widthTiled * q), latterY + (parent.heightTiled * z));
                                if(element) {
                                    if(element.brick) {
                                        if(element.player === -1)
                                            objectMap.typeTiled[element.xMap][element.yMap] = 0
                                        if(element.earth === false)
                                            element.destroy();
                                        else {
                                            element.visible = false
                                        }
                                    }
                                }
                            }
                        }
                        explosion()
                    }
                    else {
                        if(player === 1) {
                            if(elementEnemy > 1) {
                                element.visible = false;
                                explosion()
                            }
                        }
                        else if(player > 1) {
                            if((elementEnemy <= 1 && elementEnemy > 0)) {
                                element.visible = false;
                                explosion()
                            }
                        }
                    }
                }
            }
        }
    }
//////куля по осі "X"/////////////////////////////////////////////////////////////////////////////////////
    onXChanged: {
        if(visible) {
            if(x <= 0 || x >= parent.width - width)
                explosion()
            else {
                var element = null
                var reckonX
                var latterX
                var elementConcrete = false
                var elementEnemy = 0
                var elementBullet = false

                //зміна напрямку ліворуч /////////////////
                if(rotation === 270) {
                    element = parent.childAt(x - width / 3, y + height / 3)
                    if(element) {
                        elementConcrete = element.concrete
                        elementEnemy = element.player
                        elementBullet = element.isBullet
                    } if(elementConcrete) {
                        visible = false
                        reckonX = 0
                        latterX = x;
                        if(element) {
                            while (element) {
                                latterX = x + reckonX;
                                element = parent.childAt(x + reckonX, y - 1);
                                reckonX += parent.widthTiled
                            }
                            latterX -= parent.widthTiled
                        }

                        for(var z = 0; z < 1; ++z) {
                            for(var q = 0; q < 4; ++q) {
                                element = parent.childAt(latterX - (parent.widthTiled * z), y + height / 2 - (1.75 * parent.heightTiled - parent.heightTiled * q));
                                if(element) {
                                    if(element.brick) {
                                        if(element.player === -1)
                                            objectMap.typeTiled[element.xMap][element.yMap] = 0
                                        if(element.earth === false)
                                            element.destroy();
                                        else {
                                            element.visible = false
                                        }
                                    }
                                }
                            }
                        }
                        explosion()
                    }
                    else {
                        if(player === 1) {
                            if(elementEnemy > 1) {
                                element.visible = false;
                                explosion()
                            }
                        }
                        else if(player > 1) {
                            if((elementEnemy <= 1 && elementEnemy > 0)) {
                                element.visible = false;
                                explosion()
                            }
                        }
                    }
                }
                //зміна напрямку праворуч /////////////////
                else if (rotation === 90) {
                    elementConcrete = false
                    element = parent.childAt(x + 4 * width / 3, y + height / 3)

                    if(element) {
                        elementConcrete = element.concrete
                        elementEnemy = element.player
                        elementBullet = element.isBullet
                    } if(elementConcrete) {
                        visible = false
                        reckonX = 0
                        latterX = x;
                        if(element) {
                            while (element) {
                                latterX = x + width + 1 + reckonX;
                                element = parent.childAt(x + width + 1 + reckonX, y - 1);
                                reckonX -= parent.widthTiled
                            }
                            latterX += parent.widthTiled
                        }

                        for(var z = 0; z < 1; ++z) {
                            for(var q = 0; q < 4; ++q) {
                                element = parent.childAt(latterX + (parent.widthTiled * z), y + height / 2 - (1.75 * parent.heightTiled - parent.heightTiled * q));
                                if(element) {
                                    if(element.brick) {
                                        if(element.player === -1)
                                            objectMap.typeTiled[element.xMap][element.yMap] = 0
                                        if(element.earth === false)
                                            element.destroy();
                                        else {
                                            element.visible = false
                                        }
                                    }
                                }
                            }
                        }
                        explosion()
                    }
                    else {
                        if(player === 1) {
                            if(elementEnemy > 1) {
                                element.visible = false;
                                explosion()
                            }
                        } else if(player > 1) {
                            if((elementEnemy <= 1 && elementEnemy > 0)) {
                                element.visible = false;
                                explosion()
                            }
                        }
                    }
                }
            }
        }
    }
}

