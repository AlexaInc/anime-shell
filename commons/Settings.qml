pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.commons

Singleton {
  id: root

  property bool ready: false

  readonly property alias appearance: adapter.appearance
  readonly property alias wallpaper: adapter.wallpaper
  readonly property alias general: adapter.general
  readonly property alias clock: adapter.clock
  readonly property alias weather: adapter.weather
  readonly property alias bar: adapter.bar
  readonly property alias dashboard: adapter.dashboard
  readonly property alias shortcuts: adapter.shortcuts

  signal settingsLoaded
  signal settingsSaved

  Component.onCompleted: {
    settingsFileView.adapter = adapter;
  }

  Timer {
    id: saveTimer
    running: false
    interval: 1000
    onTriggered: {
      root.saveImmediate();
    }
  }

  function saveImmediate() {
    settingsFileView.writeAdapter();
    root.ready = true;
    root.settingsSaved();
  }

  FileView {
    id: settingsFileView
    path: Directories.shellConfigSettingsPath
    printErrors: false
    watchChanges: true
    onFileChanged: reload()
    onAdapterUpdated: saveTimer.start()
    onPathChanged: {
      if (path !== undefined) {
        reload();
      }
    }
    onLoaded: function () {
      if (!root.ready) {
        root.ready = true;
        root.settingsLoaded();
      }
    }
    onLoadFailed: function (error) {
      if (error === FileViewError.FileNotFound) {
        writeAdapter();
      }
    }
  }

  JsonAdapter {
    id: adapter

    property Wallpaper wallpaper: Wallpaper {}
    property Appearance appearance: Appearance {}
    property General general: General {}
    property Clock clock: Clock {}
    property Weather weather: Weather {}
    property Bar bar: Bar {}
    property Dashboard dashboard: Dashboard {}
    property Shortcuts shortcuts: Shortcuts {}
  }

  component Shortcuts: JsonObject {
    property var bindings: [
    {"key": "SUPER + RETURN", "action": "Open Terminal"},
    {"key": "SUPER + Q", "action": "Close Window"},
    {"key": "SUPER + M", "action": "Exit Hyprland"},
    {"key": "SUPER + E", "action": "File Manager"},
    {"key": "SUPER + SPACE", "action": "Toggle Launcher"},
    {"key": "SUPER + D", "action": "Toggle Dashboard"},
    {"key": "ALT + TAB", "action": "Toggle Window Switcher"}
    ]
  }

  component Dashboard: JsonObject {
    property string fullname: "hansaka"
    property string urlAvatar: ""
    property string username: "hansaka"
    property int appGridColumns: 3
    property var desktopShortcuts: [
    {"name": "firefox", "exec": "firefox"},
    {"name": "kitty", "exec": "kitty"}
    ]
    property var appGrid: [
    {"name" : "firefox"},
    {"name" : "firefox"},
    {"name" : "firefox"},
    {"name" : "firefox"},
    {"name" : "firefox"},
    {"name" : "firefox"},
    {"name" : "firefox"},
    {"name" : "firefox"},
    {"name" : "firefox"}
    ]
  }

  component Bar: JsonObject {
    property string position: "top"
    property bool showLabels: true
    property var ram: {
      "style" : 1,
      "active": true
    }
    property var cpu: {
      "style" : 1,
      "active": true
    }
    property var disk: {
      "style" : 1,
      "active": true
    }
    property var bluetooth: {
      "style" : 1,
      "active": true
    }
    property var wifi: {
      "style" : 1,
      "active": true
    }
    property var volume: {
      "style" : 1,
      "active": true
    }
  }

  component Clock: JsonObject {
    property string timeFormat: "24h"
    property bool enableWidget: true
    property string positionWidget: "top"
    property bool showSeconds: false
  }

  component Weather: JsonObject {
    property string keyApi: "21e0f911c7de4308916165005251210"
    property string location: "Ho Chi Minh City,Vietnam"
  }

  component Appearance: JsonObject {
    property string theme: "matugen"
    property string mode: "dark"
    property string countryFlag: "vietnam"
    property string fonts: ""
    property int radius1: 22
    property int radius2: 16
    property int radius3: 8
    property bool enableBorder: false
    // Additional properties for dynamic theme
    property bool dynamic: false
    property string light: "light"
    property string dark: "dark"
    property string matugenType: "scheme-tonal-spot"
    property string font: "Noto Sans"

    // Icons / Effects / Layout
    property string iconTheme: "default"
    property bool panelTransparency: true
    property bool animations: true
    property bool blurEffects: true
    property bool floatingEffects: false
  }

  component General: JsonObject {
    property string lang: "en"
    property real screenHeight: 1080
    property real screenWidth: 1920
    property real scale: 1.0

    // Behavior
    property bool showAnimations: true
    property bool clickOutsideToClose: true
    property bool hoverEffects: true

    // Session / Privacy
    property bool autoLock: true
    property bool lockOnIdle: false
    property int lockTimeout: 300
    property bool blurPanels: true

    // Notifications
    property bool notificationsEnabled: true
    property bool doNotDisturb: false
    property int notificationTimeout: 5000

    // Performance
    property bool performanceMode: false
    property int statsUpdateInterval: 1000
  }

  component Wallpaper: JsonObject {
    property bool enabled: true
    property bool overviewEnabled: true
    property string directory: Directories.defaultWallpaperDir
    property bool enableMultiMonitorDirectories: false
    property bool recursiveSearch: false
    property bool setWallpaperOnAllMonitors: true
    property string defaultWallpaper: ""
    property string fillMode: "crop"
    property color fillColor: "#000000"
    property int shaders: 0
    property list<var> monitors: []
    property int transitionDuration: 500
    property real transitionEdgeSmoothness: 0.05
    // Video-specific properties
    property bool videoMuted: true
    property bool videoLoop: true
    property real videoPlaybackRate: 1.0
  }
}
