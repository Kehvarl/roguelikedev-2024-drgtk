# /r/RogueLikeDev - The Complete Roguelikedev Tutorial 2024


## Part 0 - Setting Up
### Project Setup
* Acquire a licensed copy of [DragonRuby GTK](https://dragonruby.org/toolkit/game)
* Extract to a standard location for development work
  * Downloaded dragonruby-pro-linux-amd64.zip
  * Opened archive and copied contents to `/home/kehvarl/DragonRuby/RLD_Tutorial_2024`
  * Deleted `mygame` folder
  * At a terminal in the newply created `RLD_Tutorial_2024` folder:
    * `git clone git@github.com:Kehvarl/roguelikedev-2024-drgtk.git ./mygame`
* Install the editor of your choice
  * In this instance I am using Pulsar Edit (a fork of Atom)
* Open `mygame` folder as a project in your editor


## Part 1 - Drawing the '@' Symbol and Moving it around
Assuming you've followed Part 0 or otherwise set up your DragonRuby development environment, begin by opening the `main.rb` file in your `mygame` folder in the editor of your choice.
### Opening an Empty Window
Replace the contents so what you have looks like this
```Ruby
def tick args
  args.outputs.primitives << {x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!
end
```

You can run the program like any other DragonRuby program.  If you're new to DragonRuby, just run the `dragonruby` or `dragonruby.exe`executable in the parent directory above `mygame`.

You should now see a relatively plain window with a solid black background, and a title that tells you to update a different file to change it.

Open that new file `mygame\metadata\game_metadata.txt` in your editor, and replace the top section with something like this:
```
# devid=myname
# devtitle=My Name
# gameid=mygame
gametitle=RoguLikeDev Tutorial 2024
# version=0.1
# icon=metadata/icon.png
```

Lines that start with a 'sharp' (#) symbol are comments, and will be ignored in favor of their defaults.  In the above example the `gametitle` line has been uncommented and a new title added.  Save the file and re-run `dragonruby` to view the window with the new title.
![Part 1.0](./screenshots/Part1.0.png?raw=true "Game window with proper title")

### Drawing to the screen
Before we proceed, what's going on in our current `main.rb`?
```Ruby
def tick args
  args.outputs.primitives << {x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!
end
```

#### tick
The line `def tick args` creates a function named `tick` that expects a single parameter names `args`.  The `tick` function is special in DragonRuby, and is the main entrypoint for the engine into your game code.  In the background, the engine will try to run everything in the `tick` function 60 times per second, performing any drawing every time.  This means that as long as your game code can run in 1/60 of a second, you can maintain 60FPS by just letting DragonRuby run.

#### args
The only line in our `tick` function references the `args` parameter.  If `tick` is how DragonRuby runs your code, `args` is how your code interacts with DragonRuby.  It lets you save and recover game-state information, it provides you with information about what inputs are being provided by your player, it includes some tools for layout, and interaction of on-screen objects, and it lets you output information to the screen.
The line `args.outputs.primitives << ...` uses the `<<` command to append a definition to the `outputs.primitives` collection for DragonRuby to draw on screen this tick.

#### Hashes
The definition in question: ` {x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!` is a hash (the ruby word for a dictionary or map) with a few parameters:
* x: the x position defining the left side of our rectangle (Nearly everything in DragonRuby is rects at this level)
* y: the y position defining the *bottom* of our rectangle
* w: The width of our rectangle
* h: The height of our rectangle
* r: , g: , b:  the red, green, and blue parameters for the color to use (in this case 0,0,0 or Black)
* .solid! the primitive marker that tells DragonRuby this specific rectangle is to be filled in with the defined color

As you can see we are defining a solid black rectangle starting at the lower-left corner (0,0) that is the size of our window (1280x720), filling it completely.  This gives us a black background to draw the rest of our game on top of.

#### Sprite hashes
In additions to "solid" rectangles, DragonRuby can render an image known as a sprite.  For example, we can use the built-in blue square sprite found in the folder `mygame/sprites/square/`  it's named `blue.png`.

A minimal sprite hash definition looks like
```Ruby
{x: x_value, y: y_value, w: draw_width, h: draw_height, path: sprite_path}.sprite!
```
As with the solid, it expects an x and y position for the lower left corner, then a width and height.  Instead of a color, it looks for a path to the image to use.  There are several other properties we can work with, but they all have sensible defaults.  For more details, refer to the [DragonRuby Documentation: API: Outputs: Sprites: Rendering a Sprite Using a Hash](http://docs.dragonruby.org.s3-website-us-east-1.amazonaws.com/#/api/outputs?id=rendering-a-sprite-using-a-hash)

Update the `tick` method of your `main.rb` file to look like this:
```ruby
def tick args
  args.outputs.primitives << {x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!
  args.outputs.primitives << {x:640, y:360, w:40, h:40, path:'sprites/square/blue.png'}.sprite!
end
```

If you now run your game, you'll see a screen like this:
![Part 1.1](./screenshots/Part1.1.png?raw=true "Game window showing a sprite")

#### Working with Sprite Sheets
Instead of drawing an entire image onto the screen, DragonRuby is capable of drawing just part of a larger image.  This allows you to store several sprites in a single image file, for example all the animation frames for a specific action, or all the different animation frames for a specific character.

In this case we're going to use the included font-file `sprites/mist/simple-mood-16x16.png`.   This sprite sheet is a 16x16 grid of 16x16-pixel sprites that make up the simple-mood font.  Using this we can easily draw ASCII characters to the screen.
![Part 1.2-font](./sprites/mist/simple-mood-16x16.png?raw=true "Simple Mood font")

To draw a single item from a sprite sheet, we need to add 4 more properties to our hash:
```Ruby
{x: x_value, y: y_value, w: draw_width, h: draw_height,
 source_x: sprite-sheet_x_position, source_y:sprite-sheet_y_position,
 tile_w:width_of_sprite_in_sheet, tileh:height_of_sprite,
 path: sprite_path}.sprite!
```

For example, if we adjust our `tick` method like so:
```ruby
def tick args
  args.outputs.primitives << {x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!
  args.outputs.primitives << {x:640, y:360, w:40, h:40,
                              tile_x:0, tile_y:64,
                              tile_w:16, tile_h:16,
                              path:'sprites/misc/simple-mood-16x16.png'}.sprite!
end
```
We've replaced our blue square with the "@" symbol from the sprite sheet.
![Part 1.2](./screenshots/Part1.2.png?raw=true "Game window showing the @ symbol sprite")

#### Remembering State

To turn the new "@" sprite into our player representation, we need some way to make it respond to our inputs.  Which means we need some way to track the sprite's state, specifically its position on the screen.

In `args` there's a collection named `state`.  Any value stored into this collection will be available to be accessed on any future tick.  We will use this to store our entire player hash like so:
```ruby
def tick args
  args.state.player ||= {x:640, y:360, w:16, h:16,
                              tile_x:0, tile_y:64,
                              tile_w:16, tile_h:16,
                              path:'sprites/misc/simple-mood-16x16.png'}.sprite!
  args.outputs.primitives << {x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!
  args.outputs.primitives << args.state.player
end
```

Every time DragonRuby runs our `tick` function, it checks `args.state` for a variable named `player`.  If that variable is not set, then DragonRuby populates it with our player hash.   If it was already set in a prior tick, then this line does nothing.

We also updated out output to draw the contents of our `player` variable onto the screen.  Meaning any update we make will be reflected in our output

### Moving a Sprite
Now that we have our player sprite stored in our game state, we can change it and render our changes each tick

#### Getting Keyboard Input
To get inputs we will use `args` again.  In this case `args.inputs` holds any supported input states, whether from controllers, a mouse, a touchscreen, or a keyboard.

To check for a pressed key we can look at `args.inputs.keyboard.<key>`, but this will return true whether the key was just pressed, or if it's currently held down.  At 60 ticks per second, that might cause the player to take several turns when they only intend to take one.  Instead we'll use `args.inputs.keyboard.key_down.<key>` to only move when the key is pressed, then stop and wait for a new keypress.

If we add keypress checking to the `tick` method, the result might look like this:
```ruby
def tick args
  args.state.player ||= {x:640, y:360, w:16, h:16,
                              tile_x:0, tile_y:64,
                              tile_w:16, tile_h:16,
                              path:'sprites/misc/simple-mood-16x16.png'}.sprite!
  args.outputs.primitives << {x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!
  args.outputs.primitives << args.state.player

  if args.inputs.keyboard.key_down.up
    args.state.player.y += 16
  elsif args.inputs.keyboard.key_down.down
    args.state.player.y -= 16
  elsif args.inputs.keyboard.key_down.left
    args.state.player.x -= 16
  elsif args.inputs.keyboard.key_down.right
    args.state.player.x += 16
  end
end
```
If you now run the game, you can move the player around the screen with the arrow keys
![Part 1.3](./screenshots/Part1.3.png?raw=true "Player sprite can now move around the screen in response to inputs")






## Part 2 - The generic Entity, the render functions, and the map
We now have an @ symbol we can move around, but there's nothing for it to move around with.

### The Generic Entity
Our @ symbol currently exists as a hash in our game state.  We could continue with this approach and just add a variety of properties to the hash to account for things like hit-points, experience, level, and any other attributes we need to track, there is another approach: using a class.

#### The Sprite Class
We could create a class and give it some way to output the sprite we need to draw.  That might look something like this:
```ruby
class Entity
  def initialize(x,y,w,h,tile_x,tile_y)
    @x = x
    @y = y
    @w = w
    @h = h
    @tile_x = tile_x
    @tile_y = tile_y
  end

  def render
    {x:@x, y:@y, w:16, h:16,
     tile_x:@tile_x, tile_y:@tile_y,
     tile_w:16, tile_h:16,
     path:'sprites/misc/simple-mood-16x16.png'}.sprite!
  end
end
```
We could then build on this class as usual and after we perform our game logic on each tick we could then do render all our entities by iterating over the collection:
```ruby
Entities.each {|e|  args.outputs.primitives << e.render()}
```

However, there's a better way.  DragonRuby can also render sprites using a class, as shown in the [Documentation][(http://docs.dragonruby.org.s3-website-us-east-1.amazonaws.com/#/api/outputs?id=rendering-a-sprite-using-a-class). If we construct our class correctly, we can let DragonRuby render all of our entities with something as simple as:
```ruby
args.outputs.primitives << Entities
```
#### Our Entity class
We can convert our hash to a class like this:
```ruby
class Entity
  attr_sprite

  def initialize (x,y)
    @x = x
    @y = y
    @w = 16
    @h = 16
    @tile_w = 16
    @tile_h = 16
    @tile_x = 0
    @tile_y = 64
    @path ='sprites/misc/simple-mood-16x16.png'
    @r = r
    @g = g
    @b = b
  end

end
```

The DragonRuby macro `attr_sprite` sets the attr_accessors for all the built-in values a sprite should have, and also includes an appropriate `primitive_marker` definition so DragonRuby knows how to render the object.

We then define an `initialize` function which will be run when we call `Entity.new`.  This function requires the x and y positions where the character will be drawn.   A character can be provided based on the tile_x and tile_y offsets in our spritesheet.   We're also allowing r, g, and b values which DragonRuby will use to tint the sprite and adjust the color later on.

There are a few other member variables we're defining in `initialize`, specifically w, and h: the width and height to use when drawing our sprite; also tile_w and tile_h: the width and height of characters in our spritesheet.

There's one other improvement we could make here.  An Entity may have a number of optional settings and we don't want to have to pass all of them in every time we create a new one.   Instead, we can make `Initialize` look for a hash of options and either use the value in the hash or use a sensible defualt

```ruby
class Entity
  attr_sprite

  def initialize (vals={})
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
  end
end
```

In this example we're passing in a hash named `vals`.  The `vals` hash can contain some or all of the entries to use to create the Entity.   To achieve this we're using the `||` operator.   Essentially, we check the hash first, and if the expected value isn't present, we fail over to our default.

Let's create a new class `entity.rb` and populate it with our class as shown above, then modify our main.rb to use that class.  We'll set a color for our sprite so we can tell it's different from before:
```ruby
require('app/entity.rb')

def tick args
  args.state.player ||= Entity.new({x:640, y:360, char_c:0, char_r:64, r:240, g: 240, b: 0})
  args.outputs.primitives << {x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!
  args.outputs.primitives << args.state.player
# ...
```

Run the new code and you now have a yellow @ you can move background
![Part 2.0](./screenshots/Part2.0.png?raw=true "Drawing a Sprite using our new Entity class")

#### The Uses of the Entity Class
Right now our entity class is basically just a way to draw a sprite.  However, we can have the class take responsibility for movement as well by adding this method to our class:
```ruby
class Entity
  # ...
  def move(dx, dy)
    @x += dx
    @y += dy
  end
```

We can then tweak the input handler code in our `main.py` to use this new method
```ruby
#...
if args.inputs.keyboard.key_down.up
  args.state.player.move(0,16)
elsif args.inputs.keyboard.key_down.down
  args.state.player.move(0,-16)
elsif args.inputs.keyboard.key_down.left
  args.state.player.move(-16, 0)
elsif args.inputs.keyboard.key_down.right
  args.state.player.move(16, 0)
end
```

One more bit of cleanup.  We're moving by 16 with each move; this is because that's the size of the tiles we're drawing.   But we could just as easily move by 1 tile, and have the sprite know that 1 tile is 16 pixels

```ruby
#...
if args.inputs.keyboard.key_down.up
  args.state.player.move(0,1)
elsif args.inputs.keyboard.key_down.down
  args.state.player.move(0,-1)
elsif args.inputs.keyboard.key_down.left
  args.state.player.move(-1, 0)
elsif args.inputs.keyboard.key_down.right
  args.state.player.move(1, 0)
end
```

and

```ruby
class Entity
  def initialize (x,y,char=[0,64],r=255,g=255,b=255)
    puts char
    @x = x * 16
    @y = y * 16
  # ...
  def move(dx, dy)
    @x += (dx * 16)
    @y += (dy * 16)
  end
```

Let's use that Entity class to spawn an NPC too.  In our `main.rb` update our initialization code:

```ruby
def tick args
  args.state.player ||= Entity.new({x:640, y:360, char_c:0, char_r:64, r:255, g:255, b:255})
  args.state.entities ||= [args.state.player, Entity.new({x:42, y:20, char_c:0, char_r:64, r:255, g:255, b:0})]
  args.outputs.primitives << {x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!
  args.outputs.primitives << args.state.entities
  #...
```

We've created a new array of antities and put our player entity into it.  We've kept a reference to Player so we can sent it `move` commands,  and we've added another entity that doesn't respond to keyboard inputs.  By rendering our entire `entities` array, all entity sprites get sent to the screen in one step.

![Part 2.1](./screenshots/Part2.1.png?raw=true "Drawing multiple Entities")

### The Game Engine
The Python+TCOD tutorial uses a class named Engine to hold the entities, process input events, handle game logic, and manage rendering.

DragonRuby itself could act as our game engine with `args` acting as our tool for receiving input, tracking state, and outputting to the screen.  However, sometimes it's helpful to encapsulate game logic into a class designed to manage it.  Such a class might look like the following.

#### The Engine Class
First, create the file `engine.rb` then populate it like so
```ruby
class Engine
  attr_accessor :entities, :player, :game_map
  def initialize(entities, player, game_map)
    @entities = entities
    @player = player
    @game_map = game_map
  end

  def handle_events(events)
      events.each do |event|
        if event.type == :player_move
          @player.move(event.dx, event.dy)
        end
      end
  end

  def render
    @entities
  end
end
```

This skeleton does a few things
```Ruby
def initialize(entities, player)
  @entities = entities
  @player = player
end
```
We create class members that store the entity array and reference to the player entity.  We can use these for rendering later, and also to interact with our player entity.

```ruby
def handle_events(events)
    events.each do |event|
      if event.type == :player_move
        @player.move(event.dx, event.dy)
      end
    end
end
```
The start of an event handler.  Rather than each event being fed to the various entities immediately, we can batch them together, and process them in groups.  This currently only makes use of the Player entity's move function.

```Ruby
  def render
    @entities
  end
```
The render function just returns the list of entities to be drawn, but as our game becomes more detailed, we can upgrade that to draw rooms or even special effects

Of course, the Engine doesn't do anything unless we use it, so let's modify `main.rb` again and use this new tool in our arsenal:

```ruby
require('app/entity.rb')
require('app/engine.rb')

def tick args
  if args.tick_count == 0
    player = Entity.new({x:40,y:20,char_r:0,char_c:0})
    entities = [player, Entity.new({x:42,y:20,char_r:0,char_c:0,r=255,g=255,b=0)]
    args.state.engine = Engine.new(entities, player)
  end

  if args.inputs.keyboard.key_down.up
    args.state.engine.handle_events([{type: :player_move, dx:0, dy:1}])
  elsif args.inputs.keyboard.key_down.down
    args.state.engine.handle_events([{type: :player_move, dx:0, dy:-1}])
  elsif args.inputs.keyboard.key_down.left
    args.state.engine.handle_events([{type: :player_move, dx:-1, dy:0}])
  elsif args.inputs.keyboard.key_down.right
    args.state.engine.handle_events([{type: :player_move, dx:1, dy:0}])
  end

  args.outputs.primitives << {x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!
  args.outputs.primitives << args.state.engine.render()
end
```

We start by using `require` to make our Engine class available to us.

Next, we've changed out initialization a bit.  Instead of using `||=` to see if we need to set state every turn, we just check for the current Tick count.  On the first Tick (0), we create a player, create an entities array with the player and an NPC, then create an instance of Engine with that player and entities list.   You'll notice the only item we add to our `args.state` is the new Egnine.  We don't need to keep the player and entities references since Engine tracks that for us.

We've tweaked the inputs to pass each potential action to the Engine.  This isn't the best way to do this and we'll improve on that in the next step.

Finally, we've moved our rendering code to the end of the Tick.  And we simply draw the output of `Engine.render()` to the screen

If you run the program now, it's in a working state but our new Engine is handling most of the processing for us.

#### Multiple Events
Instead of calling the event handler for each event, we can collect the events that do occur and pass them to our engine class.  An example of that would be changing our `main.py` like so

```ruby
#...
events = []

if args.inputs.keyboard.key_down.up
  events << {type: :player_move, dx:0, dy:1}
elsif args.inputs.keyboard.key_down.down
  events << {type: :player_move, dx:0, dy:-1}
elsif args.inputs.keyboard.key_down.left
  events << {type: :player_move, dx:-1, dy:0}
elsif args.inputs.keyboard.key_down.right
  events << {type: :player_move, dx:1, dy:0}
end

args.state.engine.handle_events(events)
#...
```

Essentially, we create an events list, and simply append all our events to it.  In this case the list is only ever one item long, but future edits can change that.



### The Game Map
With our Engine class handling most of the heavy lifting so far, and both our player and NPC on the screen, it's time to give the player something to explore.   We won't go into procedural generation yet, but we'll build a class to hold and display a map on the screen, and allow us to move around its corridors and rooms.

#### The Tile class
The map is made up of a series of `Tile` objects.  Since a `Tile` is something we'll draw on the screen, it's another Sprite, like the `Entity` class.  Unlike `Entity`, a `Tile` doesn't move around the map, and doesn't interact with the player or other entities in the same way.  Instead, a Tile will hold parameters about its appearance, and how it allows or prevents visibility and movement through the space it represents.

Create a new file named `tiles.rb` and populate it like so:
```ruby
class Tile
  attr_sprite
  attr_accessor :blocks_vision, :blocks_movement

  def initialize vals
    @x = vals.x * 16 || 0
    @y = vals.y * 16 || 0
    @w = 16
    @h = 16
    @tile_w = 16
    @tile_h = 16
    @tile_x = vals.char_c || 176
    @tile_y = vals.char_r || 208
    @path ='sprites/misc/simple-mood-16x16.png'
    @r = vals.r || 50
    @g = vals.g || 50
    @b = vals.b || 50
    @blocks_movement = false
    @blocks_vision = false
  end
end
```

Our Tile is a basic Sprite with a couple of extra features.  Specifically, we've added attributes and accessors for `blocks_movement` for those tiles you can't walk through, and `blocks_vision` for those that can't be seen through.


#### The GameMap class

We'll use these Tiles in our GameMap class.  The GameMap basically holds a hash of the tiles we carve into the map.  Anything not in this hash will be assumed to be a solid wall, which saves us from storing tiles for all the possible unreachable points in our map.  For convenience, the GameMap will implement a grid and grid coordinates will be the keys for the Tile Hash.  A grid cell is basically a 16x16 pixel region of the map, and represents the space that can be inhabited by a Tile or Entity.

For the first pass, we'll implement some room carving in the GameMap itself which will take a rectangle of grid coordinates and add the appropriate tiles in those positions.

We'll start a new file: `game_map.rb` with the following contents:
```ruby
require('app/tile.rb')
class GameMap
  attr_accessor :tiles, :w, :h
  def initialize()
    @w = 80
    @h = 40
    @tiles = {}

    @tiles[30,22] = Tile.new({x:30, y:22})
    @tiles[31,22] = Tile.new({x:31, y:22})
    @tiles[32,22] = Tile.new({x:32, y:22})

  end

  def render()
    out = []
    @tiles.each_key do |t|
      out << @tiles[t]
    end
    out
  end
end
```

This will draw some tiles like a wall on our map.




## Part 3 - Generating a Dungeon
We'll start by throwing away the part of our GameMap that draws a wall, and we'll think about how we represent rooms and corridors on our map.  Instead of drawing every wall, we can consider everything a wall unless we place a non-wall tile there.   Our modified generation-ready GameMap will look like:

```ruby
class GameMap
  attr_accessor :tiles, :w, :h
  def initialize()
    @w = 80
    @h = 40
    @tiles = {}
  end

  def render()
    out = []
    @tiles.each_key do |t|
      out << @tiles[t]
    end
    out
  end
end
```

As you can see, it's stripped down to the bare minimum to hold a map and render it.

### Rendering
Our GameMap render function is a little complicated.  Since we're storing our map in a hash instead of an array, we can't just output the hash to DragonRuby.  Instead we iterate through all the tiles, and add each one to an array.  Then return that array which we can pass to DragonRuby to draw.

### Defining a Room
Before we can generate rooms, we need some way to define a room.   Let's create a file named `prog_gen.rb`  We'll put all the tools for map generation here, and not clutter the GameMap class with them.  In that file, we'll start by defining a class `RectRoom`:

```ruby

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
```

This literally is just a quick tool to define a "room" and calculate some useful values.   We can pass in the X and Y position at which the top corner of the room is positioned, and both W and H for the "width" and "height".  Using these we can calculate the X1, Y1 of the top left corner, and the X2, Y2 of the bottom right corner.  We can also get an approximate center point of the room for future use.

### The Dungeon Maker
We'll define a class that builds a dungeon map and passes it to us for use in our Engine.

The DungeonMaker will create the copy of GameMap to use, and pass it to us, this means the file will need access to the GameMap class.  At the top of our `proc_gen.rb` file, add this line:
```Ruby
require('app/game_map.rb')
```

DungeonMaker basically just builds a GameMap, carves rooms out of it, and provides the ready map for our game to work with.  It needs to have a few things to start with, so let's work on it.   The class needs to create and manage a copy of GameMap, and then it's going to use our RectRooms to carve a couple of sample rooms.   Which means we'll need to define the rooms and have a routine to do that carving.

```ruby
class DungeonMaker
  def initialize()
    @dungeon = GameMap.new()
  end

  def generate_dungeon(args)
    room_1 = RectRoom.new(20,20,10,10)
    room_2 = RectRoom.new(40,25,10,10)

    carve(room_1)
    carve(room_2)

    return @dungeon
  end

  def carve(room)
    (room.y1+1..room.y2).each do |y|
      (room.x1+1..room.x2).each do |x|
        if not @dungeon.tiles.key?([x,y])
          @dungeon.tiles[[x,y]] = Tile.new({x:x,y:y,r:100,g:100,b:100})
        end
      end
    end
  end
end
```

We can then call this from our Main and pass the GameMap to our engine
At the top of our `main.rb`:
```ruby
# ...
require('app/proc_gen.rb')
```

```ruby
def tick args
  if args.tick_count == 0
    player = Entity.new({ x: 25, y: 20})
    entities = [player, Entity.new({x:42, y:20, b:0})]
    generator = DungeonMaker.new()
    game_map = generator.generate_dungeon(args)
    args.state.engine = Engine.new(entities, player, game_map)

  end
# ...
```

![Part 3.1](./screenshots/Part3.1.png?raw=true "Drawing rooms")


### Generating Rooms
Of course, we don't actually want to define every room in our map, we want to generate them.  We have a convenient RectRoom class, we know our map width and height, if we game ourselves a few more parameters, we could randomly create rooms.  In fact, we really only need 3 more things:  The maximum number of rooms in our map, the smallest size a room can be, and the largest size a room can be.   If we put those into our class and assign some default values, our new `initialize` function for `DungeonMaker` might look like so:

```ruby
  def initialize()
    @dungeon = GameMap.new()
    @max_rooms = 10
    @room_min_size = 4
    @room_max_size = 10
  end
```

And given those variables, we can tweak our `generate_dungeon` method to be something like this:
```ruby
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
      end
    end

    return @dungeon
  end
```
      new_room = RectRoom.new(x, y, rw, rh)

      collisions = args.geometry.find_all_intersect_rect(new_room, rooms)
      if collisions.size == 0
        rooms << new_room
        carve(new_room)
      end
This won't actually work yet, but before we get to why, let's dig into what this is doing.

```ruby
    (0...@max_rooms).each do
      # ...
    end
```
This is the equivalent of a "for" loop in other languages.   We're creating a range from 0 to `max_rooms`, which in our case is 10.  Then for each value in that range we run our loop body.

The first thing out loop does is generate 4 random numbers:
```ruby
    rw = (@room_min_size...@room_max_size).to_a.sample
    rh = (@room_min_size...@room_max_size).to_a.sample
    x = (0...(@dungeon.w - rw - 1)).to_a.sample
    y = (0...(@dungeon.h - rh - 1)).to_a.sample
```
Once again, we're abusing ranges.  The first example: `rw = (@room_min_size...@room_max_size).to_a.sample` creates a range of the values from our min_size to our max_size, converts that to an array, then picks a value from the array at random.  There are better ways to pick a random integer in a range, but this one works for our purposes.   The other 3 variables are set in much the same way.

Now onto the fun part:
```ruby
    new_room = RectRoom.new(x, y, rw, rh)

    collisions = args.geometry.find_all_intersect_rect(new_room, rooms)
    if collisions.size == 0
      rooms << new_room
      carve(new_room)
    end
```
First we define a new RectRoom with our random values.
Then we test that room against all our existing rooms (if any).
If the new room doesn't overlap with any other previously defined rooms, then we add it to our rooms list and carve it into our GameMap.   The rooms list comes into play in the next feature.

### Corridors
We have rooms randomly placed on the map, and our rooms have a convenient center point.  We can pretty easily carve corridors that connect those two center points.  One approach would be:

```ruby
  def tunnel_between(r2, r1)
    (r1.center_x.. r2.center_x).each  do |x|
      @dungeon.tiles[[x,r1.center_y]] = Tile.new({x:x, y:r1.center_y})
    end
    (r1.center_y..r2.center_y).each do |y|
      @dungeon.tiles[[r2.center_x,y]] = Tile.new({x:r2.center_x, y:y})
    end
  end
```

This will carve a horizontal corridor from the center of room_1 to the center_x of room_2.  Then a vertical corridor from that end point to the center of room_2.

Unfortunately, it doesn't work.  If we run it, we will almost certainly end up with some rooms with no connections, and some corridors dead ending in space.  The reason for this is simple: we set up our iterator using a range, for example: `(r1.cemter_x.. r2.center_x)`m and ranges are designed to count up, not down.   We could modify our approach; but because this is Ruby, we can also just change how ranges work.   At the top of our file, just after the `require` lines, let's add a new class:

```ruby
class Range
   def each
     if self.first < self.last
       self.first.upto(last)  { |i| yield i}
     else
       self.first.downto(last) { |i|  yield i }
     end
   end
end
```

This class extends the built-in Range, and changes how it works.  Instead of always returning the values from first counting up to last, it can now also return values from first counting down to last.

A quick save, run, and now we have a map with usable corridors.

One further change, it's boring if the corridors are always horizontal, then vertical.   It might be nice to have it sometime be vertical first, then horizontal.   Like so:

```ruby
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
```

Thus ends part 3 and we're on to part 4 Next





## Part 4 - Field of View
We now have a dungeon and we can wander around in it.  However, there's not a lot of exploration involved when the entire map is visible from the beginning.  Though a game could certainly be made to work without a hidden map, if that suits the mood you want to builds

### Tile State

As we explore, there are really 3 states a tile can be in:
  * Unexplored/Unknown
  * Explored
  * Visible

An Unexplored tile is one that hasn't ever been revealed to the player, it conceals mystery and infinite possibility.

An Explored tile is one that has been visited, but is currently not in the players field of view.  Anything could be happening there and the player would never know.

Finally, a Visible tile is one currently in the Player's field of view.  It holds few mysteries, unless there are hidden or invisible things.

#### Tracking Tile state
There are basically 3 places we can track the U/E/V state of a tile:
 1. The Game Map.  This makes sense as the tiles are already part of the map.  It basically makes "Tile State" an intrinsic property of the tiles

 2. The Engine.  The engine already houses the GameMap, and it handles all actions.  Having it track the state of every tile might work.

 3. The Entity.  If we want every entity to maintain its own "Fog of War", know what it can see, and know the layout of places it has explored already, this is the way to do it.  Definitely an option for a more advanced future game.

 In our case we'll use the GameMap.  We can even leverage the map's rendering function to handle the drawing for us instead.

### Field of View
Now that we've hidden the entirety of our map, we need to start revealing the parts we can see.  There are several ways to go about this, the two we're doing to look into are the simple approach, and recursive shadow casting.  We'll look at them in reverse order.

 * Recursive Shadow Casting:   Red Blob Games links to an Albert Ford article on the topic: https://www.albertford.com/shadowcasting/.  In essence, we draw a cone that we might see, then starting from the character, we draw a line out to each point on the edge, if we encounter any object, then we mark all further tiles on the map as hidden.  Then we just draw those tiles we didn't mark as hidden.  We can even repeat this all the way around a circle and illuminate 360 degrees in a sensible way.

 * A simple approach:  We'll do this first, then implement recursive shadow casting to replace it.  This solution however, will basically be us drawing a circle around the character, and illuminating all tiles in range regardless of line of site.

 #### A Simple circle
 In our Game_Map, let's add a function to do simple circular field of View
 We'll iterate through all the tiles in the map, if they're within, say 10 tiles of the player we'll mark them as lit and mark them as visited so our rendering will work.  Otherwise they're dark tiles which will only be rendered if they've been visited previously.
 The key part is our distance calculation `Math.sqrt((x-tx)**2 + (y-ty)**2)`  Which basically used the Pythagorean theorem to plot the distance between 2 points given the difference in x and y values.
 ```ruby
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
 ```

 To make use of this, we'll tweak our Engine to call this function every frame.  We need to do it here because we need to pass in the player X and Y coordinates to make this work.
 ```ruby
 def handle_events(events)
     events.each do |event|
       if event.type == :player_move
         r = @player.get_potential_move(event.dx, event.dy)
         if @game_map.valid_move(r[0], r[1])
           @player.move(event.dx, event.dy)
           @game_map.calculate_fov(@player.x, @player.y)
         end
       end
     end
 end
 ```

 #### Recursive Shadow Casting
 For our implementation we'll be referencing several very good examples
 * [Red Blob Games](https://www.redblobgames.com/articles/visibility/)
 * [Albert Ford](https://www.albertford.com/shadowcasting/)
 * [Rogue Basin](https://www.roguebasin.com/index.php/FOV_using_recursive_shadowcasting)
 * [Rogue Basin Ruby Implementation](https://www.roguebasin.com/index.php/Ruby_shadowcasting_implementation)

One interesting feature of the algorithm is that it works on 1/8 of a circle, and we simple call it 8 times with a set of translations for each octant.

We can almost use the RogueBasin Ruby code as is.  First we need a couple of utility functions in our `GameMap`:
 * blocked(x,y): checks the tile at the grid position X,Y.   If the tile doesn't exist, is off the map, or exists but blocks visibility, then we'll assume it's a blocking tile.
 * light(x,y):  "lights" the tile at grid position X,Y.  Also marks it as Visited.

```ruby
  def vision_blocked?(x,y)
    (not in_bounds(x,y)) or (not@tiles.key?([x,y])) or @tiles[[x,y]].blocks_vision
  end

  def light(x,y)
    if in_bounds(x, y) and @tiles.key?([x, y])
      @tiles[[x, y]].visited = true
      @tiles[[x, y]].light
    end
  end
```

With those tools, we can essentially copy the rest of the code from the article:
```ruby
  # Determines which co-ordinates on a 2D grid are visible
  # from a particular co-ordinate.
  # start_x, start_y: center of view
  # radius: how far field of view extends
  def do_fov(start_x, start_y, radius=10)
    light(start_x, start_y) # Light the starting position

    8.times do |oct|
        cast_light start_x, start_y, 1, 1.0, 0.0, radius,
            @@mult[0][oct],@@mult[1][oct],
            @@mult[2][oct], @@mult[3][oct], 0
    end
  end

  def cast_light(cx, cy, row, light_start, light_end, radius, xx, xy, yx, yy, id)
    return if light_start < light_end
    radius_sq = radius * radius
    (row..radius).each do |j| # .. is inclusive
        dx, dy = -j - 1, -j
        blocked = false
        while dx <= 0
            dx += 1
            # Translate the dx, dy co-ordinates into map co-ordinates
            mx, my = cx + dx * xx + dy * xy, cy + dx * yx + dy * yy
            # l_slope and r_slope store the slopes of the left and right
            # extremities of the square we're considering:
            l_slope, r_slope = (dx-0.5)/(dy+0.5), (dx+0.5)/(dy-0.5)
            if light_start < r_slope
                next
            elsif light_end > l_slope
                break
            else
                # Our light beam is touching this square; light it
                if (dx*dx + dy*dy) < radius_sq
                  light(mx,my)
                end

                if blocked
                    # We've scanning a row of blocked squares
                    if vision_blocked?(mx, my)
                        new_start = r_slope
                        next
                    else
                        blocked = false
                        light_start = new_start
                    end
                else
                    if vision_blocked?(mx, my) and j < radius
                        # This is a blocking square, start a child scan
                        blocked = true
                        cast_light(cx, cy, j+1, light_start, l_slope,
                            radius, xx, xy, yx, yy, id+1)
                        new_start = r_slope
                    end
                end
            end
        end # while dx <= 0
        break if blocked
    end # (row..radius+1).each
  end
```

And that's it.   If we were using a library like TCOD it would be even simpler as the shadowcasting function would be built in.




## Part 5 - Placing Enemies and Kicking them (Harmlessly)

Next up, let's populate our dungeon and interact with the denizens thereof.
