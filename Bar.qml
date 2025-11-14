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

            implicitHeight: 20

            ClockWidget {
                anchors.centerIn: parent
            }
        }
    }
}
