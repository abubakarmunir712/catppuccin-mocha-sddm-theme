import QtQuick
import QtQuick.Controls

Row {
    id: powerButtons
    property string fontFamily: "Sans"
    property var sddm
    
    // Theme colors
    property color surface0: "#313244"
    property color surface1: "#45475a"
    property color yellow:   "#f9e2af"
    property color red:      "#f38ba8"
    property color mauve:    "#cba6f7"

    spacing: 16

    // Reboot
    Rectangle {
        width: 140
        height: 40
        color: rbMouse.containsMouse ? powerButtons.surface0 : "transparent"
        border.color: powerButtons.surface1
        border.width: 1

        Row {
            anchors.centerIn: parent
            spacing: 8
            Text {
                text: "󰜉"
                color: powerButtons.yellow
                font.family: powerButtons.fontFamily
                font.pixelSize: 18
                verticalAlignment: Text.AlignVCenter
            }
            Text {
                text: "Reboot"
                color: powerButtons.yellow
                font.family: powerButtons.fontFamily
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter
            }
        }

        MouseArea {
            id: rbMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: powerButtons.sddm.reboot()
        }
        Behavior on color { ColorAnimation { duration: 100 } }
    }

    // Shutdown
    Rectangle {
        width: 140
        height: 40
        color: sdMouse.containsMouse ? powerButtons.surface0 : "transparent"
        border.color: powerButtons.surface1
        border.width: 1

        Row {
            anchors.centerIn: parent
            spacing: 8
            Text {
                text: "⏻"
                color: powerButtons.red
                font.family: powerButtons.fontFamily
                font.pixelSize: 18
                verticalAlignment: Text.AlignVCenter
            }
            Text {
                text: "Shutdown"
                color: powerButtons.red
                font.family: powerButtons.fontFamily
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter
            }
        }

        MouseArea {
            id: sdMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: powerButtons.sddm.powerOff()
        }
        Behavior on color { ColorAnimation { duration: 100 } }
    }

    // Suspend
    Rectangle {
        width: 140
        height: 40
        color: spMouse.containsMouse ? powerButtons.surface0 : "transparent"
        border.color: powerButtons.surface1
        border.width: 1

        Row {
            anchors.centerIn: parent
            spacing: 8
            Text {
                text: "󰤄"
                color: powerButtons.mauve
                font.family: powerButtons.fontFamily
                font.pixelSize: 18
                verticalAlignment: Text.AlignVCenter
            }
            Text {
                text: "Suspend"
                color: powerButtons.mauve
                font.family: powerButtons.fontFamily
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter
            }
        }

        MouseArea {
            id: spMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: powerButtons.sddm.suspend()
        }
        Behavior on color { ColorAnimation { duration: 100 } }
    }
}
