import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

Scope {
    property bool barVisible: true
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: barWindow
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                bottom: true
            }

            color: "transparent"

            visible: barVisible ? true : false

            Behavior on visible {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }

            WlrLayershell.layer: WlrLayer.Top
            mask: Region {
                item: barContent
            }
            implicitWidth: 36
            property real contentWidth: 24

            Rectangle {
                id: barContent
                width: 36
                color: Qt.hsla(0.66, 0.05, 0.25, 0.85)
                opacity: 0.8

                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    rightMargin: 0
                    leftMargin: 6
                    topMargin: 8
                    bottomMargin: 8
                }
                radius: 18

                ColumnLayout {
                    anchors {
                        topMargin: 4
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                    }
                    spacing: 10
                    Workspaces {}
                }
            }
        }
    }
}
