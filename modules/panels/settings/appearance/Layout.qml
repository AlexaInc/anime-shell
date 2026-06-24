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
        name: lang?.appearance?.layout || "Layout"
        Layout.fillWidth: true
      }

      Rectangle {
        Layout.fillWidth: true
        height: ScalerService.s(1)
        color: theme.primary.foreground
        opacity: 0.3
      }

      Rectangle {
        Layout.fillWidth: true
        color: "transparent"

        ColumnLayout {
          width: parent.width
          spacing: ScalerService.s(10)

          CustomText {
            name: lang?.appearance?.dashboard_columns || "Dashboard app grid columns"
            size: "small"
          }

          SpinBox {
            Layout.fillWidth: true
            from: 1
            to: 6
            value: Settings.dashboard.appGridColumns
            onValueModified: {
              Settings.dashboard.appGridColumns = value;
            }
            background: Rectangle {
              color: theme.button.background
              border.color: theme.button.border
              border.width: 1
              radius: 4
            }
          }

          SettingRow {
            Layout.topMargin: ScalerService.s(15)
            label: lang?.appearance?.bar_labels || "Show bar stats labels"
            value: Settings.bar.showLabels
            onToggled: {
              Settings.bar.showLabels = value;
            }
          }
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
