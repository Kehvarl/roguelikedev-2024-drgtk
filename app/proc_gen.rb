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
    tunnel_between(room_1,room_2)

    return @dungeon
  end

  def carve(room)
    (room.y1+1..room.y2).each do |y|
      (room.x1+1..room.x2).each do |x|
        @dungeon.tiles[[x,y]] = Tile.new(x=x, y=y, char=[176, 208], r=100, g=100, b=100)
      end
    end
  end

  def tunnel_between(r2, r1)
    x1 = [r1.center_x,r2.center_x].min
    x2 = [r1.center_x,r2.center_x].max
    y1 = [r1.center_y,r2.center_y].min
    y2 = [r1.center_y,r2.center_y].max
    if [0,1].sample() == 0 #H then V
      (x1..x2).each do |x|
        @dungeon.tiles[[x,y1]] = Tile.new(x=x, y=y1)
      end
      (y1..y2).each do |y|
        @dungeon.tiles[[x2,y]] = Tile.new(x=x2, y=y)
      end
    else #V then H
      (y1..y2).each do |y|
        @dungeon.tiles[[x1,y]] = Tile.new(x=x1, y=y)
      end
      (x1..x2).each do |x|
        @dungeon.tiles[[x,y2]] = Tile.new(x=x, y=y2)
      end
    end
  end
end
