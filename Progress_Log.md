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
![Part 1.1](./screenshots/Part1.1.png?raw=true "Game window with proper title")

#### Working with Sprite Sheets

#### Drawing our player on the screen

### Moving a Sprite

#### Getting Keyboard Input

#### Remembering State

#### Freedom of Movement
