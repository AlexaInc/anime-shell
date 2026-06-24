import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services
import qs.services.cpu
import qs.services.ram
import qs.components
import qs.commons

Item {
  id: root

  RamService {
    id: ramService
    useSimpleCalculation: true
  }

  ScrollView {
    anchors.fill: parent
    anchors.margins: ScalerService.s(20)
    clip: true
    ScrollBar.vertical.policy: ScrollBar.AsNeeded

    ColumnLayout {
      width: parent.width
      spacing: ScalerService.s(20)

      HeaderSettings {
        name: lang?.settings?.performance || "Performance"
        Layout.fillWidth: true
      }

      Rectangle {
        Layout.fillWidth: true
        height: ScalerService.s(1)
        color: theme.primary.foreground
        opacity: 0.3
      }

      // Live stats
      Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: ScalerService.s(120)
        color: theme.primary.dim_background
        radius: ScalerService.s(12)
        border.color: theme.button.border
        border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0

        RowLayout {
          anchors.fill: parent
          anchors.margins: ScalerService.s(15)
          spacing: ScalerService.s(20)

          ColumnLayout {
            Layout.fillWidth: true
            spacing: ScalerService.s(4)

            CustomText {
              name: "CPU"
              size: "small"
              isBold: true
            }
            CustomText {
              name: CpuSimpleService.cpuPercent + "%"
              size: "large"
              isBold: true
              textColor: theme.button.text
            }
          }

          Rectangle {
            Layout.preferredWidth: ScalerService.s(1)
            Layout.fillHeight: true
            color: theme.button.border
          }

          ColumnLayout {
            Layout.fillWidth: true
            spacing: ScalerService.s(4)

            CustomText {
              name: "RAM"
              size: "small"
              isBold: true
            }
            CustomText {
              name: ramService.memPercent + "%"
              size: "large"
              isBold: true
              textColor: theme.button.text
            }
          }
        }
      }

      SettingRow {
        label: lang?.performance?.performance_mode || "Performance mode"
        value: Settings.general.performanceMode
        onToggled: {
          Settings.general.performanceMode = value;
          Settings.appearance.animations = !value;
          Settings.appearance.blurEffects = !value;
        }
      }

      SettingRow {
        label: lang?.performance?.reduce_animations || "Reduce animations"
        value: !Settings.appearance.animations
        onToggled: {
          Settings.appearance.animations = !value;
        }
      }

      SettingRow {
        label: lang?.performance?.update_interval || "Fast stats update (500ms)"
        value: Settings.general.statsUpdateInterval <= 1000
        onToggled: {
          Settings.general.statsUpdateInterval = value ? 500 : 1000;
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
