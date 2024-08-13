class Entity
  attr_sprite
  attr_accessor :pos_x, :pos_y

  def initialize (args) #(x,y,char=[0,64],r=255,g=255,b=255)
    @pos_x = args.x || 0
    @pos_y = args.y || 0
    @x = @pos_x * 16
    @y = @pos_y * 16
    @w = 16
    @h = 16
    @tile_w = 16
    @tile_h = 16
    @tile_x = args.char_c || 0
    @tile_y = args.char_r || 64
    @path ='sprites/misc/simple-mood-16x16.png'
    @r = args.r || 255
    @g = args.g || 255
    @b = args.b || 255
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
