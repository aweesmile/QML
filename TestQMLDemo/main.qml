import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Extras 1.4
ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: qsTr("Hello World")

    MainWindowCustomerArea {

        id: id_mainWindowCustomerArea
        x:50
        y:50

    }
//    ScaleMark {
//        id: id_scaleWark
//    }
//    Gauge {
//        width:parent.width
//            minimumValue: 0
//           // value: 5 //This property holds the value displayed by the gauge.
//            maximumValue: 20
//            minorTickmarkCount: 20
//            anchors.centerIn: parent
//            orientation: Qt.Horizontal



//        }
//    Rectangle {
//         width: 100; height: 100
//         color: "blue"
//         transform: Scale { origin.x: 25; origin.y: 25; xScale: 3}
//     }
}
