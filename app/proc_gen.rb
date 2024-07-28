require('app/game_map.rb')

class RectRoom
  attr_accessor :x1, :y1, :x2, :y2, :center_x, :center_y
  def initialize (x, y, w, h)
    @x1 = x
    @y1 = y
    @x2 = x + w
    @y2 = y + h
    @center_x = @x1 + w.div(2)
    @center_y = @y1 + h.div(2)
  end
end

class DungeonMaker
  def initialize()
    @dungeon = GameMap.new()
  end

  def generate_dungeon()
    room_1 = RectRoom.new(x=20, y=15, w=10, h=15)
    room_2 = RectRoom.new(x=35, y=15, w=10, h=15)

    carve(room_1)
    carve(room_2)

    return @dungeon
  end

  def carve(room)
    (room.y1+1..room.y2).each do |y|
      (room.x1+1..room.x2).each do |x|
        @dungeon.tiles[[x,y]] = Tile.new(x=x, y=y)
      end
    end
  end
end
