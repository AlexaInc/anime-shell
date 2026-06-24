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
        name: lang?.general?.date_time || "Date & Time"
        Layout.fillWidth: true
      }

      Rectangle {
        Layout.fillWidth: true
        height: ScalerService.s(1)
        color: theme.primary.foreground
        opacity: 0.3
      }

      // Current time preview
      Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: ScalerService.s(80)
        color: theme.primary.dim_background
        radius: ScalerService.s(12)
        border.color: theme.button.border
        border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0

        CustomText {
          anchors.centerIn: parent
          name: DateTimeService.currentTime
          size: "large"
          isBold: true
          textColor: theme.button.text
        }
      }

      SettingRow {
        label: lang?.general?.time_format || "24-hour format"
        value: Settings.clock.timeFormat === "24h"
        onToggled: {
          Settings.clock.timeFormat = value ? "24h" : "12h";
        }
      }

      SettingRow {
        label: lang?.general?.show_seconds || "Show seconds"
        value: Settings.clock.showSeconds
        onToggled: {
          Settings.clock.showSeconds = value;
        }
      }

      SettingRow {
        label: lang?.general?.clock_widget || "Enable clock widget"
        value: Settings.clock.enableWidget
        onToggled: {
          Settings.clock.enableWidget = value;
        }
      }

      SettingRow {
        label: lang?.general?.ntp_sync || "Network time sync"
        value: true
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
