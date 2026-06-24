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
        name: lang?.appearance?.icons || "Icons"
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
            name: lang?.appearance?.icon_theme || "Icon theme"
            size: "small"
          }

          ComboBox {
            Layout.fillWidth: true
            model: ["default", "Papirus", "Adwaita", "Numix", "Tela"]
            currentIndex: {
              var idx = model.indexOf(Settings.appearance.iconTheme);
              return idx >= 0 ? idx : 0;
            }
            onCurrentIndexChanged: {
              Settings.appearance.iconTheme = model[currentIndex];
            }

            background: Rectangle {
              color: theme.button.background
              border.color: theme.button.border
              border.width: 1
              radius: 4
            }
          }

          CustomText {
            name: lang?.appearance?.icon_preview || "Preview"
            size: "small"
            Layout.topMargin: ScalerService.s(10)
          }

          RowLayout {
            spacing: ScalerService.s(15)
            IconImage { path: "system/setting.png"; size: "large" }
            IconImage { path: "system/sys-exit.png"; size: "large" }
            IconImage { path: "system/sys-lock.png"; size: "large" }
            IconImage { path: "settings/network.png"; size: "large" }
          }
        }
      }

      Item {
        Layout.fillHeight: true
      }
    }
  }
}
