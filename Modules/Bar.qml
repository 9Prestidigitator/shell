import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

Scope {
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

            WlrLayershell.layer: WlrLayer.Top
            mask: Region {
                item: barContent
            }
            implicitWidth: barContent.width
            property real contentWidth: 24

            Rectangle {
                id: barContent
                width: 36
                color: "blue"
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                }
                ColumnLayout {
                    anchors {
                        topMargin: 10
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
