// Window icon configuration
// Each pattern is matched against the window title in order
// First match wins, or falls back to defaultIcon

const windowIconConfig = {
    // Default icon for unmatched windows
    defaultIcon: "•",
    
    // Font settings
    fontFamily: "nerd",
    fontSize: 12,
    
    // Pattern matching rules (regex pattern -> icon character)
    patterns: [
        // Browsers
        { pattern: /firefox/i, icon: "F" },
        { pattern: /chrome|chromium/i, icon: "C" },
        { pattern: /brave/i, icon: "B" },
        
        // Terminals
        { pattern: /kitty/i, icon: "K" },
        { pattern: /alacritty/i, icon: "A" },
        { pattern: /wezterm/i, icon: "W" },
        { pattern: /terminal/i, icon: "T" },
        
        // Editors
        { pattern: /vim|nvim|neovim/i, icon: "V" },
        { pattern: /emacs/i, icon: "E" },
        { pattern: /code|vscode/i, icon: "↯" },
        
        // Communication
        { pattern: /discord/i, icon: "D" },
        { pattern: /slack/i, icon: "S" },
        { pattern: /telegram/i, icon: "⚡" },
        
        // Media
        { pattern: /spotify/i, icon: "♫" },
        { pattern: /mpv/i, icon: "▶" },
        
        // Development
        { pattern: /git/i, icon: "G" },
        { pattern: /docker/i, icon: "🐳" },
        
        // File managers
        { pattern: /nautilus|files/i, icon: "📁" },
        { pattern: /thunar/i, icon: "📂" },
        
        // Quickshell
        { pattern: /quickshell/i, icon: "Q" },
        
        // System
        { pattern: /htop|btop/i, icon: "%" },
        { pattern: /settings/i, icon: "⚙" },
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
