class RectRoom
  attr_accessors :x1, :y1, :x2, :y2, :center_x, :center_y
  def initialize (x, y, w, h)
    @x1 = x
    @y1 = y
    @x2 = x + w
    @y2 = y + h
    @center_x = @x1 + w.div(2)
    @center_y = @y1 + h.div(2)
  end
end
