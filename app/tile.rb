class Tile
  attr_sprite
  attr_accessor :blocks_vision, :blocks_movement

  def initialize args
    @x = args.x * 16 || 0
    @y = args.y * 16 || 0
    @w = 16
    @h = 16
    @tile_w = 16
    @tile_h = 16
    @tile_x = args.char_c || 176
    @tile_y = args.char_r || 208
    @path ='sprites/misc/simple-mood-16x16.png'
    @dark = args.dark || {r:50,g:50,b:50}
    @light = args.light || {r:100,g:100,b:100}
    set_color(@dark)
    @blocks_movement = false
    @blocks_vision = false
  end

  def visited
    set_color(@light)
  end

  def set_color(color)
    @r = color.r
    @g = color.g
    @b = color.b
  end

end
