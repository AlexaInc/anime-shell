// components/Settings/ShortcutsSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services
import qs.components
import qs.commons

Item {
  id: root
  property bool editMode: false

  ScrollView {
    anchors.fill: parent
    anchors.margins: ScalerService.s(20)
    clip: true
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical.policy: ScrollBar.AsNeeded

    ColumnLayout {
      width: parent.parent.width - ScalerService.s(40)
      spacing: ScalerService.s(20)

      // Header
      RowLayout {
        Layout.fillWidth: true
        spacing: ScalerService.s(12)

        HeaderSettings {
          name: lang?.settings?.shortcuts || "⌨️ Hyprland Shortcuts"
          Layout.fillWidth: true
        }

        Rectangle {
          Layout.preferredWidth: ScalerService.s(120)
          Layout.preferredHeight: ScalerService.s(36)
          color: editMouseArea.containsMouse ? theme.button.background_select : theme.button.text
          radius: ScalerService.s(10)
          border.color: theme.button.border
          border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0

          CustomText {
            anchors.centerIn: parent
            name: root.editMode ? (lang?.shortcuts?.done || "Done") : (lang?.shortcuts?.edit || "Edit")
            size: "xs"
            textColor: theme.primary.background
            isBold: true
          }

          MouseArea {
            id: editMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.editMode = !root.editMode
          }
        }
      }

      Rectangle {
        Layout.fillWidth: true
        height: ScalerService.s(1)
        color: theme.primary.foreground
      }

      // Default Hyprland shortcuts (kept exactly as the original feature)
      ShortcutCategory {
        title: "🪟 Basic Window Management"
        shortcuts: [
          { key: "SUPER + RETURN", action: "Open Terminal" },
          { key: "SUPER + Q", action: "Close Window" },
          { key: "SUPER + M", action: "Exit Hyprland" },
          { key: "SUPER + E", action: "File Manager" },
          { key: "SUPER + SPACE", action: "Toggle Launcher Panel" },
          { key: "SUPER + V", action: "Toggle Floating" },
          { key: "SUPER + F", action: "Fullscreen" },
          { key: "SUPER + P", action: "Pseudo Tiling" }
        ]
      }

      ShortcutCategory {
        title: "🎨 Workspace Management"
        shortcuts: [
          { key: "SUPER + 1-9", action: "Switch to Workspace 1-9" },
          { key: "SUPER + SHIFT + 1-9", action: "Move Window to Workspace 1-9" },
          { key: "SUPER + S", action: "Toggle Special Workspace (magic)" },
          { key: "SUPER + SHIFT + S", action: "Move Window to Special Workspace" }
        ]
      }

      ShortcutCategory {
        title: "🖱️ Mouse Actions"
        shortcuts: [
          { key: "SUPER + Scroll Down", action: "Next Workspace" },
          { key: "SUPER + Scroll Up", action: "Previous Workspace" },
          { key: "SUPER + Left Click + Drag", action: "Move Window" },
          { key: "SUPER + Right Click + Drag", action: "Resize Window" }
        ]
      }

      ShortcutCategory {
        title: "📊 Dashboard & Panels"
        shortcuts: [
          { key: "SUPER + D", action: "Toggle Dashboard" },
          { key: "SUPER + L", action: "Lock Screen" },
          { key: "SUPER + A", action: "Toggle Calendar" },
          { key: "SUPER + B", action: "Toggle Bluetooth Panel" },
          { key: "SUPER + C", action: "Toggle CPU Monitor" },
          { key: "SUPER + R", action: "Toggle RAM Monitor" },
          { key: "SUPER + W", action: "Toggle Weather" },
          { key: "SUPER + I", action: "Toggle WiFi Panel" },
          { key: "SUPER + U", action: "Toggle Volume Mixer" },
          { key: "SUPER + Y", action: "Toggle Battery Info" }
        ]
      }

      // Editable custom shortcuts section
      Rectangle {
        Layout.fillWidth: true
        height: ScalerService.s(1)
        color: theme.primary.foreground
        opacity: 0.3
      }

      CustomText {
        name: lang?.shortcuts?.custom || "Custom Shortcuts"
        size: "normal"
        isBold: true
      }

      CustomText {
        name: lang?.shortcuts?.hint || "Click Edit to add or change your own shortcuts. These are saved to settings."
        size: "xs"
        textColor: theme.primary.dim_foreground
        Layout.fillWidth: true
      }

      Repeater {
        model: root.editMode ? Settings.shortcuts.bindings.length : 0

        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: ScalerService.s(64)
          color: theme.button.background
          radius: ScalerService.s(10)
          border.color: theme.button.border
          border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0

          RowLayout {
            anchors.fill: parent
            anchors.margins: ScalerService.s(12)
            spacing: ScalerService.s(10)

            TextField {
              id: keyField
              Layout.preferredWidth: ScalerService.s(180)
              Layout.fillHeight: true
              text: Settings.shortcuts.bindings[index].key
              color: theme.primary.foreground
              font.pixelSize: ScalerService.s(13)
              font.bold: true
              background: Rectangle {
                color: theme.normal.blue
                radius: ScalerService.s(8)
              }
              onEditingFinished: root.updateBinding(index, "key", text)
            }

            TextField {
              id: actionField
              Layout.fillWidth: true
              Layout.fillHeight: true
              text: Settings.shortcuts.bindings[index].action
              color: theme.primary.foreground
              font.pixelSize: ScalerService.s(14)
              background: Rectangle {
                color: theme.primary.dim_background
                radius: ScalerService.s(8)
              }
              onEditingFinished: root.updateBinding(index, "action", text)
            }

            Rectangle {
              Layout.preferredWidth: ScalerService.s(40)
              Layout.fillHeight: true
              color: removeMouseArea.containsMouse ? theme.normal.red : theme.primary.dim_background
              radius: ScalerService.s(8)

              CustomText {
                anchors.centerIn: parent
                name: "✕"
                size: "small"
                textColor: removeMouseArea.containsMouse ? "white" : theme.primary.foreground
              }

              MouseArea {
                id: removeMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.removeBinding(index)
              }
            }
          }
        }
      }

      RowLayout {
        Layout.fillWidth: true
        spacing: ScalerService.s(12)
        visible: root.editMode

        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: ScalerService.s(44)
          color: addMouseArea.containsMouse ? theme.button.background_select : theme.button.text
          radius: ScalerService.s(10)

          CustomText {
            anchors.centerIn: parent
            name: lang?.shortcuts?.add || "Add shortcut"
            size: "small"
            textColor: theme.primary.background
            isBold: true
          }

          MouseArea {
            id: addMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.addBinding()
          }
        }

        Rectangle {
          Layout.preferredWidth: ScalerService.s(120)
          Layout.preferredHeight: ScalerService.s(44)
          color: resetMouseArea.containsMouse ? theme.button.background_select : theme.button.background
          radius: ScalerService.s(10)
          border.color: theme.button.border
          border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0

          CustomText {
            anchors.centerIn: parent
            name: lang?.shortcuts?.reset || "Reset"
            size: "small"
          }

          MouseArea {
            id: resetMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.resetBindings()
          }
        }
      }

      Item {
        Layout.fillHeight: true
      }
    }
  }

  function updateBinding(index, field, value) {
    var list = JSON.parse(JSON.stringify(Settings.shortcuts.bindings));
    if (index >= 0 && index < list.length) {
      list[index][field] = value;
      Settings.shortcuts.bindings = list;
    }
  }

  function removeBinding(index) {
    var list = JSON.parse(JSON.stringify(Settings.shortcuts.bindings));
    if (index >= 0 && index < list.length) {
      list.splice(index, 1);
      Settings.shortcuts.bindings = list;
    }
  }

  function addBinding() {
    var list = JSON.parse(JSON.stringify(Settings.shortcuts.bindings));
    list.push({ "key": "SUPER + ?", "action": "New action" });
    Settings.shortcuts.bindings = list;
  }

  function resetBindings() {
    Settings.shortcuts.bindings = [
      { "key": "SUPER + RETURN", "action": "Open Terminal" },
      { "key": "SUPER + Q", "action": "Close Window" },
      { "key": "SUPER + M", "action": "Exit Hyprland" },
      { "key": "SUPER + E", "action": "File Manager" },
      { "key": "SUPER + SPACE", "action": "Toggle Launcher Panel" },
      { "key": "SUPER + D", "action": "Toggle Dashboard" },
      { "key": "ALT + TAB", "action": "Toggle Window Switcher" }
    ];
  }

  // Shortcut Category Component (kept from original)
  component ShortcutCategory: ColumnLayout {
    property string title: ""
    property var shortcuts: []

    Layout.fillWidth: true
    spacing: ScalerService.s(10)

    Rectangle {
      Layout.fillWidth: true
      height: ScalerService.s(50)
      color: theme.primary.dim_background
      radius: ScalerService.s(12)
      border.width: ScalerService.s(2)
      border.color: theme.normal.black

      CustomText {
        anchors.centerIn: parent
        name: title
        size: "small"
        isBold: true
      }
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: ScalerService.s(8)

      Repeater {
        model: shortcuts

        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: ScalerService.s(60)
          color: theme.button.background
          radius: ScalerService.s(10)
          border.width: ScalerService.s(1)
          border.color: theme.button.border

          RowLayout {
            anchors.fill: parent
            anchors.margins: ScalerService.s(15)
            spacing: ScalerService.s(20)

            Rectangle {
              Layout.preferredWidth: ScalerService.s(220)
              Layout.minimumWidth: ScalerService.s(220)
              Layout.maximumWidth: ScalerService.s(280)
              Layout.preferredHeight: ScalerService.s(35)
              color: theme.normal.blue
              radius: ScalerService.s(8)

              CustomText {
                anchors.centerIn: parent
                name: modelData.key
                size: "xs"
                textColor: theme.primary.background
                isBold: true
              }
            }

            CustomText {
              name: modelData.action
              size: "small"
              Layout.fillWidth: true
              Layout.alignment: Qt.AlignVCenter
              elide: Text.ElideRight
              maximumLineCount: 2
            }
          }
        }
      }
    }
  }
}
