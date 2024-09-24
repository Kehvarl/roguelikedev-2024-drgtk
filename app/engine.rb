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
            e = @game_map.get_blocking_entities_at(r[0], r[1])
            if e == []
              @player.move(event.dx, event.dy)
            else
              puts ("Destination is blocked by Entity: #{e[0].name}")
              # melee action
            end
            @game_map.do_fov(@player.pos_x, @player.pos_y, 10)
          end
        end
      end
  end

  def render
  end
end
