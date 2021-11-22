import QtQuick 2.0
import QtQuick.Controls 2.12

Canvas{
        z:5
        id: canvas_ruler
              width: parent.width
              height: parent.height
              onPaint: {
                  var ctx = getContext("2d");
                  draw(ctx)
              }
    }

    function draw(ctx ) {
        var config={
              width: canvas_ruler.width-rulerWidth,
              height: canvas_ruler.height-rulerWidth,

              // 刻度尺相关
              size: 600, // 刻度尺总刻度数
              x: 10, // 刻度尺x坐标位置
              y: rulerWidth, // 刻度尺y坐标位置
              w: 5, // 刻度线的间隔
              h: 10 // 刻度线基础长度
            }
      var size = (config.size || 100) * 10 + 1
      var x = rulerWidth
      var y = rulerWidth-1
      var w = config.w || 5
      var h = config.h || 10
      var offset = 3 // 上面数字的偏移量
      // 画之前清空画布
      ctx.clearRect(0, 0, config.width, config.height)
      ctx.fillStyle ="#F5DEB3"
      ctx.fillRect(0, x,rulerWidth, config.height);
      ctx.fillRect(x,0 , config.width,rulerWidth);

      ctx.fillStyle ="#111"    // 设置画笔属性
      ctx.strokeStyle = '#333'
      ctx.lineWidth = 1
//      ctx.font = 13
      for (var i = 0; i < size; i++) {  //画水平
        ctx.beginPath()          // 开始一条路径
        // 移动到指定位置
        ctx.moveTo(x + i * w, y)
        // 满10刻度时刻度线长一些 并且在上方表明刻度
        if (i % 10 == 0) {
          // 计算偏移量
          offset = (String(i / 10).length * 6 / 2)
          ctx.fillText(i / 10,x + i * w - offset+10 , y - h * 1.2);
          ctx.lineTo(x + i * w, y - h * 2)
        } else {
          // 满5刻度时的刻度线略长于1刻度的
          ctx.lineTo(x + i * w, y - (i % 5 === 0 ? 1 : 0.6) * h)
        }
        // 画出路径
        ctx.stroke()
      }

      for ( i = 0; i < size; i++) {  //画垂直
        ctx.beginPath()          // 开始一条路径
        // 移动到指定位置
        ctx.moveTo(y,x + i * w)
        // 满10刻度时刻度线长一些 并且在上方表明刻度
        if (i % 10 == 0) {
          // 计算偏移量
          offset = (String(i / 10).length * 6 / 2)
          ctx.lineTo( y - h * 2,x + i * w,)
          ctx.fillText(i / 10, y - h * 1.2-5,x + i * w - offset+15 );
        } else {
          // 满5刻度时的刻度线略长于1刻度的
          ctx.lineTo(y - (i % 5 === 0 ? 1 : 0.6) * h,x + i * w)
        }
        // 画出路径
        ctx.stroke()
      }

    }
