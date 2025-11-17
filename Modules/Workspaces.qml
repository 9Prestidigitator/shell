import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.Services
import "../Config/window-icons.js" as IconConfig

Item {
    id: root
    implicitWidth: workspaceSize + 16
    implicitHeight: layout.implicitHeight

    property int workspaceSize: 16
    property int windowSize: 16
    property int spacing: 3
    property int windowSpacing: 3
    property int padding: 1

    property var iconConfig: IconConfig.windowIconConfig
    function getWindowIcon(title) {
        return IconConfig.getIconForWindow(title);
    }

    Column {
        id: layout
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: root.spacing
        topPadding: root.padding
        bottomPadding: root.padding

        Repeater {
            model: Niri.initialized ? Niri.getSortedWorkspaces() : []

            Rectangle {
                id: workspaceBlock
                width: root.workspaceSize
                height: Math.max(root.workspaceSize, windowColumn.height + 12)
                radius: 16

                color: modelData.isActive ? "red" : "green"
                border.color: modelData.isFocused ? "#ffffff" : "transparent"
                border.width: 2

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }

                Behavior on height {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }

                Column {
                    id: windowColumn
                    anchors.centerIn: parent
                    spacing: root.windowSpacing

                    Repeater {
                        model: modelData.windows

                        Text {
                            width: root.windowSize
                            height: root.windowSize

                            anchors.horizontalCenter: parent.horizontalCenter

                            text: root.getWindowIcon(modelData.title, modelData.isUrgent)

                            // Font styling from config
                            font.family: root.iconConfig.fontFamily
                            font.pixelSize: root.iconConfig.fontSize
                            font.bold: false

                            // Orange if focused, blue if inactive
                            color: modelData.isFocused ? "white" : "#453f3b"

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            // Smooth color transitions
                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    Quickshell.execDetached(["niri", "msg", "action", "focus-window", modelData.idx]);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    // Show loading state
    Rectangle {
        anchors.centerIn: parent
        width: root.workspaceSize
        height: root.workspaceSize
        radius: 6
        color: "#444444"
        visible: !Niri.initialized

        Text {
            anchors.centerIn: parent
            text: "..."
            color: "#888888"
            font.pixelSize: 16
        }
    }
}
