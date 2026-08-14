# Mango Quickshell — Continuation Brief

## Paste this into a future development session

I am continuing development of my custom Quickshell configuration for MangoWM.
Please inspect the repository before changing anything, preserve the existing
minimal visual language, and continue from the implementation state documented
below. Treat the checked-in files as the source of truth, keep settings live-
previewed with Save/Reset/Defaults semantics, update this document and the
README after material changes, and validate every dynamically loaded QML page.

The project lives at:

`/home/marcus/.local/dots/quickshell`

## Product direction

This shell is intended to replace DankMaterialShell with a smaller, cleaner,
MangoWM-focused environment. It may take inspiration from DMS and Noctalia, but
should remain self-contained where practical, modular, understandable, and easy
to personalize. Avoid adding large feature sets without a clear user-facing
reason.

## Current implementation

### Bar and MangoWM

- One bar is created per Quickshell screen.
- Mango IPC supplies tags, focused window information, active layouts, clients,
  and monitor state.
- Default placement is Tags, Layout, and Active window on the left; Clock and
  Media in the center; Tray, CPU usage, CPU temperature, GPU usage, GPU
  temperature, Network, Audio, Notifications, and Settings on the right.
- Components can be reordered, moved across sections, hidden, and restored.
- Layout icons use the vendored Material Symbols font in `Assets/fonts`; they do
  not depend on DMS assets.

### Widget interaction

- Layout, Clock, Network, Audio, and Notifications open anchored popup windows.
- Popup windows request focus and close after focus is lost or Escape is pressed.
- Right-click commands are stored per supported widget in `widgetCommands`.
- Commands are configured in Components → Widget settings and run through
  `sh -lc` so both applications and shell commands are supported.
- Tags preserve tag-toggle behavior when no custom right-click command exists.
- Tray right-click remains reserved for each tray application's own menu.
- Four independent hardware widgets read CPU usage/temperature and GPU
  usage/temperature through `PerformanceService`. The service samples
  `/proc/stat`, hwmon, NVIDIA SMI, and DRM sysfs fallbacks every two seconds.
  Unavailable sensors report `N/A` rather than zero.
- Tag appearance supports number/Roman/dot labels, independent active and
  inactive widths, height, spacing, radius, inactive opacity, indicator
  position, and active/occupied indicator dimensions.

### Settings navigation

The resizable settings window has a content-safe minimum size and a scrollable,
collapsible navigation tree. Clicking a group button toggles its children and
opens the first page in that group:

- Bar Settings
  - General
  - Colors
  - Layout
- Components
  - Widget layout
  - Widget settings
    - Active window title
    - Audio
    - Clock & date
    - CPU temperature
    - CPU usage
    - GPU temperature
    - GPU usage
    - Layout
    - Media
    - Network
    - Notifications
    - Settings
    - Tags
- System
  - Audio
  - Display

Settings are previewed immediately. Save writes `settings.json`, Reset restores
the last saved snapshot, and Defaults creates an unsaved default preview.
The settings shell now has a Noctalia-inspired two-pane presentation: a dark
rounded sidebar with live search, a distinct rounded content panel, compact
two-column fields, custom switches/sliders, and subtle accent scrollbars. These
styles live in the reusable controls under `Components/Settings/Controls`.

### Appearance

- Installed text fonts are selectable.
- Font size and weight are configurable for primary bar text.
- The font dropdown has a subtle scrollbar.
- Available palettes include Default, Catppuccin Mocha, Dracula, Gruvbox Dark,
  Tokyo Night, and Nord.
- Editing any individual palette color changes the palette state to Custom while
  preserving all other selected colors.
- Border width, opacity, bar position, gaps, padding, spacing, radius, and bar
  height are configurable.

### System services

- Audio uses PipeWire and supports default input/output selection, volume,
  hidden-device lists, and Pavucontrol.
- Network uses Quickshell networking plus system address/bandwidth data and
  supports Wi-Fi scanning and connection.
- Display settings discover Mango outputs and EDID modes. Each connected output
  can select resolution/refresh, scale, and rotation. Extended placement is
  supported left/right/above/below another output.
- Mirror mode is explicitly experimental. Mango has no documented clone
  primitive; the implementation overlaps logical output coordinates and matches
  the reference output mode.

### Notifications

- The shell implements `org.freedesktop.Notifications` through Quickshell.
- The notification menu switches between Latest and History rather than showing
  both simultaneously.
- Cards support application activation, archive/dismiss, history removal, and
  reminders of 5m, 10m, 15m, 30m, 1h, or 2h.
- The selected reminder delay is remembered in settings.
- Notification history is stored in Quickshell's per-shell state directory.
- `NotificationService` checks the DBus owner PID. If another daemon owns the
  notification service, the menu displays a conflict explanation. Stop Mako,
  Dunst, SwayNC, or DMS notifications and restart this shell before testing.

### System tray

- `shell.qml` must keep `//@ pragma UseQApplication` as its first line.
- This pragma is required for native `PlatformMenuEntry` tray menus.
- Right-click opens application menus; menu-only tray items may use left-click.

## Project structure

- `shell.qml` — root, QApplication pragma, per-screen variants.
- `Bar.qml` — panel geometry and left/center/right widget groups.
- `QuickSettings.qml` — resizable settings window and nested navigation.
- `Appearance.qml` — settings-backed appearance facade.
- `settings.json` — saved user configuration.
- `Components/Widgets/Bar` — bar widgets and dynamic widget loader.
- `Components/Menus` — anchored popup menus.
- `Components/Overlays` — notification toast overlay.
- `Components/Common` — reusable visual and popup helpers.
- `Components/Settings/Controls` — reusable settings fields and component cards.
- `Components/Settings/Pages` — primary settings destinations.
- `Components/Settings/Pages/Widgets` — one dedicated page per configurable
  widget, listed alphabetically in the sidebar.
- `Services` — Settings, Mango, Audio, Network, Media, Display, Notifications,
  and component drag/drop state.
- `Scripts/display-info.sh` — monitor and EDID mode discovery.

## Known constraints and areas to verify

1. Only one notification daemon may own the desktop notification DBus name.
2. Experimental display mirroring may differ by Mango/wlroots version and GPU.
3. Display changes use Mango's temporary monitor-rule dispatcher; persistent
   compositor configuration still belongs in Mango's monitor config.
4. Test popup focus-loss closing on the actual compositor, including opening an
   inner ComboBox/Popup so it does not close its parent unexpectedly.
5. Test tray menus after a full Quickshell restart; changing the QApplication
   pragma cannot affect an already-running process.
6. Verify right-click commands containing quotes, pipes, and environment
   variables. They intentionally execute through `sh -lc`.

## Validation checklist

After future changes:

1. Run `jq empty settings.json`.
2. Run `bash -n Scripts/display-info.sh`.
3. Launch the shell once for every dynamic settings destination using
   `QS_OPEN_SETTINGS=1 QS_SETTINGS_PAGE=<page> quickshell -p .`.
4. Check the Quickshell log for unavailable types, duplicate property bindings,
   and delayed callbacks referencing destroyed objects.
5. Restart Quickshell fully and test a real tray application's context menu.
6. Ensure no other notification daemon is running, send a test notification,
   then verify Latest, History, dismiss, activation, and every reminder delay.
7. Test popup closing by clicking outside and by pressing Escape.
8. Test Save, Reset, and Defaults after adding any persisted property.

## Suggested future work

- Persist display layouts into an explicit Mango monitor configuration only
  after choosing a safe, user-controlled target file and backup strategy.
- Add richer notification actions and optional inline replies.
- Add per-widget popup sizing and placement overrides if multi-monitor testing
  reveals edge cases.
- Add an optional command picker or desktop-entry picker above raw command input.
- Add automated QML smoke tests if suitable tooling becomes available.

When continuing, first read `README.md`, this file, `Services/Settings.qml`, and
the files directly related to the requested change. Preserve unrelated user
changes and update both documentation files before handing the work back.
