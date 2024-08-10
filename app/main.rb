require('app/entity.rb')
require('app/engine.rb')
require('app/tile.rb')
require('app/game_map.rb')
require('app/proc_gen.rb')

def tick args
  if args.tick_count == 0
    player = Entity.new(x=40,y=20,char=[0,64],r=255,g=255,b=255)
    entities = [player, Entity.new(x=42,y=20,char=[0,64],r=255,g=255,b=0)]
    generator = DungeonMaker.new()
    game_map = generator.generate_dungeon(args)
    player.position(generator.player_x, generator.player_y)
    args.state.engine = Engine.new(entities, player, game_map)

  end

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

  args.outputs.primitives << {x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!
  args.outputs.primitives << args.state.engine.game_map.render()
  args.outputs.primitives << args.state.engine.render()
end
