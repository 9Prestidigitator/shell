pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: niriEvents

    property bool initialized: false
    property bool debug: true
    property var workspaces: ({})
    property var windows: ({})
    property var sortedWorkspacesList: []
    property int activeWorkspaceId: -1
    property int focusedWindowId: -1

    signal ready
    signal workspaceAdded(int id, var workspace)
    signal workspaceRemoved(int id)
    signal workspaceActivated(int id)
    signal windowAdded(int id, var window)
    signal windowRemoved(int id)
    signal windowFocusChanged(int id)
    signal windowMoved(int windowId, int workspaceId)

    property Process niriProcess: Process {
        id: niriProcess
        command: ["niri", "msg", "--json", "event-stream"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                try {
                    const event = JSON.parse(data.trim());
                    handleEvent(event);
                } catch (e) {
                    console.log(e);
                }
            }
        }

        onExited: (code, status) => {
            console.error("Niri event stream exited:", code, status);
        }
    }

    function handleEvent(event) {
        let workspacesReceived = false;
        let windowsReceived = false;

        if (event.WorkspacesChanged) {
            const workspacesData = event.WorkspacesChanged.workspaces;

            const oldWorkspaces = workspaces;

            workspaces = {};

            for (let ws of workspacesData) {
                const workspace = {
                    id: ws.id,
                    idx: ws.idx,
                    name: ws.name,
                    output: ws.output,
                    isUrgent: ws.is_urgent,
                    isActive: ws.is_active,
                    isFocused: ws.is_focused,
                    activeWindowId: ws.active_window_id,
                    windows: oldWorkspaces[ws.id]?.windows || []
                };

                workspaces[ws.id] = workspace;

                if (ws.isActive) {
                    activeWorkspaceId = ws.id;
                }
            }
            updateSortedWorkspacesList();
            workspacesReceived = true;
        }

        if (event.WindowsChanged) {
            const windowsData = event.WindowsChanged.windows;

            windows = {};

            for (let wsId in workspaces) {
                workspaces[wsId].windows = [];
            }

            for (let win of windowsData) {
                const window = {
                    id: win.id,
                    title: win.title,
                    appId: win.app_id,
                    pid: win.pid,
                    workspaceId: win.workspace_id,
                    isFocused: win.is_focused,
                    isFloating: win.is_floating
                };

                windows[win.id] = window;

                if (workspaces[win.workspace_id]) {
                    workspaces[win.workspace_id].windows.push(window);
                }
                if (win.isFocused) {
                    focusedWindowId = win.id;
                }
            }
            updateSortedWorkspacesList();
            windowsReceived = true;
        }

        if (event.WorkspaceActivated) {
            const wsId = event.WorkspaceActivated.id;
            const focused = event.WorkspaceActivated.focused;

            for (let id in workspaces) {
                workspaces[id].isActive = false;
            }

            if (workspaces[wsId]) {
                workspaces[wsId].isActive = true;
                activeWorkspaceId = wsId;
            }
            updateSortedWorkspacesList();
            workspaceActivated(wsId);
        }

        // THIS NEEDS WORK
        if (event.WindowOpenedOrChanged) {
            const winData = event.WindowOpenedOrChanged.window;
            
            const oldWindow = windows[winData.id];
            const windowMoved = oldWindow && oldWindow.workspaceId !== winData.workspace_id;
            
            // Create new window object
            const window = {
                id: winData.id,
                title: winData.title,
                appId: winData.app_id,
                workspaceId: winData.workspace_id,
                isFocused: winData.is_focused
            };
            
            // Update global windows map
            windows[winData.id] = window;
            
            // Remove from ALL workspaces first (clean slate)
            for (let wsId in workspaces) {
                workspaces[wsId].windows = workspaces[wsId].windows.filter(w => w.id !== winData.id);
            }
            
            // Add to the correct workspace
            if (workspaces[winData.workspace_id]) {
                workspaces[winData.workspace_id].windows.push(window);
                // Create new workspace object to trigger QML update
                const ws = workspaces[winData.workspace_id];
                workspaces[winData.workspace_id] = {
                    id: ws.id,
                    idx: ws.idx,
                    name: ws.name,
                    output: ws.output,
                    isActive: ws.isActive,
                    isFocused: ws.isFocused,
                    activeWindowId: ws.activeWindowId,
                    windows: workspaces[winData.workspace_id].windows.slice()
                };
            }
            
            if (winData.is_focused) {
                focusedWindowId = winData.id;
            }
            
            if (windowMoved) {
                windowMoved(winData.id, winData.workspace_id);
            } else {
                windowAdded(winData.id, window);
            }
            
            updateSortedWorkspacesList();
        }

        if (event.WindowClosed) {
            const winId = event.WindowClosed.id;

            if (windows[winId]) {
                const workspaceId = windows[winId].workspaceId;
                if (workspaces[workspaceId]) {
                    workspaces[workspaceId].windows = workspaces[workspaceId].windows.filter(w => w.id !== winId);
                }
            }

            delete windows[winId];

            if (focusedWindowId === winId) {
                focusedWindowId = -1;
            }

            windowRemoved(winId);
            updateSortedWorkspacesList();
        }

        if (event.WindowFocusChanged) {
            const winId = event.WindowFocusChanged.id;
            for (let id in windows) {
                windows[id].isFocused = false;
            }
            if (windows[winId]) {
                windows[winId].isFocused = true;
                focusedWindowId = winId;
            }
            for (let wsId in workspaces) {
                for (let win of workspaces[wsId].windows) {
                    win.isFocused = (win.id === winId);
                }
            }
            windowFocusChanged(winId);
            updateSortedWorkspacesList();
        }

        if (event.WorkspaceActiveWindowChanged) {
            const wsId = event.WorkspaceActiveWindowChanged.workspace_id;
            const winId = event.WorkspaceActiveWindowChanged.active_window_id;

            if (workspaces[wsId]) {
                workspaces[wsId].activeWindowId = winId;
            }
        }

        if (initialized) {
            debugNiriIpc();
        }

        if (!initialized && Object.keys(workspaces).length > 0 && windowsReceived) {
            initialized = true;
            ready();
        }
    }

    function getWorkspace(id) {
        return workspaces[id] || null;
    }

    function getWindow(id) {
        return windows[id] || null;
    }

    function getWorkspaceWindows(workspaceId) {
        const ws = workspaces[workspaceId];
        return ws ? ws.windows : [];
    }

    function getActiveWorkspace() {
        return workspaces[activeWorkspaceId] || null;
    }

    function getFocusedWindow() {
        return windows[focusedWindowId] || null;
    }

    function getSortedWorkspaces() {
        return sortedWorkspacesList;
    }

    function getSortedWindows() {
        return Object.values(windows).sort((a, b) => a.idx - b.idx);
    }

    function updateSortedWorkspacesList() {
        sortedWorkspacesList = Object.values(workspaces).sort((a, b) => a.idx - b.idx);
    }

    function debugNiriIpc() {
        if (!debug)
            return;
        console.log("== NIRI STATE ==");
        const sortedWorkspaces = getSortedWorkspaces();
        const sortedWindows = getSortedWindows();

        for (let ws of sortedWorkspaces) {
            const activeMarker = ws.isActive ? " [ACTIVE]" : "";
            const focusedMarker = ws.isFocused ? " [FOCUSED]" : "";
            const wsName = ws.name ? ` (${ws.name})` : "";

            console.log(`Workspace ${ws.id}${wsName}${activeMarker}${focusedMarker}`);

            if (ws.windows.length === 0) {
                console.log("  (no windows)");
            } else {
                for (let win of ws.windows) {
                    const focusMarker = win.isFocused ? " *" : "";
                    const appId = win.appId ? ` [${win.appId}]` : "";
                    console.log(`  ${win.title}${appId}${focusMarker}`);
                }
            }
        }

        console.log("==  WINDOWS   ==");

        for (let win of sortedWindows) {
            console.log(`${win.workspaceId}, ${win.isFocused},\t ${win.title}`);
        }

        console.log("================");
    }
}
