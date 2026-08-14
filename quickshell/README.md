# Mango Quickshell

A small, modular Quickshell bar built specifically for MangoWM.

## Current milestone

- One bar per monitor
- Live Mango tags, occupancy, urgency, layout, and focused window
- Application and system tray icons
- Network status, live bandwidth details, and Wi-Fi controls
- PipeWire input/output selection, volume controls, and Pavucontrol access
- Mako-style notification popups, notification center, history, and reminders
- PipeWire volume, quick device controls, and scroll-to-adjust
- Clock with a month calendar and optional week numbers
- Categorized quick settings for colors, geometry, edge placement, and widgets
- Installed-font selection and Mango display mode, scale, and rotation controls
- Palette presets with per-color customization and automatic Custom tracking
- Detailed tag styling for labels, geometry, spacing, opacity, and indicators


## TOOD
- Wallpaper engine
- Remove current right-click to all widgets. Should only appear on some widgets.
- Make rounded corners on the slider in the audio widget. Currently it is a rectangle.
  
## Try it

Launch the shell directly:

```sh
qs -p ~/.config/quickshell
```

If this repository is linked somewhere other than `~/.config/quickshell`, pass
its actual directory to `qs -p`.

Mango integration requires `MANGO_INSTANCE_SIGNATURE`, which Mango exports to
processes it starts. Once the bar is approved, replace `exec-once = dms run &`
with `exec-once = qs -p ~/.config/quickshell &` in Mango's configuration.

### Controls

- Left-click a tag to view it.
- Right-click a tag to toggle it in the current tag set.
- Click the audio widget to open input/output controls.
- Scroll over the volume indicator to adjust it.
- Click the cog to open the separate, resizable Settings window.
- Click the Mango layout symbol to choose any supported layout.
- Click the clock to open the calendar.
- Click the network icon for connection details and Wi-Fi controls.
- Left-click a CPU/GPU metric to refresh it immediately. Right-click can run its
  configured widget command.
- Click Audio for quick input/output controls. Widget appearance is linked from
  its row under Components; devices, visibility, and levels live under System → Audio.
- Clicking away from a widget popup, or pressing Escape, closes it.
- Widgets can run a custom application or shell command on right-click. Configure
  the action in Components → Widget settings. Tags retain their normal
  right-click behavior until a custom command is configured.
- Notification cards: left-click opens the sender, right-click archives and
  dismisses, and middle-click reminds you later using the remembered delay. The
  Remind later dropdown offers 5m, 10m, 15m, 30m, 1h, and 2h choices.

## Customization

Quick settings are saved to `settings.json`. Bar widgets live under
`Components/Widgets/Bar`, popup menus under `Components/Menus`, overlays under
`Components/Overlays`, shared pieces under `Components/Common`, and settings
controls/pages under `Components/Settings`. Components can be moved between the left, center, and
right sections, reordered within a section, or hidden entirely. The Components
page supports drag-and-drop, up/down ordering, and per-component eye buttons.
Configurable component rows also have a settings button that opens their exact
section under Widget settings.
Its sections are stacked vertically in Left, Center, Right, and Hidden order.
Each compact component row also has a direct Left/Center/Right selector, so
cross-section moves do not require drag-and-drop.

Tag settings include pill/outline/minimal styles, number/Roman/dot labels,
empty-tag visibility, active and inactive widths, height, spacing, radius,
inactive opacity, and configurable occupied/active indicators.

The default arrangement is Tags, Layout, and Active window on the left; Clock
and Media in the center; and Tray, CPU usage, CPU temperature, GPU usage, GPU
temperature, Network, Audio, Notifications, and Settings on the right.
Media is hidden automatically whenever no MPRIS player is actively playing.

Hardware metrics refresh every two seconds. CPU usage comes from `/proc/stat`;
CPU temperature prefers package sensors exposed by hwmon. GPU usage and
temperature use NVIDIA SMI when available, with AMD/Intel DRM sysfs fallbacks.
An unsupported or temporarily unavailable sensor displays `N/A`.

Right-click a system tray icon to open its application menu. Tray items that are
menu-only also open that menu with a normal left-click. The root configuration
uses Quickshell's `UseQApplication` pragma because native platform tray menus
require QApplication mode.

Settings preview immediately. **Save** writes the preview to `settings.json`,
**Reset changes** restores the last saved state, and **Defaults** loads the
default values as an unsaved preview. Numeric settings support both sliders and
manual entry.

The settings sidebar is a collapsible navigation tree. Clicking **Bar Settings**,
**Components**, or **System** toggles that group and opens its landing page.
**Widget settings** expands into alphabetized, dedicated pages for Active window
title, Audio, Clock & date, the four CPU/GPU metrics, Layout, Media, Network,
Notifications, Settings, and Tags. The Display page exposes every connected
Mango output and supports relative extended layouts in all four directions. Its
mirror option is marked experimental because Mango does not provide a dedicated
clone primitive.

The settings UI uses a compact two-pane design inspired by Noctalia: searchable
icon navigation, a separate rounded content surface, compact label/control rows,
switches, accent sliders, thin scrollbars, and persistent Save/Reset/Defaults
actions. Its colors and typography continue to follow the selected Mango Shell
palette and font rather than depending on an external shell theme.

## Bundled assets

The Mango layout icons use the vendored Material Symbols Rounded variable font
from Google's `material-design-icons` project. It is stored under `Assets/fonts`
with its Apache 2.0 license and does not depend on DankMaterialShell.

## Notification daemon

This shell now provides the desktop notification service. Stop or disable Mako,
Dunst, SwayNC, DMS notifications, or another notification daemon before launching
it: only one process can own `org.freedesktop.Notifications`. The notification
menu checks the DBus owner and displays a conflict message when this shell does
not own the service. Archived notifications are stored in Quickshell's per-shell
state path, not in `settings.json`.

## Continuing development

See [`CONTINUATION.md`](CONTINUATION.md) for the current implementation state,
architecture, known limitations, validation checklist, and a ready-to-paste
brief for continuing the project in a later session.
