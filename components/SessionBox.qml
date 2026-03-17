import QtQuick
import QtQuick.Controls

Item {
    id: sessionBox
    property var model
    property int currentIndex: 0
    property bool isOpen: false
    property string fontFamily: "Sans"
    
    property color surface0: "#313244"
    property color surface1: "#45475a"
    property color blue:     "#89b4fa"
    property color subtext1: "#bac2de"

    width: parent.width - 70
    height: parent.height

    function getSessionName(idx) {
        if (!sessionBox.model || idx < 0) return "Default"
        var modelIndex = sessionBox.model.index(idx, 0)
        
        var label = sessionBox.model.data(modelIndex, Qt.UserRole)
        if (!label || label === "")
            label = sessionBox.model.data(modelIndex, Qt.DisplayRole)
            
        if (!label || label === "") {
            var file = sessionBox.model.data(modelIndex, Qt.UserRole + 2)
            if (file) {
                var parts = file.split("/")
                label = parts[parts.length - 1].replace(".desktop", "")
            }
        }
        return label || "Default"
    }

    Rectangle {
        anchors.fill: parent
        color: sessionBoxMouse.containsMouse ? sessionBox.surface1 : sessionBox.surface0
        border.color: sessionBox.isOpen ? sessionBox.blue : sessionBox.surface1
        border.width: 1

        Text {
            anchors.left: parent.left
            anchors.right: dropArrow.left
            anchors.margins: 8
            anchors.verticalCenter: parent.verticalCenter
            text: sessionBox.getSessionName(sessionBox.currentIndex)
            color: sessionBox.subtext1
            font.family: sessionBox.fontFamily
            font.pixelSize: 12
            elide: Text.ElideRight
        }

        Text {
            id: dropArrow
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: sessionBox.isOpen ? "▲" : "▼"
            color: sessionBox.subtext1
            font.pixelSize: 10
        }

        MouseArea {
            id: sessionBoxMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: sessionBox.isOpen = !sessionBox.isOpen
        }
    }

    Rectangle {
        visible: sessionBox.isOpen
        anchors.top: parent.bottom
        anchors.topMargin: 2
        anchors.left: parent.left
        anchors.right: parent.right
        height: Math.min(contentCol.height + 4, 150)
        color: sessionBox.surface0
        border.color: sessionBox.surface1
        border.width: 1
        z: 100

        Flickable {
            anchors.fill: parent
            anchors.margins: 2
            contentHeight: contentCol.height
            clip: true

            Column {
                id: contentCol
                width: parent.width

                Repeater {
                    model: sessionBox.model
                    Rectangle {
                        width: contentCol.width
                        height: 32
                        color: itemMouse.containsMouse ? sessionBox.surface1 : "transparent"

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: 8
                            text: sessionBox.getSessionName(index)
                            color: sessionBox.currentIndex === index ? sessionBox.blue : sessionBox.subtext1
                            font.family: sessionBox.fontFamily
                            font.pixelSize: 12
                            elide: Text.ElideRight
                        }

                        MouseArea {
                            id: itemMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                sessionBox.currentIndex = index
                                sessionBox.isOpen = false
                            }
                        }
                    }
                }
            }
        }
    }
}
