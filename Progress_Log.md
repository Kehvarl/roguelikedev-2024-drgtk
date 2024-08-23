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
```Ruby
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

```Ruby
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

```Ruby
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

DragonRuby itself can act as our game engine with `args` acting as our tool for receiving input, tracking state, and outputting to the screen.  However, sometimes it's helpful to encapsulate game logic into a class designed to manage it.  Such a class might look like the following.

#### The Engine Class
First, create the file `engine.rb` then populate it like so
```ruby
class Engine
  def initialize(entities, player)
    @entities = entities
    @player = player
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
    player = Entity.new(x=40,y=20,char=[0,64],r=255,g=255,b=255)
    entities = [player, Entity.new(x=42,y=20,char=[0,64],r=255,g=255,b=0)]
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

  def initialize(x, y, char=[176, 208], r=50, b=50, g=100)
    @x = x * 16
    @y = y * 16
    @w = 16
    @h = 16
    @tile_w = 16
    @tile_h = 16
    @tile_x = char[0]
    @tile_y = char[1]
    @path ='sprites/misc/simple-mood-16x16.png'
    @r = r
    @g = g
    @b = b
    @blocks_movement
    @blocks_vision
  end
end
```

#### The GameMap class
We'll start a new file: `game_map.rb` with the following contents:
```ruby
class GameMap
  def initialize()
    @w = 80
    @h = 40
    @tiles = []
  end

  def in_bounds(x,y)
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
  end

  def render()
    @tiles
  end
end
```



## Cleanup thoughts
Need to take a step back and look at several things
1) Do I continue to use the Sprite classes or a dedicated entity class with a render function
  a) depends on how I handle questions 2 and 3
2) How do entities move, by grid square or by pixel
  a) pixel-aligned movement in 16-pixel increments would work
3) How is the world represented, by grid squares or by pixels
  a) Let's work in pixels for the moment
4) Do I build a proper event system like the tutorial or just pass the same messages as in the old Tutorial?


Next up is field of view.
Need to adjust how we draw tiles to track the ones that we've visited and the ones in visible range.
