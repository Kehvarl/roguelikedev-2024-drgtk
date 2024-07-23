require('app/tile.rb')

class GameMap
  def initialize()
    @w = 80
    @h = 40
    @tiles = {}
    @tiles[[30,22]] = Tile.new(x=30,y=22)
    @tiles[[31,22]] = Tile.new(x=31,y=22)
    @tiles[[32,22]] = Tile.new(x=32,y=22)
    @tiles[[33,22]] = Tile.new(x=33,y=22)
  end

  def in_bounds(x,y)
    (0 <= x <= @w) and (0 <= y < @h)
  end

  def render()
    out = []
    @tiles.each_key do |t|
      out << @tiles[t]
    end
    out
  end
end
