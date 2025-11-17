import QtQuick
import QtQuick.Layouts
import qs.Services

Item {
    id: root
    implicitWidth: workspaceSize + 16
    implicitHeight: layout.implicitHeight

    property int workspaceSize: 28
    property int windowSize: 16
    property int spacing: 3
    property int windowSpacing: 3
    property int padding: 1

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

                        Rectangle {
                            width: root.windowSize
                            height: root.windowSize
                            radius: root.windowSize / 2
                            anchors.horizontalCenter: parent.horizontalCenter

                            color: modelData.isFocused ? "orange" : "blue"
                            border.color: "transparent"
                            border.width: 1

                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
