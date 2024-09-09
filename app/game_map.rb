require('app/tile.rb')

class GameMap
  attr_accessor :tiles, :w, :h
  def initialize()
    @w = 80
    @h = 40
    @tiles = {}
    @visible = []
  end

  def calculate_fov(x, y)
    @tiles.each_key do |t|
      tx = @tiles[t].x
      ty = @tiles[t].y

      if Math.sqrt((x-tx)**2 + (y-ty)**2) <= 160
        @tiles[t].light
        @tiles[t].visited = true
      else
        @tiles[t].dark
      end
    end
  end

  def in_bounds(x,y)
    (0 <= x  and x <= @w) and (0 <= y and y < @h)
  end

  def valid_move(x,y)
    x = x
    y = y
    (in_bounds(x,y) and (@tiles.key?([x,y]) and (not @tiles[[x,y]].blocks_movement)))
  end

  def render()
    out = []
    @tiles.each_key do |t|
      if @tiles[t].visited
        out << @tiles[t]
      end
    end
    out
  end
end
