import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import qs.services
import qs.components
import qs.commons

Item {
  id: root

  WifiService {
    id: wifiManager
  }

  NetworkService {
    id: networkService
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
        name: lang?.settings?.network || "Network"
        Layout.fillWidth: true
      }

      Rectangle {
        Layout.fillWidth: true
        height: ScalerService.s(1)
        color: theme.primary.foreground
        opacity: 0.3
      }

      // Status card
      Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: ScalerService.s(80)
        color: theme.primary.dim_background
        radius: ScalerService.s(12)
        border.color: theme.button.border
        border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0

        RowLayout {
          anchors.fill: parent
          anchors.margins: ScalerService.s(15)
          spacing: ScalerService.s(12)

          IconImage {
            path: networkService.connectedWifi !== "Disconnected" ? "wifi/wifi.png" : "wifi/no-wifi.png"
            size: "large"
          }

          ColumnLayout {
            Layout.fillWidth: true
            spacing: ScalerService.s(4)

            CustomText {
              name: networkService.connectedWifi !== "Disconnected" ? networkService.connectedWifi : (lang?.wifi?.disconnected || "Disconnected")
              size: "small"
              isBold: true
              Layout.fillWidth: true
              elide: Text.ElideRight
              maximumLineCount: 1
            }

            CustomText {
              name: networkService.signal_current > 0 ? (lang?.wifi?.signal || "Signal") + ": " + networkService.signal_current + "%" : ""
              size: "xs"
              textColor: theme.primary.dim_foreground
              visible: networkService.connectedWifi !== "Disconnected"
            }
          }

          CustomToggleSwitch {
            adapter: wifiManager.wifiEnabled
            onClicked: wifiManager.toggleWifi()
          }
        }
      }

      // WiFi list
      CustomText {
        name: lang?.wifi?.available_networks || "Available networks"
        size: "small"
        isBold: true
      }

      Repeater {
        model: wifiManager.wifiList

        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: ScalerService.s(56)
          color: theme.button.background
          radius: ScalerService.s(10)
          border.color: theme.button.border
          border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0

          RowLayout {
            anchors.fill: parent
            anchors.margins: ScalerService.s(12)
            spacing: ScalerService.s(10)

            IconImage {
              path: modelData.signal > 70 ? "wifi/wifi.png" : (modelData.signal > 40 ? "wifi/wifi_2.png" : "wifi/wifi_1.png")
              size: "normal"
            }

            CustomText {
              name: modelData.ssid
              size: "small"
              Layout.fillWidth: true
              elide: Text.ElideRight
              maximumLineCount: 1
            }

            CustomText {
              name: modelData.security === "Open" ? "Open" : "Secured"
              size: "xs"
              textColor: theme.primary.dim_foreground
            }

            Rectangle {
              Layout.preferredWidth: ScalerService.s(70)
              Layout.preferredHeight: ScalerService.s(32)
              radius: ScalerService.s(8)
              color: connectMouseArea.containsMouse ? theme.button.background_select : theme.button.text
              visible: modelData.ssid !== wifiManager.connectedWifi

              CustomText {
                anchors.centerIn: parent
                name: lang?.wifi?.connect || "Connect"
                size: "xs"
                textColor: theme.primary.background
                isBold: true
              }

              MouseArea {
                id: connectMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  if (modelData.security === "Open" || modelData.saved_password !== "--") {
                    wifiManager.connectToWifi(modelData.ssid, modelData.saved_password !== "--" ? modelData.saved_password : "");
                  } else {
                    wifiManager.openSsid = modelData.ssid;
                  }
                }
              }
            }
          }
        }
      }

      // Password box
      Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: ScalerService.s(60)
        color: theme.primary.background
        radius: ScalerService.s(10)
        border.color: theme.button.border
        border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0
        visible: wifiManager.openSsid !== ""

        RowLayout {
          anchors.fill: parent
          anchors.margins: ScalerService.s(12)
          spacing: ScalerService.s(10)

          TextField {
            id: passwordField
            Layout.fillWidth: true
            placeholderText: "Password for " + wifiManager.openSsid
            echoMode: TextInput.Password
            color: theme.primary.foreground
            background: Rectangle {
              color: theme.button.background
              radius: ScalerService.s(8)
            }
          }

          Button {
            text: "Connect"
            onClicked: {
              wifiManager.connectToWifi(wifiManager.openSsid, passwordField.text);
              wifiManager.openSsid = "";
              passwordField.text = "";
            }
          }
        }
      }

      Item {
        Layout.fillHeight: true
      }
    }
  }
}
