import Quickshell
import Quickshell.Io
import QtQuick

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            height: 32
            color: "#1e1e1e"

            // Main container - uses Row for left/right layout
            Item {
                anchors.fill: parent
                Row {
                    anchors {
                        right: parent.right
                        rightMargin: 10
                        verticalCenter: parent.verticalCenter
                    }
                    spacing: 15

                    // You can add more widgets here before the clock
                    // SystemTray { }

                    ClockWidget {
                        color: "#C4E9F1"
                    }
                }
            }
        }
    }
}
