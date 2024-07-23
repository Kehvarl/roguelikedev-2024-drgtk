class Tile
  attr_sprite

  def initialize (x,y,char=[176, 208], r=50, b=50, g=100)
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
    @blocks_movement
    @blocks_vision
  end
end
