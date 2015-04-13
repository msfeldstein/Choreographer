# class @BezierLevel
#   constructor: (container) ->
#     container.id ||= "bezier-#{Math.floor(Math.random() * 1000)}"
#     @paper = Raphael(container, 0, 0, window.innerWidth, 200);
#
#     @points = []
#     @group = @paper.set()
#
#     point = @paper.circle(50, 40, 10);
#     point.t = 50
#     point.attr("fill", "#f00");
#     point.attr("stroke", "#fff");
#     @points.push point
#     @group.push point
#
#     point = @paper.circle(150, 40, 10);
#     point.t = 150
#     point.attr("fill", "#f00");
#     point.attr("stroke", "#fff");
#     @points.push point
#     @group.push point
#     window.level = @
#
#
#   scroll: (dx) ->
#     newX = @group.x + dx
#     newX = Math.max(0, newX)
#     @group.attr(x: newX)
#
#   setScale: (scale) ->
#     for point in @points
#       point.attr(cx: point.t * scale)

# Paperjs
# class @BezierLevel
#   constructor: (container) ->
#     container.appendChild canvas = document.createElement('canvas')
#     canvas.width = window.innerWidth
#     canvas.height = 200
#     paper.setup(canvas)
#     path = new Path();
#     path.strokeColor = 'red';
#     path.add(new Point(0, 0));
#     path.add(new Point(100, 50));


# twojs
class @BezierLevel
  constructor: (container) ->
    @scale = 1
    @two = new Two({width: window.innerWidth, height: 200}).appendTo(container)
    @points = []
    @group = @two.makeGroup()
    # @addPoint(100, 50)
    # @addPoint(250, 30)
    # @addPoint(300, 35)

    container.addEventListener "click",@click

  click: (e) =>
    @addPoint(e.offsetX - @group.translation.x, e.offsetY)

  addPoint: (x, y) ->
    circle = @two.makeCircle(x, y, 5);
    circle.t = x / @scale
    circle.fill = '#FF8000'
    circle.stroke = 'orangered'
    circle.linewidth = 5
    @points.push(circle)
    @group.add(circle)
    @two.update()

  setScale: (@scale) ->
    # @group.scale = scale
    for point in @points
      point.translation.x = point.t * @scale
    @two.update()


  scroll: (dx) ->
    console.log dx
    @group.translation.x += dx
    @group.translation.x = Math.min(@group.translation.x, 0)
    @two.update()
