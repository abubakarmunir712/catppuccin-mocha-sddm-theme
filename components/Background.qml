import QtQuick
import QtQuick.Effects

Rectangle {
    id: background
    property url source: ""
    property int blurRadius: 0
    property color baseColor: "#1e1e2e"
    property real overlayOpacity: 0.50

    anchors.fill: parent
    color: background.baseColor

    Image {
        id: backgroundImage
        anchors.fill: parent
        source: background.source
        fillMode: Image.PreserveAspectCrop
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
        smooth: true
        
        layer.enabled: background.blurRadius > 0
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: Math.min(background.blurRadius / 100.0, 1.0)
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: background.overlayOpacity
    }
}
