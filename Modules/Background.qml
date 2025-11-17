import Quickshell
import Quickshell.Wayland
import QtQuick

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: root
        required property var modelData
        screen: modelData

        WlrLayershell.layer: WlrLayer.Background
        WlrLayershell.exclusiveZone: -1

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            source: Qt.resolvedUrl(Quickshell.shellPath("assets/image.jpg"))
        }
    }
}
