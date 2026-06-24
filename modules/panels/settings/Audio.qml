import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import qs.services
import qs.components
import qs.commons

Item {
  id: root

  readonly property var defaultSink: Pipewire.defaultAudioSink
  readonly property real currentVolume: defaultSink?.audio.volume ?? 0
  readonly property bool isMuted: defaultSink?.audio.mute ?? false

  ScrollView {
    anchors.fill: parent
    anchors.margins: ScalerService.s(20)
    clip: true
    ScrollBar.vertical.policy: ScrollBar.AsNeeded

    ColumnLayout {
      width: parent.width
      spacing: ScalerService.s(20)

      HeaderSettings {
        name: lang?.settings?.audio || "Audio"
        Layout.fillWidth: true
      }

      Rectangle {
        Layout.fillWidth: true
        height: ScalerService.s(1)
        color: theme.primary.foreground
        opacity: 0.3
      }

      // Output device card
      Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: ScalerService.s(160)
        color: theme.primary.dim_background
        radius: ScalerService.s(12)
        border.color: theme.button.border
        border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0

        ColumnLayout {
          anchors.fill: parent
          anchors.margins: ScalerService.s(15)
          spacing: ScalerService.s(12)

          RowLayout {
            Layout.fillWidth: true
            spacing: ScalerService.s(10)

            IconImage {
              path: "volume/volume.png"
              size: "large"
            }

            CustomText {
              name: lang?.audio?.output_device || "Output device"
              size: "small"
              isBold: true
              Layout.fillWidth: true
              elide: Text.ElideRight
              maximumLineCount: 1
            }

            CustomText {
              name: defaultSink?.name || "Default"
              size: "xs"
              textColor: theme.primary.dim_foreground
              elide: Text.ElideRight
              maximumLineCount: 1
              Layout.maximumWidth: ScalerService.s(140)
            }
          }

          RowLayout {
            Layout.fillWidth: true
            spacing: ScalerService.s(10)

            CustomText {
              name: Math.round(currentVolume * 100) + "%"
              size: "small"
              Layout.preferredWidth: ScalerService.s(50)
            }

            Slider {
              id: volumeSlider
              Layout.fillWidth: true
              from: 0
              to: 1
              value: currentVolume
              onMoved: {
                if (defaultSink && defaultSink.audio) {
                  defaultSink.audio.volume = value;
                }
              }
              background: Rectangle {
                x: volumeSlider.leftPadding
                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: ScalerService.s(6)
                width: volumeSlider.availableWidth
                height: implicitHeight
                radius: ScalerService.s(3)
                color: theme.primary.dim_background

                Rectangle {
                  width: volumeSlider.visualPosition * parent.width
                  height: parent.height
                  color: theme.button.text
                  radius: ScalerService.s(3)
                }
              }
              handle: Rectangle {
                x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                implicitWidth: ScalerService.s(18)
                implicitHeight: ScalerService.s(18)
                radius: ScalerService.s(9)
                color: theme.button.text
              }
            }

            Rectangle {
              Layout.preferredWidth: ScalerService.s(40)
              Layout.preferredHeight: ScalerService.s(40)
              radius: ScalerService.s(20)
              color: muteMouseArea.containsMouse ? theme.button.background_select : theme.button.background
              border.color: theme.button.border
              border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0

              IconImage {
                path: root.isMuted ? "volume/mute.png" : "volume/volume.png"
                size: "normal"
                anchors.centerIn: parent
              }

              MouseArea {
                id: muteMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  if (defaultSink && defaultSink.audio) {
                    defaultSink.audio.mute = !defaultSink.audio.mute;
                  }
                }
              }
            }
          }
        }
      }

      SettingRow {
        label: lang?.audio?.mute_on_startup || "Mute on startup"
        value: false
        enabled: false
      }

      SettingRow {
        label: lang?.audio?.enable_mic || "Enable microphone"
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
