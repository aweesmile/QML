import QtQml.Models 2.12
import QtQuick.Extras 1.4
import QtQuick 2.0
import QtQuick.Controls 1.4
//import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick3D 1.15

Rectangle {
    x:0
    y:0
    Rectangle {
        visible: true
        width: 740
        height: 450
        id: id_main
        property int __point: 0
        property var __tempTestWindowObject
        property var __textWidth: 25
        property var curFrame: 30 //外部接入

        property var bookmarkH: 50
        property var frameNum: 100
        ListModel {
            id: listmodel

            function removeItem(windowId) {

                for(var i = 0; i < listmodel.count; ++i) {

                    if(String("%1").arg(listmodel.get(i).text) === String("%1").arg(windowId)) {

                        listmodel.remove(i)
                    }
                }
            }

        }
        /**listmodel对象删除的暂存到insertIndex中用来以后存入创建最小的下角标*/
        ListModel  {
            id: insertIndex

        }
        ListModel {
            id: id_frame

        }
        ListModel  {
            id: id_selFrame

        }

        function componentDestroy(object) {

            for(var i=0,p=-1;i<listmodel.count;++i){
                listmodel.get(i).a.resetPos()
                if(listmodel.get(i).a===object){
                    insertIndex.append({key:object.__index})
                    listmodel.remove(i)
                    id_frame.remove(i)
                }
            }
            object.destroy()
            id_selFrame.clear()
            id_bookMark.requestPaint()
        }
        function commponentCancel(object) {

            var pre=-1;var post=listmodel.count; var i=-1
            var preIndex=object.__index-1;var postIndex=object.__index+1
            for(var p=0 ;p<listmodel.count;++p){
                listmodel.get(p).a.resetPos()
            }
            id_selFrame.clear()
            id_bookMark.requestPaint()
        }

        function commponentChoosed(object) {
            console.log("选中了",object.__index)
            var pre=-1;var post=-1;var cur=-1
            var  minDisPre=50000,minDisPost=50000;
             for(var i=0;i<listmodel.count;++i){
                 if( listmodel.get(i).a.x==object.x){
                     cur=i
                     break
                 }
             }
            for(var i=0;i<listmodel.count;++i){

                if( listmodel.get(i).a.x<object.x &&minDisPre>=object.x-listmodel.get(i).a.x){

                    minDisPre=object.x-listmodel.get(i).a.x
                    pre=i

                }
            }
            for(var i=0;i<listmodel.count;++i){
                if(listmodel.get(i).a.x>object.x &&minDisPost>=listmodel.get(i).a.x-object.x){
                    minDisPost=listmodel.get(i).a.x-object.x
                    post=i
                }
            }
            console.log("选中了",cur,"pre ",pre,"post",post)
            var relativePos=0;
            //pre=cur-1;post=cur+1
            if(pre>=0)
            {
                listmodel.get(pre).a.color="pink"
                if( listmodel.get(cur).a.x- listmodel.get(pre).a.x< listmodel.get(cur).a.width){
                    listmodel.get(pre).a.x=listmodel.get(cur).a.x- listmodel.get(pre).a.width-5

                    listmodel.get(pre).a.z =1
                    relativePos=(listmodel.get(pre).a.x-id_bookMark.x+listmodel.get(pre).a.width/2)
                    id_selFrame.append({frameIndex:pre,posX: relativePos})
                }
            }
            if(post>=0 &&post<listmodel.count){
                 listmodel.get(post).a.color="pink"
                if( listmodel.get(post).a.x- listmodel.get(cur).a.x< listmodel.get(cur).a.width){
                    listmodel.get(post).a.x=listmodel.get(cur).a.x+ listmodel.get(post).a.width+5

                    listmodel.get(post).a.z=1
                    relativePos=(listmodel.get(post).a.x-id_bookMark.x+listmodel.get(post).a.width/2)
                    id_selFrame.append({frameIndex:post,posX:relativePos})
                }
            }
            id_bookMark.requestPaint()

        }

        function findInsertKey(){
            //查找插入的位置
            var point=-1
            if(insertIndex.count>0){
                var minid=0
                for(var i=1;i<insertIndex.count;++i){
                    if(insertIndex.get(minid).key>insertIndex.get(i).key){
                        minid=i
                    }
                }
                point= insertIndex.get(minid).key

                insertIndex.remove(minid)
            }

            return point>-1? point:listmodel.count
        }

        function createObject(framePos) {
            // createComponent from external file "subWnd.qml"
            var component = Qt.createComponent("subWnd.qml")
            if (component.status === Component.Ready) {

                var obj = component.createObject(id_main)
                obj.__index=findInsertKey()
                obj.x=id_scale.x+framePos-obj.width/2
                console.log("id_scale  x  ",id_scale.x,"tempPos x",framePos)
                obj.y=0
                obj.initX=obj.x
                obj.initY=obj.y
                {
                  listModeAppend(obj)
                  obj.destroyMyself.connect(componentDestroy)
                  obj.choosedWnd.connect(commponentChoosed)
                  obj.cancelChoose.connect(commponentCancel)
                }
            }

        }
        /**采用折半插入的思想*/
        function listModeAppend(obj){
            let len =listmodel.count
            var tempPos =id_bookMark.width*id_slider.value
            if(len==0){
                id_frame.append({framePos:tempPos})
                listmodel.append({a:obj})
                return
            }

            else
            {
                for(var i = 0; i < len; ++i){
                    var aa =listmodel.get(i).a
                    if(aa.x>=obj.x){
                        listmodel.insert({a:obj})
                        id_frame.insert(i,{framePos:tempPos})
                        console.log(aa,"__index",aa.__index,"; x",aa.x,"; color",aa.color )
                        return
                    }



                }
                if(i=len+1){
                    listmodel.append({a:obj})
                    id_frame.append({framePos:tempPos})
                }


            }

        }

        function showlist(){
            console.log("showSubList")
            for(var i = 0; i < listmodel.count; ++i) {
                var aa =listmodel.get(i).a
                console.log(aa,"__index",aa.__index,"; x",aa.x,"; color",aa.color )
            }
            for(var i=0;i<id_frame.count;++i){
                 console.log("; dis",Number(id_frame.get(i).dis))
            }

        }
        //  依据list  id_frame的dis排序
        function sortListModelByDis(id_frame){

            //var len = id_frame.count,partitionIndex,left = 0,right = len - 1

            if (left < right) {
                partitionIndex = partition(id_frame, left, right)
                sortListModelByDis(id_frame, left, partitionIndex-1)
                sortListModelByDis(id_frame, partitionIndex+1, right)
            }
            return id_frame

        }
        function partition(id_frame, left ,right) {     // 分区操作
            var pivot = left
            var k = pivot+1
            for (var i = k; i <= right; ++i) {
                if (id_frame.get(i).dis < id_frame.get(pivot).dis) {
                    console.log("id_frame.get(i).dis",id_frame.get(i).dis,"id_frame.get(pivot).dis",id_frame.get(pivot).dis)
                    var t=id_frame.get(i)
                    id_frame.set(i,id_frame.get(k))
                    id_frame.set(k,t)
                    k++;
                }
            }
            var t=id_frame.get(pivot)
            id_frame.set(pivot,id_frame.get(k - 1))
            id_frame.set(k- 1,t)

            return k-1;
        }
        function sort(){
                     var rowCount = id_frame.count;
                     for(var i = 0; i < rowCount; i++)
                         {
                             for(var j = 0; i + j < rowCount - 1; j++)
                             {
                                 if(id_frame.get(j).dis > id_frame.get(j+1).dis)
                                 {
                                     var temp = id_frame.get(j);
                                     id_frame.remove(j);
                                     id_frame.insert(j,id_frame.get(j+1))
                                     id_frame.remove(j+1);
                                     id_frame.insert(j+1,temp)
                                 }
                             }
                         }
                    // id_frame.sync()


        }
        /**导航线刻度尺*/
        Canvas{
            id:id_scale

            x:parent.__textWidth
            y:parent.bookmarkH
            width:parent.width-parent.__textWidth*2-2


            height: parent.height-parent.bookmarkH

            onPaint: {
                var ctx = id_scale.getContext("2d");
                drawScale(ctx);
            }

            function drawScale(ctx ) {

                ctx.strokeStyle = '#E2E4E3';
                ctx.lineWidth=2;
                ctx.moveTo(0,id_scale.height);
                ctx.lineTo(id_scale.width,id_scale.height)
                ctx.stroke();
                var spacetip= (id_scale.width/20)
                for(var i = 0; i< 21; i=i+2)
                {

                    ctx.moveTo( spacetip*i,id_scale.height-13);
                    ctx.lineTo(spacetip*i,id_scale.height);
                    ctx.stroke();
                }
                for(var i = 1; i< 21; i=i+2)
                {
                    ctx.moveTo( spacetip*i,id_scale.height-10);
                    ctx.lineTo(spacetip*i,id_scale.height);
                    ctx.stroke();
                }
            }



       }
        //滑动导向书签
        Slider {
            id: id_slider
            x: id_scale.x-10
            y: id_scale.y+id_bookMark.height/2
            width: id_scale.width+20
            style: SliderStyle {
                groove: Rectangle {

                    implicitWidth: id_slider.width
                    implicitHeight: 8
                    color: "red"
                    radius: 2
                    visible: true
                }
               handle:Rectangle {//滑块
                   id: id_handle
                   width:20
                   height:12
                   border.color: control.pressed ? "#DAF45C" : "#c0c0c0"
                   color: control.pressed ? "#228b22" : "lightgray"
                   visible: true
                   Rectangle{//滑块上线
                       id: id_sliderUp
                       x:id_handle.width/2
                       y:id_handle.y-id_bookMark.height/2+parent.width/2
                       color: id_handle.border.color
                      // border.color: "gray"

                       implicitWidth: 2
                       implicitHeight: id_bookMark.height/2-id_handle.height/2
                   }
                   Rectangle{//滑块下线
                       id: id_sliderDown
                       x:id_handle.x+id_handle.width/2
                       y:id_handle.y
                       color: id_handle.border.color
                       //border.color: "gray"
                       implicitWidth: 2
                       implicitHeight: id_bookMark.height/2-id_handle.height/2
                   }
               }
            }

            value:Number(id_inputFrame.text/100)


        }
        /**
        * 每个sub视图画书签以及line和距离
        */
        Canvas{
            id:id_bookMark
            x:id_scale.x
            y:id_scale.y
            width:id_scale.width

            height: id_scale.height

            onPaint: {
                var ctx = id_bookMark.getContext("2d");
                ctx.clearRect(0,0,id_bookMark.width,id_bookMark.height)
                ctx.reset()
                drawBookMark(ctx)
                drawGapText(ctx)
            }
//            onImageLoaded:
            function drawBookMark(ctx ) {

                // ctx.fillStyle="red";
                ctx.strokeStyle = '#E2E4E3';
                ctx.lineWidth=3;

                for(var i=0;i<id_frame.count;++i){
                    var isSel=false;
                    for(var j=0;j<id_selFrame.count;++j){
                        if(id_selFrame.get(j).frameIndex===i){
                            isSel=true;
                            ctx.moveTo(id_frame.get(i).framePos,10); //longest
                            ctx.lineTo(id_frame.get(i).framePos,id_bookMark.height)
                            ctx.stroke();
                            ctx.moveTo(id_selFrame.get(j).posX,0); // ver |
                            ctx.lineTo(id_selFrame.get(j).posX,10)
                            ctx.stroke();
                            ctx.moveTo(id_frame.get(i).framePos,10); // hor -
                            ctx.lineTo(id_selFrame.get(j).posX,10)
                            ctx.stroke();
                        }
                    }
                    if(!isSel){
                        ctx.moveTo(id_frame.get(i).framePos,id_bookMark.height); //init x y
                        ctx.lineTo(id_frame.get(i).framePos,0)

                        ctx.stroke();
                    }
                }               
            }
             //书签与滑块之间显示距离
            function drawGapText(ctx){
                var len =id_frame.count
                for(var i=0;i<len;++i){
                    var space =id_frame.get(i).framePos/id_bookMark.width-id_slider.value
                    id_frame.setProperty(i,"dis",space)

                }

                for(var i=0;i<len;++i){
                    if(id_bookMark.width*id_slider.value!=id_frame.get(i).framePos){


                        var dis = id_frame.get(i).dis
                       // var num =id_frame.count>=20? id_frame.count:20;
                        if(dis>0){
                           // var desY =id_slider.y+id_bookMark.height/2-id_bookMark.height*(i+1)/len<10?10:len
                            var desY =100+15*i
                            ctx.moveTo(id_bookMark.width*id_slider.value,desY); //longest
                            ctx.lineTo(id_frame.get(i).framePos, desY)
                            ctx.fillText(dis.toFixed(2),id_frame.get(i).framePos+5,desY)
                        }
                        else{
                            //var desY =id_slider.y+id_bookMark.height*(i+1)/len<10?10:len
                            var desY =300+15*i
                            ctx.moveTo(id_bookMark.width*id_slider.value,desY); //longest
                            ctx.lineTo(id_frame.get(i).framePos,desY)
                            ctx.fillText(Math.abs(dis.toFixed(2)),id_frame.get(i).framePos-25,desY)

                            }
                            ctx.fillstyle = Qt.rgba(1, 1, 1, 1)
                            ctx.stroke();
                        }
                }
            }
        }


        Text {
            id: textLeft
            x:0
            y:parent.height-parent.__textWidth
            width:parent.__textWidth


            text: qsTr("D")
        }
        Text {
            id: textRight
            x:parent.width-parent.__textWidth
            y:textLeft.y
            text: qsTr("P")
        }

    }

    TextEdit {
        id: id_inputFrame
        x:textLeft.x+400
        y:textLeft.y
        width:30
        color: '#a9a9a9'
        text: "30"
        font.pointSize: 20

         //focus: true
     }

    Button {
        id: createObjectBtn
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.bottomMargin: 5
        text: "createObject"
        onClicked: {
            id_main.curFrame = Number(id_inputFrame.text)
            // framePos 存放书签在刻度尺中的相对位置 dis 存放滑块和书签之间的相对距离，以帧率进行表示
            var tempPos =id_bookMark.width*id_slider.value

            id_main.createObject(tempPos)
            id_bookMark.requestPaint()
        }
    }
    Button {
           id:showSubList
           text: "printSubList"
           x: parent.x+100
           y:0
           anchors.bottom: parent.bottom
           onClicked: id_main.showlist()
       }
    Timer {
        interval: 1; running: true; repeat: true

        onTriggered: {
            id_bookMark.requestPaint();



        }
    }
    Button {
        id: id_sortlm
		x: 200
		text: "sort"
//        onClicked: id_main.sortListModelByDis(id_frame)
        onClicked: id_main.sort()

    }

}
