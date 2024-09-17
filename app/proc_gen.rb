require('app/game_map.rb')
class Range
   def each
     if self.first < self.last
       self.first.upto(last)  { |i| yield i}
     else
       self.first.downto(last) { |i|  yield i }
     end
   end
end

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
  attr_accessor :player_x, :player_y
  def initialize(player)
    @dungeon = GameMap.new([player])
    #@engine = engine
    @max_rooms = 10
    @room_min_size = 4
    @room_max_size = 10
    @player_x = 0
    @player_y = 0
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
        puts("#{new_room.center_x}, #{new_room.center_y}")
        rooms << new_room
        carve(new_room)
        if rooms.size > 1
          tunnel_between(rooms[-2], new_room)
        end
      end
    end
    #@engine.player.position(rooms[0].center_x, rooms[0].center_y)
    @player_x = rooms[0].center_x
    @player_y = rooms[0].center_y

    return @dungeon
  end

  def carve(room)
    (room.y1+1..room.y2).each do |y|
      (room.x1+1..room.x2).each do |x|
        if not @dungeon.tiles.key?([x,y])
          @dungeon.tiles[[x,y]] = Tile.new({x:x,y:y,dark:{r:100,g:100,b:100},light:{r:164,g:164,b:164}})
        end
      end
    end
  end

  def tunnel_between(r2, r1)
    if [0,1].sample() == 0 #H then V
      (r1.center_x.. r2.center_x).each  do |x|
        @dungeon.tiles[[x,r1.center_y]] = Tile.new({x:x, y:r1.center_y})
      end
      (r1.center_y..r2.center_y).each do |y|
        @dungeon.tiles[[r2.center_x,y]] = Tile.new({x:r2.center_x, y:y})
      end
    else #V then H
      (r1.center_y..r2.center_y).each do |y|
        @dungeon.tiles[[r1.center_x,y]] = Tile.new({x:r1.center_x, y:y})
      end
      (r1.center_x.. r2.center_x).each  do |x|
        @dungeon.tiles[[x,r2.center_y]] = Tile.new({x:x, y:r2.center_y})
      end
    end
  end
end
