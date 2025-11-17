pragma ComponentBehavior: Bound

import Quickshell.Wayland
import QtQuick

WlSessionLock {
    id: lock

    locked: false

    WlSessionLockSurface {
        LockSurface {
            anchors.fill: parent
            context: LockContext {
                onUnlocked: {
                    lock.locked = false;
                }
            }
        }
    }
}
