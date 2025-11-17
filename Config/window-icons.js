const windowIconConfig = {
  defaultIcon: "•",

  urgentIcon: "",

  // Font settings
  fontFamily: "Hack Nerd Font",
  fontSize: 14,

  patterns: [
    // GUI
    { pattern: /firefox/i, icon: "" },
    { pattern: /brave/i, icon: "󰞀", offset: -0.8 },
    { pattern: /chrome|chromium/i, icon: "", offset: 0 },
    { pattern: /discord/i, icon: "" },
    { pattern: /steam/i, icon: "" },
    { pattern: /code|vscode/i, icon: "↯" },
    { pattern: /spotify/i, icon: "♫" },
    { pattern: /mpv/i, icon: "" },
    { pattern: /git/i, icon: "" },
    { pattern: /docker/i, icon: "" },
    { pattern: /nautilus|files/i, icon: "", offset: -1.85 },
    { pattern: /dolphin/i, icon: "󱢴" },
    { pattern: /guitarpro/i, icon: "󰋅" },

    // CLI/TUI
    { pattern: /kitty/i, icon: "󰄛", offset: -1.3 },
    { pattern: /emacs/i, icon: "" },
    { pattern: /alacritty/i, icon: "" },
    { pattern: /vim|nvim|neovim|Neovim/i, icon: "" },
  ],
};

// Helper function to get icon for a window title
function getIconForWindow(title, isUrgent) {
  if (isUrgent) {
    return windowIconConfig.urgentIcon;
  }

  if (!title) return windowIconConfig.defaultIcon;

  for (let rule of windowIconConfig.patterns) {
    if (rule.pattern.test(title)) {
      return [rule.icon, rule.offset];
    }
  }

  return [windowIconConfig.defaultIcon, 0];
}
