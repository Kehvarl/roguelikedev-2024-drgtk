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
    @r = args.r || 50
    @g = args.g || 50
    @b = args.b || 50
    @blocks_movement = false
    @blocks_vision = false
  end
end
