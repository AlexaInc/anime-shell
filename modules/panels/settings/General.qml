import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.components
import "./general/" as Com
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

    // Top Navigation Bar
    Bar.TopNavigationBar{
      animationProgress: root.animationProgress
      indexCategoegory: 0
      onCurrentTab: function(index) {
        root.currentTab = index
      }
    }

    // Main Content Area
    StackLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      currentIndex: root.currentTab

      // Tab 0: Language & Region
      Loader {
        active: root.currentTab === 0
        source: "./general/LanguageRegion.qml"
        onLoaded: {
          item.visible = Qt.binding(function () {
              return root.currentTab === 0;
          });
        }
      }

      // Tab 1: Date & Time
      Loader {
        active: root.currentTab === 1
        source: "./general/DateTime.qml"
        onLoaded: {
          item.visible = Qt.binding(function () {
              return root.currentTab === 1;
          });
        }
      }

      // Tab 2: Session
      Loader {
        active: root.currentTab === 2
        source: "./general/Session.qml"
        onLoaded: {
          item.visible = Qt.binding(function () {
              return root.currentTab === 2;
          });
        }
      }

      // Tab 3: Behavior
      Loader {
        active: root.currentTab === 3
        source: "./general/Behavior.qml"
        onLoaded: {
          item.visible = Qt.binding(function () {
              return root.currentTab === 3;
          });
        }
      }

      // Tab 4: Notifications
      Loader {
        active: root.currentTab === 4
        source: "./general/Notifications.qml"
        onLoaded: {
          item.visible = Qt.binding(function () {
              return root.currentTab === 4;
          });
        }
      }

      // Tab 5: Privacy
      Loader {
        active: root.currentTab === 5
        source: "./general/Privacy.qml"
        onLoaded: {
          item.visible = Qt.binding(function () {
              return root.currentTab === 5;
          });
        }
      }
    }
  }

  Component.onCompleted: {
    console.log("GeneralSettings loaded");
  }
}
