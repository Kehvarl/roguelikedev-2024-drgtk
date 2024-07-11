def tick args
  args.outputs.primitives << {x:0, y:0, w:1280, h:720, r:0, g:0, b:0}.solid!
  args.outputs.primitives << {x:640, y:360, w:40, h:40, path:'sprites/square/blue.png'}.sprite!
end
