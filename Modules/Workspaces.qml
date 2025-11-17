import QtQuick
import QtQuick.Layouts
import qs.Services
import "file:///home/max/.config/quickshell/Config/window-icons.js" as IconConfig

Item {
    id: root
    implicitWidth: workspaceSize + 16
    implicitHeight: layout.implicitHeight

    property int workspaceSize: 28
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
                height: Math.max(root.workspaceSize, windowColumn.height + 14)
                radius: 16

                color: modelData.isActive ? "red" : "green"
                border.color: modelData.isFocused ? "#ffffff" : "transparent"
                border.width: 1

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
                    // columns: Math.ceil(Math.sqrt(modelData.windows.length))
                    spacing: root.windowSpacing

                    Repeater {
                        model: modelData.windows

                        // Rectangle {
                        //     width: root.windowSize
                        //     height: root.windowSize
                        //     radius: root.windowSize / 2
                        //     anchors.horizontalCenter: parent.horizontalCenter
                        //
                        //     color: modelData.isFocused ? "orange" : "blue"
                        //     border.color: "transparent"
                        //     border.width: 1
                        //
                        //     Behavior on color {
                        //         ColorAnimation {
                        //             duration: 200
                        //             easing.type: Easing.InOutQuad
                        //         }
                        //     }
                        // }
                        // Window icon text
                        Text {
                            width: root.windowSize
                            height: root.windowSize
                            anchors.horizontalCenter: parent.horizontalCenter

                            text: root.getWindowIcon(modelData.title)

                            // Font styling from config
                            font.family: root.iconConfig.fontFamily
                            font.pixelSize: root.iconConfig.fontSize
                            font.bold: true

                            // Orange if focused, blue if inactive
                            color: modelData.isFocused ? "#fb923c" : "#3b82f6"

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            // Smooth color transitions
                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", modelData.idx]);
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
