require('app/tile.rb')

class GameMap
  attr_accessor :tiles, :w, :h
  def initialize()
    @w = 80
    @h = 40
    @tiles = {}
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
