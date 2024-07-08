  cat ~/themes/themes/gruvbox_dark.toml > ~/.config/alacritty/alacritty.toml

  qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'string: var Desktops = desktops(); for (i=0;i<Desktops.length;i++) { d = Desktops[i]; d.wallpaperPlugin = "org.kde.color"; d.currentConfigGroup = Array("Wallpaper", "org.kde.color", "General"); d.writeConfig("Color", "#3d3d3d"); }'

  lookandfeeltool -a gruv
