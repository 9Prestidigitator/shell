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
    
    // Poll for updates (simpler than event stream for now)
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            workspaceProc.running = true;
            windowProc.running = true;
        }
    }
    
    // Helper function to get windows for a workspace
    function getWindowsForWorkspace(workspaceId) {
        if (!root.windows) return [];
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
