import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.components
import "./appearance" as Com
import "./" as Bar

Item {
  id: root

  property int currentTab: 0
  property real animationProgress: 0
  SequentialAnimation on animationProgress {
    running: true

    NumberAnimation {
      from: 0
      to: 1
      duration: 500
      easing.type: Easing.Linear
    }
  }

  ColumnLayout {
    anchors.fill: parent
    spacing: ScalerService.s(10)
    Bar.TopNavigationBar{
      animationProgress: root.animationProgress
      indexCategoegory: 1
      onCurrentTab: function(index) {
        root.currentTab = index
      }
    }

    StackLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      currentIndex: root.currentTab

      Loader {
        active: root.currentTab === 0
        source: "./appearance/Theme.qml"
        onLoaded: {
          item.visible = Qt.binding(function () {
              return root.currentTab === 0;
          });
        }
      }
      Loader {
        active: root.currentTab === 1
        source: "./appearance/Panel.qml"
        onLoaded: {
          item.visible = Qt.binding(function () {
              return root.currentTab === 1;
          });
        }
      }

      Loader {
        active: root.currentTab === 2
        source: "./appearance/ClockTime.qml"
        onLoaded: {
          item.visible = Qt.binding(function () {
              return root.currentTab === 2;
          });
        }
      }

      Loader {
        active: root.currentTab === 3
        source: "./appearance/Fonts.qml"
        onLoaded: {
          item.visible = Qt.binding(function () {
              return root.currentTab === 3;
          });
        }
      }

      // Tab 4: Icons
      Loader {
        active: root.currentTab === 4
        source: "./appearance/Icons.qml"
        onLoaded: {
          item.visible = Qt.binding(function () {
              return root.currentTab === 4;
          });
        }
      }

      // Tab 5: Effects
      Loader {
        active: root.currentTab === 5
        source: "./appearance/Effects.qml"
        onLoaded: {
          item.visible = Qt.binding(function () {
              return root.currentTab === 5;
          });
        }
      }

      // Tab 6: Layout
      Loader {
        active: root.currentTab === 6
        source: "./appearance/Layout.qml"
        onLoaded: {
          item.visible = Qt.binding(function () {
              return root.currentTab === 6;
          });
        }
      }

      // Tab 7: Wallpaper
      Com.Wallpapers {
        Layout.fillWidth: true
        Layout.fillHeight: true
      }
    }
  }
}
