require('app/game_map.rb')

class RectRoom
  attr_accessor :x1, :y1, :x2, :y2, :center_x, :center_y, :x, :y, :w, :h
  def initialize (x, y, w, h)
    @x = x
    @y = y
    @w = w
    @h = h
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
    @max_rooms = 10
    @room_min_size = 4
    @room_max_size = 10
  end

  def generate_dungeon(args)
    rooms = []
    (0...@max_rooms).each do
      rw = (@room_min_size...@room_max_size).to_a.sample
      rh = (@room_min_size...@room_max_size).to_a.sample
      x = (0...(@dungeon.w - rw - 1)).to_a.sample
      y = (0...(@dungeon.h - rh - 1)).to_a.sample

      new_room = RectRoom.new(x, y, rw, rh)

      collisions = args.geometry.find_all_intersect_rect(new_room, rooms)
      if collisions.size == 0
        rooms << new_room
        carve(new_room)
        if rooms.size > 1
          tunnel_between(rooms[-2], rooms[-1])
        end
      end
    end
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
