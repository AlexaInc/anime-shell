# Anime Shell – Fix & Feature Summary (revised)

All requested changes have been applied to the cloned `anime-shell` repository. The second pass below fixes the reported black-screen and the "removed shortcuts" / truncated-text issues.

## What was fixed in the second pass

1. **Black screen after logout/login** – The new `WindowSwitcherService` singleton was creating a dependency loop with `CompositorService`. It has been removed and its state moved into `LoaderService`, which breaks the loop and avoids a startup hang.
2. **Original shortcuts were removed** – The default Hyprland shortcut categories have been restored exactly as before. An **Edit** button was added to toggle an editable **Custom Shortcuts** section at the bottom. The original categories remain visible.
3. **Text not showing completely** – The global `wrapMode`/`elide` change on `CustomText` was too aggressive. It has been reverted. Instead, the few places that actually overflow (`FlagItem`, `FileItem`) now use `wrapMode` + `maximumLineCount` so text wraps instead of being cut off.
4. **Settings property type** – `Settings.shortcuts.bindings` is now `property var` instead of `property list<var>`, which is safer for the JSON adapter.

## 1. Bug Fixes (original request)

| Bug | Fix | Key files |
|-----|-----|-----------|
| **Logout "Yes" does nothing** | `ConfirmDialog` is forced above all surfaces (`aboveWindows: true`, `z: 1000`). Dashboard quick-action buttons are also wired to the confirmation dialog. | `modules/dialogs/ConfirmDialog.qml`, `modules/panels/dashboard/ListQuickActionButton.qml`, `modules/panels/dashboard/DashboardPanel.qml`, `services/LoaderService.qml` |
| **Minimize button** | New **Window Switcher** with per-window **Min / Restore / Close** buttons. Minimize uses `hyprctl dispatch movetoworkspacesilent special:minimized`. | `services/CompositorService.qml`, `services/HyprlandService.qml`, `services/NiriService.qml`, `services/LoaderService.qml`, `modules/panels/window/WindowSwitcherPanel.qml` |
| **Alt+Tab** | `Alt+Tab`, `Alt+Shift+Tab` and `Meta+Tab` are bound in `shell.qml` to the Window Switcher. An IPC target (`windowSwitcher`) is also available for a Hyprland bind fallback. | `shell.qml`, `services/LoaderService.qml` |
| **Text overflow** | `CustomText` no longer forces global elide. `FileItem` and `FlagItem` use wrapping; `UserProfileCard` uses elide only for very long names. | `components/CustomText.qml`, `modules/panels/dashboard/FileItem.qml`, `modules/panels/flag/FlagItem.qml`, `modules/panels/dashboard/UserProfileCard.qml` |

## 2. Missing Settings Implementation

All settings tabs now have real content and persistence via `commons/Settings.qml`:

- **General** – `DateTime`, `Session`, `Behavior`, `Notifications`, `Privacy`
- **Appearance** – `Icons`, `Effects`, `Layout` (plus existing Theme, Panel, Clock, Fonts, Wallpaper)
- **Network** – WiFi toggle, status, network list, password box
- **Audio** – output volume slider, mute, device info
- **Performance** – live CPU/RAM preview, performance mode, animation/blur toggles
- **Shortcuts** – original default Hyprland categories restored, plus an editable **Custom Shortcuts** section
- **System** – hostname, OS, kernel, CPU, RAM, uptime, restart/shutdown buttons

## 3. Localization & Branding

- Default font changed from `ComicShannsMono Nerd Font` to `Noto Sans` everywhere.
- Default language changed from `vi` to `en`.
- User-facing Vietnamese/Indonesian fallback strings translated to English.
- Rebranded: `mailong2401` → `hansaka`, `AlexaInc` → `hansaka`, `long` → `hansaka` in README, defaults, and paths.

## 4. Assets & Feature Additions

- **Sri Lanka flag** – custom anime/cartoon style PNG + SVG added and integrated into the flag panel and language selector.
- **Desktop Shortcuts** – dashboard card that lists `~/Desktop/*.desktop` files, lets you launch/remove them, and add new ones from `/usr/share/applications`.

## How to use the fixed code

The repository in `~/anime-shell` already contains all changes. Run it directly:

```bash
cd ~/anime-shell
quickshell --path ~/anime-shell
```

If you still get a black screen, the old `settings.json` may have been written in a partially-broken state by the first patch. Reset it and relaunch:

```bash
rm ~/.config/cartoon-shell/settings.json
quickshell --path ~/anime-shell
```

(`~/.config/cartoon-shell` is the pre-existing config directory used by the shell.)

### Apply to a fresh clone

```bash
cd /path/to/fresh/anime-shell
patch -p1 < /path/to/this/anime-shell/changes.patch
```

### Optional Hyprland Alt+Tab fallback

If the QuickShell global shortcut does not capture `Alt+Tab`, add to `~/.config/hypr/hyprland.conf`:

```conf
bind = ALT, TAB, exec, qs ipc --path ~/.config/quickshell/anime-shell call windowSwitcher toggle
```

(Adjust the path to wherever you place the panel config.)

## Key files to review

- `commons/Settings.qml` – new settings schema
- `modules/dialogs/ConfirmDialog.qml` – logout dialog fix
- `services/LoaderService.qml` – now contains the Window Switcher controller
- `modules/panels/window/WindowSwitcherPanel.qml` – Alt+Tab + minimize UI
- `modules/panels/settings/Shortcuts.qml` – original shortcuts restored + custom edit section
- `modules/panels/dashboard/DesktopShortcutsCard.qml` – desktop shortcut manager
- `assets/flags/sri_lanka.png` (and `.svg`) – new flag asset
- `changes.patch` – full diff of all modifications
