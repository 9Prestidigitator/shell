import QtQuick

Item {
    id: root
    required property string appId
    required property bool isActive

    width: 16
    height: 16

    // Try to load icon from system
    Image {
        id: iconImage
        anchors.fill: parent
        source: getIconPath(root.appId)
        fillMode: Image.PreserveAspectFit
        smooth: true

        // Fallback to colored circle if icon not found
        visible: status === Image.Ready
    }

    // Fallback indicator
    Rectangle {
        anchors.fill: parent
        visible: iconImage.status !== Image.Ready
        radius: width / 2
        color: root.isActive ? "#5294e2" : "#888"

        Text {
            anchors.centerIn: parent
            text: root.appId.charAt(0).toUpperCase()
            color: "white"
            font.pixelSize: 10
            font.bold: true
        }
    }

    function getIconPath(appId) {
        // Common icon paths on NixOS
        const iconDirs = ["/run/current-system/sw/share/icons/hicolor/scalable/apps/", "/run/current-system/sw/share/icons/hicolor/48x48/apps/", "/run/current-system/sw/share/pixmaps/", `${Qt.platform.os === "linux" ? process.env.HOME : ""}/.local/share/icons/hicolor/scalable/apps/`];

        const iconNames = [`${appId}.svg`, `${appId}.png`, `${appId.toLowerCase()}.svg`, `${appId.toLowerCase()}.png`];

        // Try each combination
        for (const dir of iconDirs) {
            for (const name of iconNames) {
                const path = `file://${dir}${name}`;
                // Return first match (QML will handle if it doesn't exist)
                return path;
            }
        }

        return "";
    }
}
