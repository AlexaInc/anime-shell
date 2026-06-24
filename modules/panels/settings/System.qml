import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import qs.services
import qs.services.cpu
import qs.services.ram
import qs.components
import qs.commons

Item {
  id: root

  property string hostname: "Unknown"
  property string osName: "Unknown"
  property string kernel: "Unknown"
  property string cpuModel: "Unknown"
  property string ramTotal: "Unknown"

  RamService {
    id: ramService
    useSimpleCalculation: true
  }

  Process {
    id: systemInfoProcess
    command: ["bash", "-c", "echo HOST=$(hostname); echo OS=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '\"'); echo KERNEL=$(uname -r); echo CPU=$(grep 'model name' /proc/cpuinfo | head -1 | cut -d: -f2 | sed 's/^ *//'); echo RAM=$(free -h | awk '/^Mem:/ {print $2}')"]
    stdout: StdioCollector {
      onStreamFinished: {
        var lines = this.text.trim().split('\n');
        for (var i = 0; i < lines.length; i++) {
          var line = lines[i];
          if (line.startsWith("HOST=")) root.hostname = line.substring(6) || "Unknown";
          else if (line.startsWith("OS=")) root.osName = line.substring(3) || "Unknown";
          else if (line.startsWith("KERNEL=")) root.kernel = line.substring(7) || "Unknown";
          else if (line.startsWith("CPU=")) root.cpuModel = line.substring(4) || "Unknown";
          else if (line.startsWith("RAM=")) root.ramTotal = line.substring(4) || "Unknown";
        }
      }
    }
    Component.onCompleted: running = true
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
        name: lang?.settings?.system || "System"
        Layout.fillWidth: true
      }

      Rectangle {
        Layout.fillWidth: true
        height: ScalerService.s(1)
        color: theme.primary.foreground
        opacity: 0.3
      }

      InfoRow { label: "Hostname"; value: root.hostname }
      InfoRow { label: "Operating System"; value: root.osName }
      InfoRow { label: "Kernel"; value: root.kernel }
      InfoRow { label: "CPU"; value: root.cpuModel }
      InfoRow { label: "Memory"; value: root.ramTotal }
      InfoRow { label: "Uptime"; value: UptimeService.uptimePretty }
      InfoRow { label: "Shell"; value: "anime-shell / QuickShell" }

      // Restart/Shutdown buttons
      RowLayout {
        Layout.fillWidth: true
        spacing: ScalerService.s(12)
        Layout.topMargin: ScalerService.s(10)

        ActionButton {
          Layout.fillWidth: true
          label: lang?.system?.restart || "Restart"
          action: "restart"
        }

        ActionButton {
          Layout.fillWidth: true
          label: lang?.system?.shutdown || "Shutdown"
          action: "shutdown"
        }
      }

      Item {
        Layout.fillHeight: true
      }
    }
  }

  component InfoRow: Rectangle {
    property string label: ""
    property string value: ""

    Layout.fillWidth: true
    Layout.preferredHeight: ScalerService.s(56)
    color: theme.button.background
    radius: ScalerService.s(10)
    border.color: theme.button.border
    border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0

    RowLayout {
      anchors.fill: parent
      anchors.margins: ScalerService.s(15)
      spacing: ScalerService.s(10)

      CustomText {
        name: label
        size: "small"
        isBold: true
        Layout.preferredWidth: ScalerService.s(140)
        elide: Text.ElideRight
        maximumLineCount: 1
      }

      CustomText {
        name: value
        size: "small"
        Layout.fillWidth: true
        elide: Text.ElideRight
        maximumLineCount: 2
      }
    }
  }

  component ActionButton: Rectangle {
    id: actionButton
    property string label: ""
    property string action: ""

    Layout.preferredHeight: ScalerService.s(48)
    color: actionMouseArea.containsMouse ? theme.button.background_select : theme.button.text
    radius: ScalerService.s(10)

    CustomText {
      anchors.centerIn: parent
      name: actionButton.label
      size: "small"
      textColor: theme.primary.background
      isBold: true
    }

    MouseArea {
      id: actionMouseArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: {
        if (actionButton.action === "restart") {
          CompositorService.reboot();
        } else if (actionButton.action === "shutdown") {
          CompositorService.shutdown();
        }
      }
    }
  }
}
