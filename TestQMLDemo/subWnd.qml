import QtQuick 2.0
import QtQml.Models 2.12
import QtQuick.Controls 2.5
import QtQuick.Extras 1.4

Rectangle {


    id: subWnd
    width: 64
    height: 50
    x:0
    y:0
    color: "gray"
    border.color: "blue"
    border.width: 2
    radius:  5
    property int __index: 0
    property int initX: 0
    property int initY: 0
    property var originColor: "yellow"
    // 尝试销毁测试子窗口组件信号
    signal destroyMyself(var object)
    signal linkFindTestWindowObject(var object,var windowId)
    signal choosedWnd(var object)
    signal cancelChoose(var object)
    function resetPos(){
        x=initX
        y=initY
        z=0
        color="gray"
        console.log("resetPos()x y:",x," ",y)
    }

    Image{
        id: idImage
        anchors.centerIn: parent
        width: parent.width -10
        height: parent.height -10
        source: "file:///"+ "d:/test.png"
    }

    Text {
        id: testTmp
        font.family: "Microsoft YaHei"
        anchors.bottom: parent.bottom
        width: parent.width
        text: qsTr("B")+__index
        color: "blue"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Button{
        id: idDelete
        text: qsTr("✖")
        width: 30
        height: 30
        anchors.right: parent.right
        anchors.top: parent.top
        visible: false
        onClicked: {
            console.log("destroyMyself subWnd idDelete",subWnd,subWnd.__index)
            destroyMyself(subWnd) // parent or  subWnd,不可以是this
        }
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        onPressed: mouse.accepted=false
        onEntered:{
            idDelete.visible = true
            parent.border.color = "red"
            parent.color="#9400d3"
            parent.z=1
            choosedWnd(subWnd)
            console.debug("enter", __index, parent.x, parent.y, z)

        }
        onExited:{
            idDelete.visible = false

            parent.color = originColor
            parent.border.color = "blue"
            parent.color="gray"
            parent.z=0
            cancelChoose(subWnd)
            console.debug("exit", __index, parent.x, parent.y)
        }


    }


}

