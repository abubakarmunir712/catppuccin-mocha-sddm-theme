import QtQuick
import QtQuick.Controls

Column {
    id: clock
    property color timeColor: "#f5c2e7"
    property color dateColor: "#bac2de"
    property string fontFamily: "Sans"

    spacing: 6

    Text {
        id: timeLabel
        anchors.horizontalCenter: parent.horizontalCenter
        color: clock.timeColor
        font.family: clock.fontFamily
        font.pixelSize: 96
        font.bold: true
        text: Qt.formatTime(new Date(), "hh:mm")

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: timeLabel.text = Qt.formatTime(new Date(), "hh:mm")
        }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        color: clock.dateColor
        font.family: clock.fontFamily
        font.pixelSize: 22
        font.bold: true
        text: Qt.formatDate(new Date(), "dddd, MMMM dd yyyy")
    }
}
