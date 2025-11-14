import QtQuick
import QtQuick.Layouts

Row {
    spacing: 5
    implicitWidth: childrenRect.width
    implicitHeight: 24
    
    Repeater {
        model: Niri.workspaces
        
        Rectangle {
            id: workspaceBubble
            width: Math.max(40, iconRow.implicitWidth + 16)  // Expand for icons
            height: 24
            radius: 4
            
            color: modelData.is_active ? "#5294e2" : "#444"
            border.color: modelData.is_focused ? "#fff" : "transparent"
            border.width: 2
            
            Column {
                anchors.centerIn: parent
                spacing: 2
                
                // Workspace name/number
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: modelData.name || (modelData.idx + 1)
                    color: "white"
                    font.pixelSize: 10
                    font.bold: modelData.is_active
                }
                
                // App icons row
                Row {
                    id: iconRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 2
                    
                    Repeater {
                        model: {
                            const wins = Niri.getWindowsForWorkspace(modelData.id);
                            // Limit to 4 icons max
                            return wins.slice(0, 4);
                        }
                        
                        AppIcon {
                            appId: modelData.app_id || "unknown"
                            isActive: modelData.is_focused
                        }
                    }
                    
                    // Show "+N" if more windows
                    Text {
                        visible: {
                            const wins = Niri.getWindowsForWorkspace(workspaceBubble.modelData.id);
                            return wins.length > 4;
                        }
                        text: {
                            const wins = Niri.getWindowsForWorkspace(workspaceBubble.modelData.id);
                            return `+${wins.length - 4}`;
                        }
                        color: "white"
                        font.pixelSize: 8
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
            
            // Click to switch workspace
            MouseArea {
                anchors.fill: parent
                onClicked: Niri.switchToWorkspace(modelData.id)
                cursorShape: Qt.PointingHandCursor
            }
            
            // Urgent indicator
            Rectangle {
                visible: modelData.is_urgent
                anchors {
                    top: parent.top
                    right: parent.right
                    margins: 2
                }
                width: 6
                height: 6
                radius: 3
                color: "#ff5555"
            }
        }
    }
}
