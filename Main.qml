import QtQuick
import QtQuick.Controls
import SddmComponents 2.0
import "components"

Rectangle {
    id: root

    // Catppuccin Mocha Palette
    readonly property color base:     "#1e1e2e"
    readonly property color mantle:   "#181825"
    readonly property color crust:    "#11111b"
    readonly property color surface0: "#313244"
    readonly property color surface1: "#45475a"
    readonly property color surface2: "#585b70"
    readonly property color overlay0: "#6c7086"
    readonly property color text:     "#cdd6f4"
    readonly property color subtext1: "#bac2de"
    readonly property color blue:     "#89b4fa"
    readonly property color pink:     "#f5c2e7"
    readonly property color red:      "#f38ba8"
    readonly property color green:    "#a6e3a1"
    readonly property color yellow:   "#f9e2af"
    readonly property color mauve:    "#cba6f7"
    readonly property color peach:    "#fab387"

    width:  config.ScreenWidth  || Screen.width
    height: config.ScreenHeight || Screen.height
    color: "transparent"

    TextConstants { id: textConstants }

    Background {
        source: config.background
        blurRadius: parseInt(config.BlurRadius) || 0
        baseColor: root.base
    }

    Connections {
        target: sddm
        function onLoginSucceeded() {
            statusText.color = root.green
            statusText.text  = textConstants.loginSucceeded
        }
        function onLoginFailed() {
            statusText.color    = root.red
            statusText.text     = textConstants.loginFailed
            passwordBox.text    = ""
            passwordBox.focus   = true
            failAnim.start()
        }
    }

    Clock {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top:              parent.top
        anchors.topMargin:        parent.height * 0.13
        timeColor:                root.pink
        dateColor:                root.subtext1
        fontFamily:               config.Font || "Sans"
    }

    Rectangle {
        id: card
        width: 380
        height: cardCol.height + 64
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 40
        color: root.base
        border.color: root.surface1
        border.width: 1

        Column {
            id: cardCol
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 32 }
            spacing: 20

            // User Avatar
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 64; height: 64; radius: 32
                color: root.surface0
                border.color: root.blue
                border.width: 2
                Text {
                    anchors.centerIn: parent
                    text: ""
                    color: root.blue
                    font.family: config.Font || "Sans"
                    font.pixelSize: 32
                }
            }

            // Username Input
            Column {
                width: parent.width; spacing: 8
                Text {
                    text: textConstants.userName
                    color: root.overlay0
                    font.family: config.Font || "Sans"
                    font.pixelSize: 12
                }
                TextBox {
                    id: usernameBox
                    width: parent.width; height: 44
                    text: userModel.data(userModel.index(userModel.lastIndex, 0), Qt.UserRole + 1) || ""
                    color: root.surface0
                    borderColor: root.surface1
                    focusColor: root.blue
                    hoverColor: root.surface1
                    textColor: root.text
                    font.family: config.Font || "Sans"
                    font.pixelSize: 14
                    KeyNavigation.tab: passwordBox
                    KeyNavigation.backtab: loginBtn
                }
            }

            // Password Input
            Column {
                width: parent.width; spacing: 8
                Text {
                    text: textConstants.password
                    color: root.overlay0
                    font.family: config.Font || "Sans"
                    font.pixelSize: 12
                }
                PasswordBox {
                    id: passwordBox
                    width: parent.width; height: 44
                    color: root.surface0
                    borderColor: root.surface1
                    focusColor: root.blue
                    hoverColor: root.surface1
                    textColor: root.text
                    font.family: config.Font || "Sans"
                    font.pixelSize: 14
                    tooltipEnabled: true
                    tooltipText: textConstants.capslockWarning
                    tooltipFG: root.text
                    tooltipBG: root.surface0
                    KeyNavigation.tab: loginBtn
                    KeyNavigation.backtab: usernameBox
                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            doLogin()
                        }
                    }
                }
            }

            // Status Message
            Rectangle {
                id: statusBg
                width: parent.width; height: 32
                color: "transparent"
                Text {
                    id: statusText
                    anchors.centerIn: parent
                    font.family: config.Font || "Sans"
                    font.pixelSize: 13
                }
                SequentialAnimation on color {
                    id: failAnim
                    running: false
                    ColorAnimation { from: "transparent"; to: "#33f38ba8"; duration: 150 }
                    PauseAnimation { duration: 600 }
                    ColorAnimation { from: "#33f38ba8"; to: "transparent"; duration: 400 }
                    onStopped: { statusText.text = ""; statusBg.color = "transparent" }
                }
            }

            // Login Button
            Rectangle {
                id: loginBtn
                width: parent.width; height: 44
                color: loginMouse.containsMouse ? root.blue : root.surface0
                border.color: root.blue; border.width: 1
                Text {
                    anchors.centerIn: parent
                    text: textConstants.login
                    color: loginMouse.containsMouse ? root.crust : root.blue
                    font.family: config.Font || "Sans"
                    font.pixelSize: 14; font.bold: true
                }
                MouseArea {
                    id: loginMouse
                    anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                    onClicked: doLogin()
                }
                focus: true
                KeyNavigation.tab: sessionBoxItem
                KeyNavigation.backtab: passwordBox
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        doLogin()
                    }
                }
                Behavior on color { ColorAnimation { duration: 150 } }
            }

            // Session Selection
            Row {
                width: parent.width; height: 36; spacing: 10
                Text {
                    height: parent.height
                    text: textConstants.session
                    color: root.overlay0
                    font.family: config.Font || "Sans"
                    font.pixelSize: 12
                    verticalAlignment: Text.AlignVCenter
                }
                SessionBox {
                    id: sessionBoxItem
                    model: sessionModel
                    currentIndex: sessionModel ? sessionModel.lastIndex : 0
                    fontFamily: config.Font || "Sans"
                    surface0: root.surface0
                    surface1: root.surface1
                    blue: root.blue
                    subtext1: root.subtext1
                }
            }
        }
    }

    PowerButtons {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 32
        fontFamily: config.Font || "Sans"
        sddm: sddm
        surface0: root.surface0
        surface1: root.surface1
        yellow: root.yellow
        red: root.red
        mauve: root.mauve
    }

    Text {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 20
        text: "  " + sddm.hostName
        color: root.overlay0
        font.family: config.Font || "Sans"
        font.pixelSize: 13
    }

    Component.onCompleted: passwordBox.focus = true

    MouseArea {
        anchors.fill: parent; z: 99
        visible: sessionBoxItem.isOpen
        onClicked: sessionBoxItem.isOpen = false
    }

    function doLogin() {
        statusText.text = ""
        sddm.login(usernameBox.text, passwordBox.text, sessionBoxItem.currentIndex)
    }
}
