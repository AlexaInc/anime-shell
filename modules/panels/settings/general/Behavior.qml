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
        name: lang?.general?.behavior || "Behavior"
        Layout.fillWidth: true
      }

      Rectangle {
        Layout.fillWidth: true
        height: ScalerService.s(1)
        color: theme.primary.foreground
        opacity: 0.3
      }

      SettingRow {
        label: lang?.general?.show_animations || "Show animations"
        value: Settings.general.showAnimations
        onToggled: {
          Settings.general.showAnimations = value;
          Settings.appearance.animations = value;
        }
      }

      SettingRow {
        label: lang?.general?.click_outside_close || "Click outside to close panels"
        value: Settings.general.clickOutsideToClose
        onToggled: {
          Settings.general.clickOutsideToClose = value;
        }
      }

      SettingRow {
        label: lang?.general?.hover_effects || "Enable hover effects"
        value: Settings.general.hoverEffects
        onToggled: {
          Settings.general.hoverEffects = value;
        }
      }

      SettingRow {
        label: lang?.general?.performance_mode || "Performance mode (reduce effects)"
        value: Settings.general.performanceMode
        onToggled: {
          Settings.general.performanceMode = value;
          Settings.appearance.animations = !value;
          Settings.appearance.blurEffects = !value;
        }
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
