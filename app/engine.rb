class Engine
  attr_accessor :player, :game_map
  def initialize(player, game_map)
    @player = player
    @game_map = game_map
    @game_map.do_fov(@player.pos_x, @player.pos_y)
  end

  def handle_events(events)
      events.each do |event|
        if event.type == :player_move
          r = @player.get_potential_move(event.dx, event.dy)
          if @game_map.valid_move(r[0], r[1])
            @player.move(event.dx, event.dy)
            @game_map.do_fov(@player.pos_x, @player.pos_y, 10)
          end
        end
      end
  end

  def render
  end
end
