### Part 3 - Generating the Dungeon
 Instead of placing lots of walls in our dungeon, we can treat treat the majority of the dungeon as wall, and "carve" out the rooms and hallways between them.

#### Procedural Generation
We could make map generation part of GameMap, but that just adds extra code to that class which is only used once in its lifetime.  Instead we will build a class for generating GameMaps with the map already populated.  Begin by creating a new file: `prog_gen.rb`

##### What's in a room
Our dungeon generation algorithm will use rooms and connecting corridors.  To begin with, we'll create a class to identify a room for us:

```Ruby
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
```
This simple class mostly stores a set of start and end coordinates, while also keeping track of the centerpoint that represents the middle of the room.  We'll use this for the actual generator.

Next create a class `DungeonMaker` which will be used to carve the actual rooms out of our Dungeon.  Since DungeonMaker needs access to an instance of GameMap, we need to make sure to `require` that first.


```ruby
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
```

`DungeonMaker` has 2 methods:  `generate _dungeon` which creates the room layout and returns the finished GameMap, and `carve` which takes a RectRoom object and carves it out of the map so the tiles are walkable.


To use this new class, we need to make a couple of changes.  First, to `main.rb`, we're going to use DungeonMaker to generate the GameMap we'll be Using
```ruby
require('app/proc_gen.rb')

def tick args
  if args.tick_count == 0
    player = Entity.new(x=40,y=20,char=[0,64],r=255,g=255,b=255)
    entities = [player, Entity.new(x=42,y=20,char=[0,64],r=255,g=255,b=0)]
    args.state.engine = Engine.new(entities, player)
    generator = DungeonMaker.new()
    args.state.game_map = generator.generate_dungeon()
  end
#...
```

And in `GameMap` itself, we want to take out our hard-coded tiles:

```Ruby
class GameMap
  attr_accessor :tiles
  def initialize()
    @w = 80
    @h = 40
    @tiles = {}
  end
# ...
```


![Part 3.1](./screenshots/Part3.1.png?raw=true "Generating rooms")

Of course, rooms aren't quite enough, we need a way to travel between them.  For this we will carve out hallways that connect the center points of 2 rooms we want to join.   Since these rooms are already carved out, that gives the effect of just joining the rooms.

However, since our center-points are rarely going to line up exactly, we need to make corridors that can connect offset rooms.  This is easily done with just 2 lines:  A horzontal line from lowest X to highest, and a Vertical line from lowest Y to highest.   If we randomize the order we draw these two lines, we can make a variety of connections.

Let's start by adding the method `tile_between` to our DungeonMaker class, like so:
```ruby
def tunnel_between(r2, r1)
  if [0,1].sample() == 0 #H then V
    (r1.center_x.. r2.center_x).each  do |x|
      @dungeon.tiles[[x,r1.center_y]] = Tile.new(x=x, y=r1.center_y)
    end
    (r1.center_y..r2.center_y).each do |y|
      @dungeon.tiles[[r2.center_x,y]] = Tile.new(x=r2.center_x, y=y)
    end
  else #V then H
    (r1.center_y..r2.center_y).each do |y|
      @dungeon.tiles[[r1.center_x,y]] = Tile.new(x=r1.center_x, y=y)
    end
    (r1.center_x.. r2.center_x).each  do |x|
      @dungeon.tiles[[x,r2.center_y]] = Tile.new(x=x, y=r2.center_y)
    end
  end
end
```

This method takes 2 rooms and finds the lowest X, highest X, lowest Y, and highest Y, then randomly decides which of the two directions to carve first.

To demonstrate, let's modify our `generate_dungeon` method like so:

```ruby

  def generate_dungeon()
    room_1 = RectRoom.new(x=20, y=15, w=10, h=15)
    room_2 = RectRoom.new(x=35, y=15, w=10, h=15)

    carve(room_1)
    carve(room_2)
    tunnel_between(room_1,room_2)

    return @dungeon
  end
```

If we run our project we should see 2 rooms joined by a pathway

![Part 3.2](./screenshots/Part3.2.png?raw=true "Connecting rooms with hallways")

### Moving within bounds
We have rooms and corridors, but movement is still basically unconstrained.   Let's fix that.  We'll modify our movement routine to ask the game world if a target tile is walkable. If so we'll allow the movement, if not we'll block it.

Engine needs to hold a copy of GameMap.  It can then query the game map before allowing a move to occur
