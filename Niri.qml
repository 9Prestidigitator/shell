pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    
    property var workspaces: []
    property var windows: []
    property var activeWorkspaceId: null
    
    // Get workspaces
    Process {
        id: workspaceProc
        command: ["niri", "msg", "--json", "workspaces"]
        running: false
        
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(this.text.trim());
                    if (data.Ok && data.Ok.Workspaces) {
                        root.workspaces = data.Ok.Workspaces;
                        root.workspaces.forEach(ws => {
                            if (ws.is_active) {
                                root.activeWorkspaceId = ws.id;
                            }
                        });
                    }
                } catch (e) {
                    console.error("Failed to parse workspaces:", e);
                }
            }
        }
    }
    
    // Get windows
    Process {
        id: windowProc
        command: ["niri", "msg", "--json", "windows"]
        running: false
        
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(this.text.trim());
                    if (data.Ok && data.Ok.Windows) {
                        root.windows = data.Ok.Windows;
                    }
                } catch (e) {
                    console.error("Failed to parse windows:", e);
                }
            }
        }
    }
    
    // Event stream for real-time updates
    Process {
        id: eventProc
        command: ["niri", "msg", "event-stream"]
        running: true
        
        stdout: StdioCollector {
            onLineReceived: line => {
                try {
                    const event = JSON.parse(line);
                    if (event.WorkspacesChanged || event.WorkspaceActivated) {
                        workspaceProc.running = true;
                    }
                    if (event.WindowsChanged || event.WindowOpenedOrChanged || event.WindowClosed) {
                        windowProc.running = true;
                    }
                } catch (e) {
                    console.error("Failed to parse event:", e);
                }
            }
        }
    }
    
    // Initial load
    Timer {
        interval: 100
        running: true
        repeat: false
        onTriggered: {
            workspaceProc.running = true;
            windowProc.running = true;
        }
    }
    
    // Helper function to get windows for a workspace
    function getWindowsForWorkspace(workspaceId) {
        return root.windows.filter(win => win.workspace_id === workspaceId);
    }
    
    function switchToWorkspace(workspaceId) {
        const switchProc = Qt.createQmlObject(
            `import Quickshell.Io;
             Process {
                 command: ["niri", "msg", "action", "focus-workspace", "${workspaceId}"]
                 running: true
             }`,
            root
        );
    }
}
