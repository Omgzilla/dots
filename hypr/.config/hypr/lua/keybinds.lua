local home = os.getenv("HOME")
local mainMod = "SUPER"
local altMod = "ALT"

local foot = "uwsm app -- foot"
local fileManager = "uwsm app -- nautilus"
local rofi = "rofi -show drun -run-command 'uwsm app -- {cmd}'"
local fuzzel = "fuzzel --launch-prefix='uwsm app --'"
local braveApp = "uwsm app -- brave --app"
local missgpt = braveApp .. "=https://chatgpt.com"
local linear = braveApp .. "=https://linear.app/dwellir"
local docs = braveApp .. "=https://docs.internal.dwellir.com/docs"
local bluectl = home .. "/.local/bin/bluectl_rofi"
local wifictl = home .. "/.local/bin/network_menu"
local wmExit = home .. "/.local/bin/wm-exit"

hl.bind(altMod .. " + Return", hl.dsp.exec_cmd(foot))
hl.bind(altMod .. " + Space", hl.dsp.exec_cmd(rofi))
-- hl.bind(altMod .. " + SHIFT + Space", hl.dsp.exec_cmd(fuzzel))
hl.bind(altMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(altMod .. " + F9", hl.dsp.exec_cmd(bluectl))
hl.bind(altMod .. " + F10", hl.dsp.exec_cmd(wifictl))
hl.bind(altMod .. " + C", hl.dsp.exec_cmd(missgpt))
hl.bind(altMod .. " + L", hl.dsp.exec_cmd(linear))
hl.bind(altMod .. " + D", hl.dsp.exec_cmd(docs))

local recordRegion = [[sh -c 'state=/tmp/wf-recorder.pid; dir="$HOME/Videos/Screenrecords"; mkdir -p "$dir"; if [ -r "$state" ] && kill -0 "$(cat "$state")" 2>/dev/null; then kill -INT "$(cat "$state")" 2>/dev/null; rm -f "$state"; f="$dir/latest.mkv"; [ -f "$f" ] && notify-send -a recorder "Recording stopped" "$f" || notify-send -a recorder "Recording stopped"; else geo=$(slurp); [ -n "$geo" ] || { notify-send -a recorder "Recording canceled"; exit 0; }; file="$dir/wf-$(date +%F_%H-%M-%S).mkv"; ln -sf -- "$file" "$dir/latest.mkv"; ( wf-recorder -g "$geo" -c h264_vaapi -f "$file" & echo $! > "$state" ) >/dev/null 2>&1 & notify-send -a recorder "Recording started" "$file"; fi']]
local recordWindow = [[sh -c 'state=/tmp/wf-recorder.pid; dir="$HOME/Videos/Screenrecords"; mkdir -p "$dir"; if [ -r "$state" ] && kill -0 "$(cat "$state")" 2>/dev/null; then kill -INT "$(cat "$state")" 2>/dev/null; rm -f "$state"; notify-send -a recorder "Recording stopped" "$dir/latest.mkv"; else rect="$(hyprctl clients -j | jq -r ".[] | \"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1]) \\(.class)\"" | slurp -r)"; [ -n "$rect" ] || { notify-send -a recorder "Recording canceled"; exit 0; }; file="$dir/wf-$(date +%F_%H-%M-%S).mkv"; ln -sf -- "$file" "$dir/latest.mkv"; ( wf-recorder -g "$rect" -c h264_vaapi -f "$file" & echo $! > "$state" ) >/dev/null 2>&1 & notify-send -a recorder "Recording started" "$file"; fi']]
local recordOutput = [[sh -c 'state=/tmp/wf-recorder.pid; dir="$HOME/Videos/Screenrecords"; mkdir -p "$dir"; if [ -r "$state" ] && kill -0 "$(cat "$state")" 2>/dev/null; then kill -INT "$(cat "$state")" 2>/dev/null; rm -f "$state"; notify-send -a recorder "Recording stopped" "$dir/latest.mkv"; else out="$(slurp -o -f "%o")"; [ -n "$out" ] || { notify-send -a recorder "Recording canceled"; exit 0; }; file="$dir/wf-$(date +%F_%H-%M-%S).mkv"; ln -sf -- "$file" "$dir/latest.mkv"; ( wf-recorder -o "$out" -c h264_vaapi -f "$file" & echo $! > "$state" ) >/dev/null 2>&1 & notify-send -a recorder "Recording started" "$file"; fi']]

hl.bind(altMod .. " + F11", hl.dsp.exec_cmd(recordRegion))
hl.bind(altMod .. " + SHIFT + F11", hl.dsp.exec_cmd(recordWindow))
hl.bind(mainMod .. " + ALT + SHIFT + F11", hl.dsp.exec_cmd(recordOutput))

local screenshotRegion = [[sh -c 'dir="$HOME/Pictures/Screenshots"; mkdir -p "$dir"; name="$(date +hyprshot-%Y%m%d-%H%M%S).png"; path="$dir/$name"; ln -sf -- "$path" "$dir/latest.png"; hyprshot -m region -z -o "$dir" -f "$name" && notify-send -a Hyprshot "Screenshot" "$path" || rm -f "$dir/latest.png"']]
local screenshotWindow = [[sh -c 'dir="$HOME/Pictures/Screenshots"; mkdir -p "$dir"; name="$(date +hyprshot-%Y%m%d-%H%M%S).png"; path="$dir/$name"; ln -sf -- "$path" "$dir/latest.png"; hyprshot -m window -z -o "$dir" -f "$name" && notify-send -a Hyprshot "Screenshot" "$path" || rm -f "$dir/latest.png"']]
local screenshotOutput = [[sh -c 'dir="$HOME/Pictures/Screenshots"; mkdir -p "$dir"; name="$(date +hyprshot-%Y%m%d-%H%M%S).png"; path="$dir/$name"; ln -sf -- "$path" "$dir/latest.png"; hyprshot -m output -z -o "$dir" -f "$name" && notify-send -a Hyprshot "Screenshot" "$path" || rm -f "$dir/latest.png"']]

hl.bind("Print", hl.dsp.exec_cmd(screenshotRegion))
hl.bind(altMod .. " + Print", hl.dsp.exec_cmd(screenshotWindow))
hl.bind(altMod .. " + SHIFT + Print", hl.dsp.exec_cmd(screenshotOutput))

hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("pidof hyprlock >/dev/null || hyprlock"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd(wmExit))
hl.bind(mainMod .. " + CONTROL + SHIFT + Q", hl.dsp.exit())

hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + Return", hl.dsp.layout("swapsplit"))
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/omarchy-hyprland-window-pop"))

local directions = {
    { key = "left", direction = "left" },
    { key = "right", direction = "right" },
    { key = "up", direction = "up" },
    { key = "down", direction = "down" },
    { key = "H", direction = "left" },
    { key = "L", direction = "right" },
    { key = "K", direction = "up" },
    { key = "J", direction = "down" },
}

for _, item in ipairs(directions) do
    hl.bind(mainMod .. " + " .. item.key, hl.dsp.focus({ direction = item.direction }))
end

hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.cycle_next())

for workspace = 1, 10 do
    local key = workspace % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace, follow = false }))
end

local swaps = {
    { key = "left", direction = "left" },
    { key = "right", direction = "right" },
    { key = "up", direction = "up" },
    { key = "down", direction = "down" },
}

for _, item in ipairs(swaps) do
    hl.bind(mainMod .. " + SHIFT + " .. item.key, hl.dsp.window.swap({ direction = item.direction }))
end

local resize = {
    { key = "LEFT", x = -50, y = 0 },
    { key = "RIGHT", x = 50, y = 0 },
    { key = "UP", x = 0, y = -50 },
    { key = "DOWN", x = 0, y = 50 },
}

for _, item in ipairs(resize) do
    hl.bind(mainMod .. " + CONTROL + " .. item.key, hl.dsp.window.resize({ x = item.x, y = item.y, relative = true }))
end

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + A", hl.dsp.workspace.toggle_special("linear"))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.window.move({ workspace = "special:linear" }))
hl.bind(mainMod .. " + D", hl.dsp.workspace.toggle_special("chatgpt"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.window.move({ workspace = "special:chatgpt" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

local repeating = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), repeating)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), repeating)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), repeating)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), repeating)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), repeating)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), repeating)

local locked = { locked = true }
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), locked)
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), locked)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), locked)
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), locked)
