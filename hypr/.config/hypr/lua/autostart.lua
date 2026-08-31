local commands = {
    "xrdb ~/.Xresources",
    "uwsm app -- waybar -c ~/.config/hypr/waybar.jsonc -s ~/.config/waybar/style.css -l error",
    "uwsm app -- hypridle",
    "uwsm app -- hyprpaper",
    "uwsm app -- waypaper --restore",
    "uwsm app -- nm-applet",
    "uwsm app -- mako",
}

hl.on("hyprland.start", function()
    for _, command in ipairs(commands) do
        hl.exec_cmd(command)
    end
end)
