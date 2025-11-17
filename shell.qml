import Quickshell
import Quickshell.Io
import QtQuick
import qs.Modules

Scope {
    Bar {
        id: bar
    }
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

            function toggleBar(): void {
                console.log("Toggle bar");
                bar.barVisible = bar.barVisible ? false : true;
            }
        }
    }
}
