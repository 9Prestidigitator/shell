pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property var workspaces: []
    property var windows: []
    property var activeWorkspaceId: null

}
