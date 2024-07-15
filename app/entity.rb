class Entity
  attr_sprite

  def initialize (x,y,char=[0,64],r=255,g=255,b=255)
    puts char
    @x = x
    @y = y
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
end
