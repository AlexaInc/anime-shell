import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.commons
import qs.components

PanelWindow {
  id: root

  property var controller: null

  implicitWidth: ScalerService.s(520)
  implicitHeight: ScalerService.s(360)

  anchors {
    top: true
    left: true
  }
  margins {
    top: screen ? Math.round((screen.height - implicitHeight) / 2) : 0
    left: screen ? Math.round((screen.width - implicitWidth) / 2) : 0
  }

  exclusiveZone: 0
  aboveWindows: true
  visible: controller ? controller.visible : false
  color: "transparent"

  onVisibleChanged: {
    if (!visible && controller) {
      listView.positionViewAtIndex(controller.selectedIndex, ListView.Center);
    }
  }

  Rectangle {
    anchors.fill: parent
    radius: ScalerService.s(20)
    color: theme.primary.background
    border.color: theme.button.border
    border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: ScalerService.s(20)
      spacing: ScalerService.s(15)

      CustomText {
        name: lang?.window_switcher?.title || "Window Switcher"
        size: "large"
        isBold: true
        Layout.alignment: Qt.AlignHCenter
      }

      CustomText {
        name: lang?.window_switcher?.hint || "Alt+Tab: cycle, Enter: focus, Esc: close"
        size: "xs"
        textColor: theme.primary.dim_foreground
        Layout.alignment: Qt.AlignHCenter
      }

      Rectangle {
        Layout.fillWidth: true
        height: ScalerService.s(1)
        color: theme.primary.foreground
        opacity: 0.3
      }

      ListView {
        id: listView
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        spacing: ScalerService.s(8)
        model: controller ? controller.windows : null
        currentIndex: controller ? controller.selectedIndex : -1

        delegate: Rectangle {
          width: ListView.view.width
          height: ScalerService.s(64)
          color: model.isFocused || (controller ? controller.selectedIndex === index : false)
                 ? Qt.alpha(theme.button.text, 0.3)
                 : (hovered ? Qt.alpha(theme.button.background_select, 0.6) : theme.button.background)
          radius: ScalerService.s(12)
          border.color: theme.button.border
          border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0

          property bool hovered: false

          RowLayout {
            anchors.fill: parent
            anchors.margins: ScalerService.s(12)
            spacing: ScalerService.s(12)

            Rectangle {
              Layout.preferredWidth: ScalerService.s(44)
              Layout.preferredHeight: ScalerService.s(44)
              radius: ScalerService.s(10)
              color: theme.primary.dim_background

              IconImage {
                anchors.centerIn: parent
                path: "workspace/pacman.png"
                size: "normal"
              }
            }

            ColumnLayout {
              Layout.fillWidth: true
              spacing: ScalerService.s(2)

              CustomText {
                name: model.title || model.appId || "Window"
                size: "small"
                isBold: true
                Layout.fillWidth: true
                elide: Text.ElideRight
                maximumLineCount: 1
              }

              CustomText {
                name: model.appId || ""
                size: "xs"
                textColor: theme.primary.dim_foreground
                Layout.fillWidth: true
                elide: Text.ElideRight
                maximumLineCount: 1
              }
            }

            Rectangle {
              Layout.preferredWidth: ScalerService.s(60)
              Layout.preferredHeight: ScalerService.s(32)
              color: minMouseArea.containsMouse ? theme.button.background_select : theme.button.text
              radius: ScalerService.s(8)

              CustomText {
                anchors.centerIn: parent
                name: lang?.window_switcher?.minimize || "Min"
                size: "xs"
                textColor: theme.primary.background
                isBold: true
              }

              MouseArea {
                id: minMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  controller.selectedIndex = index;
                  controller.minimizeSelected();
                }
              }
            }

            Rectangle {
              Layout.preferredWidth: ScalerService.s(60)
              Layout.preferredHeight: ScalerService.s(32)
              color: restoreMouseArea.containsMouse ? theme.button.background_select : theme.button.text
              radius: ScalerService.s(8)

              CustomText {
                anchors.centerIn: parent
                name: lang?.window_switcher?.restore || "Restore"
                size: "xs"
                textColor: theme.primary.background
                isBold: true
              }

              MouseArea {
                id: restoreMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  controller.selectedIndex = index;
                  controller.restoreSelected();
                }
              }
            }

            Rectangle {
              Layout.preferredWidth: ScalerService.s(60)
              Layout.preferredHeight: ScalerService.s(32)
              color: closeMouseArea.containsMouse ? theme.normal.red : theme.button.text
              radius: ScalerService.s(8)

              CustomText {
                anchors.centerIn: parent
                name: lang?.window_switcher?.close || "Close"
                size: "xs"
                textColor: theme.primary.background
                isBold: true
              }

              MouseArea {
                id: closeMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  controller.selectedIndex = index;
                  controller.closeSelected();
                }
              }
            }
          }

          MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hovered = true
            onExited: parent.hovered = false
            onClicked: {
              controller.selectedIndex = index;
              controller.activate();
            }
          }
        }
      }

      RowLayout {
        Layout.fillWidth: true
        spacing: ScalerService.s(10)

        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: ScalerService.s(40)
          color: focusMouseArea.containsMouse ? theme.button.background_select : theme.button.text
          radius: ScalerService.s(10)

          CustomText {
            anchors.centerIn: parent
            name: lang?.window_switcher?.focus || "Focus"
            size: "small"
            textColor: theme.primary.background
            isBold: true
          }

          MouseArea {
            id: focusMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: controller.activate()
          }
        }

        Rectangle {
          Layout.preferredWidth: ScalerService.s(100)
          Layout.preferredHeight: ScalerService.s(40)
          color: cancelMouseArea.containsMouse ? theme.normal.red : theme.button.background
          radius: ScalerService.s(10)
          border.color: theme.button.border
          border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0

          CustomText {
            anchors.centerIn: parent
            name: lang?.window_switcher?.cancel || "Cancel"
            size: "small"
          }

          MouseArea {
            id: cancelMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: controller.hide()
          }
        }
      }
    }
  }

  Shortcut {
    sequence: "Return"
    onActivated: if (controller) controller.activate()
  }

  Shortcut {
    sequence: "Escape"
    onActivated: if (controller) controller.hide()
  }
}
