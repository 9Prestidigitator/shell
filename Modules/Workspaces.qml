import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.Services
import "../Config/window-icons.js" as IconConfig

Item {
    id: root
    implicitWidth: workspaceSize + 16
    implicitHeight: layout.implicitHeight

    property int workspaceSize: 20
    property int windowSize: 20
    property int spacing: 5
    property int windowSpacing: 2
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
                height: Math.max(root.workspaceSize, windowColumn.height + 10)
                radius: 16

                opacity: modelData.windows.length > 0 ? 1 : 0
                color: modelData.isActive ? "#798991" : "#5C696F"
                border.color: "transparent"
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

                        Item {
                            id: windowBlock
                            width: root.workspaceSize
                            height: root.windowSize

                            Text {
                                width: parent.width
                                height: parent.height
                                // Offset from config logo
                                x: root.getWindowIcon(modelData.appId, modelData.isUrgent)[1]

                                text: root.getWindowIcon(modelData.appId, modelData.isUrgent)[0]

                                font.family: root.iconConfig.fontFamily
                                font.pixelSize: root.iconConfig.fontSize
                                font.bold: false

                                color: modelData.isFocused ? "white" : "#453f3b"

                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 150
                                        easing.type: Easing.InOutQuad
                                    }
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    Quickshell.execDetached(["niri", "msg", "action", "focus-window", "--id", modelData.id]);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
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
            font.pixelSize: 12
        }
    }
}
