// Window icon configuration
// Each pattern is matched against the window title in order
// First match wins, or falls back to defaultIcon

const windowIconConfig = {
    // Default icon for unmatched windows
    defaultIcon: "•",

    urgentIcon: "!",
    
    // Font settings
    fontFamily: "Hack Nerd Font",
    fontSize: 12,
    
    // Pattern matching rules (regex pattern -> icon character)
    patterns: [
        // GUI
        { pattern: /firefox/i, icon: "" },
        { pattern: /brave/i, icon: "󰞀" },
        { pattern: /chrome|chromium/i, icon: "" },
        { pattern: /discord/i, icon: "" },
        { pattern: /steam/i, icon: "" },
        { pattern: /code|vscode/i, icon: "↯" },
        { pattern: /spotify/i, icon: "♫" },
        { pattern: /mpv/i, icon: "" },
        { pattern: /git/i, icon: "" },
        { pattern: /docker/i, icon: "" },
        { pattern: /nautilus|files/i, icon: "" },
        { pattern: /dolphin/i, icon: "󱢴" },
        { pattern: /guitarpro/i, icon: "󰋅" },
        
        // CLI/TUI
        { pattern: /emacs/i, icon: "" },
        { pattern: /kitty/i, icon: "󰄛" },
        { pattern: /alacritty/i, icon: "" },
        { pattern: /vim|nvim|neovim|Neovim/i, icon: "" },
    ]
};

// Helper function to get icon for a window title
function getIconForWindow(title) {
    if (!title) return windowIconConfig.defaultIcon;
    
    for (let rule of windowIconConfig.patterns) {
        if (rule.pattern.test(title)) {
            return rule.icon;
        }
    }
    
    return windowIconConfig.defaultIcon;
}
