import Quickshell
import Quickshell.Io
import QtQuick
import qs.Modules

Scope {
    Bar {}
    Background {}
    LockScreen {
        id: lockscreen
    }

    Item {
        id: root
        IpcHandler {
            target: "mainIPC"
            function toggleLock(): void {
                console.log("Lockscreen toggled");
                lockscreen.locked = true;
            }
        }
    }
}
