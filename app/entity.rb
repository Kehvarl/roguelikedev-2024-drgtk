class Entity
  attr_sprite

  def initialize (x,y,char=[0,64],r=255,g=255,b=255)
    @x = x * 16
    @y = y * 16
    @w = 16
    @h = 16
    @tile_w = 16
    @tile_h = 16
    @tile_x = char[0]
    @tile_y = char[1]
    @path ='sprites/misc/simple-mood-16x16.png'
    @r = r
    @g = g
    @b = b
  end

  def position(x, y)
    @x = x * 16
    @y = y * 16
  end

  def get_potential_move(dx, dy)
    [@x.div(16) + dx, @y.div(16) + dy]
  end

  def move (dx, dy)
    @x += (dx * 16)
    @y += (dy * 16)
  end
end
