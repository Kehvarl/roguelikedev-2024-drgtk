class Entity
  attr_sprite
  attr_accessor :pos_x, :pos_y, :name

  def initialize (vals={})
    @name = vals.name || "Entity"
    @pos_x = vals.x || 0
    @pos_y = vals.y || 0
    @x = @pos_x * 16
    @y = @pos_y * 16
    @w = 16
    @h = 16
    @tile_w = 16
    @tile_h = 16
    @tile_x = vals.char_c || 0
    @tile_y = vals.char_r || 64
    @path ='sprites/misc/simple-mood-16x16.png'
    @r = vals.r || 255
    @g = vals.g || 255
    @b = vals.b || 255
    @blocks_movement = true
  end

  def position(x, y)
    @pos_x = x
    @pos_y = y
    @x = x * 16
    @y = y * 16
  end

  def get_potential_move(dx, dy)
    [@pos_x + dx, @pos_y + dy]
  end

  def move (dx, dy)
    @pos_x += dx
    @pos_y += dy
    @x += (dx * 16)
    @y += (dy * 16)
  end
end
