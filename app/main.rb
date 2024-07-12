def tick args
  args.state.player ||= {x:640, y:360, w:16, h:16,
                              tile_x:0, tile_y:64,
                              tile_w:16, tile_h:16,
                              path:'sprites/misc/simple-mood-16x16.png'}.sprite!
  args.outputs.primitives << {x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!
  args.outputs.primitives << args.state.player
end
