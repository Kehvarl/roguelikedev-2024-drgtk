require('app/entity.rb')

def tick args
  args.state.player ||= Entity.new(x=40,y=20,char=[0,64],r=255,g=255,b=255)
  args.state.entities ||= [args.state.player, Entity.new(x=42,y=20,char=[0,64],r=255,g=255,b=0)]
  args.outputs.primitives << {x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!
  args.outputs.primitives << args.state.entities

  if args.inputs.keyboard.key_down.up
    args.state.player.move(0,1)
  elsif args.inputs.keyboard.key_down.down
    args.state.player.move(0,-1)
  elsif args.inputs.keyboard.key_down.left
    args.state.player.move(-1, 0)
  elsif args.inputs.keyboard.key_down.right
    args.state.player.move(1, 0)
  end
end
