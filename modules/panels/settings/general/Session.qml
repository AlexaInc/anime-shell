import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services
import qs.components
import qs.commons

Item {
  id: root

  ScrollView {
    anchors.fill: parent
    anchors.margins: ScalerService.s(20)
    clip: true
    ScrollBar.vertical.policy: ScrollBar.AsNeeded

    ColumnLayout {
      width: parent.width
      spacing: ScalerService.s(20)

      HeaderSettings {
        name: lang?.general?.session || "Session"
        Layout.fillWidth: true
      }

      Rectangle {
        Layout.fillWidth: true
        height: ScalerService.s(1)
        color: theme.primary.foreground
        opacity: 0.3
      }

      SettingRow {
        label: lang?.general?.lock_on_suspend || "Lock screen on suspend"
        value: Settings.general.autoLock
        onToggled: {
          Settings.general.autoLock = value;
        }
      }

      SettingRow {
        label: lang?.general?.lock_on_idle || "Lock screen when idle"
        value: Settings.general.lockOnIdle
        onToggled: {
          Settings.general.lockOnIdle = value;
        }
      }

      SettingRow {
        label: lang?.general?.auto_login || "Autostart shell on login"
        value: true
        enabled: false
      }

      SettingRow {
        label: lang?.general?.restore_session || "Restore previous session"
        value: false
        enabled: false
      }

      Item {
        Layout.fillHeight: true
      }
    }
  }

  component SettingRow: Rectangle {
    id: settingRow
    property string label: ""
    property bool value: false
    property bool enabled: true
    signal toggled(bool value)

    Layout.fillWidth: true
    Layout.preferredHeight: ScalerService.s(56)
    color: theme.button.background
    radius: ScalerService.s(10)
    border.color: theme.button.border
    border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0

    RowLayout {
      anchors.fill: parent
      anchors.margins: ScalerService.s(15)
      spacing: ScalerService.s(12)

      CustomText {
        name: settingRow.label
        size: "small"
        Layout.fillWidth: true
        elide: Text.ElideRight
        maximumLineCount: 1
      }

      CustomToggleSwitch {
        adapter: settingRow.value
        enabled: settingRow.enabled
        onClicked: {
          settingRow.value = !settingRow.value;
          settingRow.toggled(settingRow.value);
        }
      }
    }
  }
}
