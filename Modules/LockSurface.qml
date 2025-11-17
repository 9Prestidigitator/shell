import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell
import Quickshell.Wayland

Rectangle {
    id: root
    required property LockContext context

    color: "black"
    Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: Qt.resolvedUrl(Quickshell.shellPath("assets/image.jpg"))
    }

    // Button {
    //     text: "Its not working, let me out"
    //     onClicked: context.unlocked()
    // }

    Label {
        id: clock
        property var date: new Date()

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 230
        }

        // The native font renderer tends to look nicer at large sizes.
        font.family: "Hack Nerd Font"
        renderType: Text.NativeRendering
        font.pointSize: 60
        color: "white"

        // updates the clock every second
        Timer {
            running: true
            repeat: true
            interval: 1000

            onTriggered: clock.date = new Date()
        }

        // updated when the date changes
        text: {
            const hours = this.date.getHours().toString().padStart(2, '0');
            const minutes = this.date.getMinutes().toString().padStart(2, '0');
            return `${hours}:${minutes}`;
        }
    }

    ColumnLayout {
        // Uncommenting this will make the password entry invisible except on the active monitor.
        visible: Window.active

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.verticalCenter
        }

        RowLayout {
            TextField {
                id: passwordBox

                implicitWidth: 300
                padding: 10

                focus: true
                font.pixelSize: 20
                cursorVisible: false
                enabled: !root.context.unlockInProgress
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData
                horizontalAlignment: Text.AlignHCenter
                color: "white"

                background.opacity: 0

                // Update the text in the context when the text in the box changes.
                onTextChanged: root.context.currentText = this.text

                // Try to unlock when enter is pressed.
                onAccepted: root.context.tryUnlock()

                // Update the text in the box to match the text in the context.
                // This makes sure multiple monitors have the same text.
                Connections {
                    target: root.context

                    function onCurrentTextChanged() {
                        passwordBox.text = root.context.currentText;
                    }
                }
            }

            // Button {
            // 	text: "Unlock"
            // 	padding: 10
            //
            // 	// don't steal focus from the text box
            // 	focusPolicy: Qt.NoFocus
            //
            // 	enabled: !root.context.unlockInProgress && root.context.currentText !== "";
            // 	onClicked: root.context.tryUnlock();
            // }
        }

        Label {
            visible: root.context.showFailure
            text: "Incorrect password"
        }
    }
}
