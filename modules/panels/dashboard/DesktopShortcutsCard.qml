import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io
import qs.services
import qs.components
import qs.commons

Item {
  id: root

  Layout.preferredWidth: ScalerService.s(240)
  Layout.fillHeight: true

  property real animationProgress: 0
  property bool addDialogActive: false

  Process {
    id: launchProcess
  }

  Process {
    id: copyProcess
  }

  Process {
    id: removeProcess
  }

  FolderListModel {
    id: desktopModel
    folder: "file://" + Directories.home + "/Desktop"
    nameFilters: ["*.desktop"]
    showDirs: false
    showFiles: true
    showHidden: false
  }

  Rectangle {
    anchors.centerIn: parent
    implicitWidth: root.animationProgress > 0.65 ? parent.width : 0
    implicitHeight: root.animationProgress > 0.65 ? parent.height : 0
    Behavior on implicitHeight {
      NumberAnimation {
        duration: 500
        easing.type: Easing.OutCubic
      }
    }
    Behavior on implicitWidth {
      NumberAnimation {
        duration: 500
        easing.type: Easing.OutCubic
      }
    }
    radius: ScalerService.s(Settings.appearance.radius1)
    border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0
    color: theme.primary.background
    border.color: theme.button.border

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: ScalerService.s(15)
      spacing: ScalerService.s(8)

      RowLayout {
        Layout.fillWidth: true
        spacing: ScalerService.s(8)

        CustomText {
          name: lang?.desktop_shortcuts?.title || "Desktop Shortcuts"
          size: "small"
          isBold: true
          Layout.fillWidth: true
          elide: Text.ElideRight
          maximumLineCount: 1
        }

        Rectangle {
          Layout.preferredWidth: ScalerService.s(28)
          Layout.preferredHeight: ScalerService.s(28)
          radius: ScalerService.s(14)
          color: addMouseArea.containsMouse ? theme.button.background_select : theme.button.text

          CustomText {
            anchors.centerIn: parent
            name: "+"
            size: "small"
            textColor: theme.primary.background
            isBold: true
          }

          MouseArea {
            id: addMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.addDialogActive = true
          }
        }
      }

      Rectangle {
        Layout.fillWidth: true
        height: ScalerService.s(1)
        color: theme.primary.foreground
        opacity: 0.3
      }

      ListView {
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        spacing: ScalerService.s(6)
        model: desktopModel

        delegate: Rectangle {
          width: ListView.view.width
          height: ScalerService.s(44)
          color: itemMouseArea.containsMouse ? Qt.alpha(theme.button.background_select, 0.6) : theme.button.background
          radius: ScalerService.s(10)
          border.color: theme.button.border
          border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0

          RowLayout {
            anchors.fill: parent
            anchors.margins: ScalerService.s(8)
            spacing: ScalerService.s(8)

            IconImage {
              path: "filebrowser/file.png"
              size: "small"
            }

            CustomText {
              name: fileName.replace(/\.desktop$/i, "")
              size: "xs"
              Layout.fillWidth: true
              elide: Text.ElideRight
              maximumLineCount: 1
            }

            Rectangle {
              Layout.preferredWidth: ScalerService.s(24)
              Layout.preferredHeight: ScalerService.s(24)
              radius: ScalerService.s(12)
              color: removeMouseArea.containsMouse ? theme.normal.red : theme.primary.dim_background

              CustomText {
                anchors.centerIn: parent
                name: "✕"
                size: "xs"
                textColor: removeMouseArea.containsMouse ? "white" : theme.primary.foreground
              }

              MouseArea {
                id: removeMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  removeProcess.command = ["rm", filePath];
                  removeProcess.startDetached();
                }
              }
            }
          }

          MouseArea {
            id: itemMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              launchProcess.command = ["xdg-open", filePath];
              launchProcess.startDetached();
            }
          }
        }
      }
    }

    Loader {
      source: "../../dialogs/FileDialog.qml"
      active: root.addDialogActive

      onLoaded: {
        item.currentPath = "file:///usr/share/applications/";
        item.visible = Qt.binding(function () {
            return root.addDialogActive;
        });
        item.fileOpened.connect(function (fileUrl) {
            root.addDialogActive = false;
            var source = fileUrl.toString().replace(/^file:\/\//, "");
            var dest = Directories.home + "/Desktop/" + source.split('/').pop();
            copyProcess.command = ["bash", "-c", "cp \"" + source + "\" \"" + dest + "\" && chmod +x \"" + dest + "\""];
            copyProcess.startDetached();
        });
      }
    }
  }
}
