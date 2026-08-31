local function rule(match, effects)
    effects.match = match
    hl.window_rule(effects)
end

rule({ class = ".*" }, {
    suppress_event = "maximize",
})

rule({ tag = "float oning-window" }, {
    float = true,
})

rule({ tag = "float oning-window" }, {
    center = true,
})

rule({ tag = "float oning-window" }, {
    size = "875 600",
})

rule({ class = "(xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus)", title = "^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files|.*wants to [open|save].*|[C|c]hoose.*)" }, {
    tag = "+float oning-window",
})

rule({ class = "^(Bitwarden)$" }, {
    no_screen_share = true,
    float = true,
    center = true,
    size = "1400 900",
})

rule({ class = "^(blueman-manager)$" }, {
    float = true,
})

rule({ class = "brave-chatgpt.com.*" }, {
    workspace = "special:chatgpt",
})

rule({ class = "brave-docs.internal.dwellir.com.*" }, {
    size = "1200 1000",
    float = true,
})

rule({ class = "(org.gnome.Calculator)" }, {
    float = true,
    size = "500 600",
    center = true,
})

rule({ class = "(org.keepassxc.KeePassXC)" }, {
    float = true,
    size = "1000 800",
    center = true,
})

rule({ class = "xdg-desktop-portal-gtk", title = "Open database" }, {
    float = true,
})

rule({ class = "brave-linear.app.*" }, {
    workspace = "special:linear",
})

rule({ class = "Share|localsend" }, {
    float = true,
    center = true,
})

rule({ class = "firefox", title = "Library" }, {
    float = true,
})

rule({ class = "firefox", title = ".*Bitwarden Password Manager.*" }, {
    float = true,
})

rule({ class = "nm-connection-editor" }, {
    float = true,
    size = "700 500",
    center = true,
    pin = true,
})

rule({ class = "nwg-displays" }, {
    float = true,
    size = "700 500",
    move = "10% 20%",
    pin = true,
})

rule({ class = "nwg-look" }, {
    float = true,
    size = "700 600",
    move = "10% 20%",
    pin = true,
})

rule({ class = ".*org.pulseaudio.pavucontrol.*" }, {
    float = true,
    size = "700 600",
    center = true,
    pin = true,
})

rule({ xwayland = true, initial_class = ".*steam.*" }, {
    float = true,
    center = true,
})

rule({ class = "thunderbird-esr" }, {
    tile = true,
})

local thunderbirdTitles = { ".*Create.*", ".*Edit.*", ".*New.*", ".*Send.*", ".*Write.*" }
for _, title in ipairs(thunderbirdTitles) do
    rule({ class = "thunderbird-esr", initial_title = title }, {
        float = true,
    })
end

rule({ class = "xdg-desktop-portal-gtk", title = "Add.*" }, {
    float = true,
    size = "1200 1000",
})

rule({ class = "xdg-desktop-portal-gtk", title = "Open.*" }, {
    float = true,
    size = "1200 1000",
})
