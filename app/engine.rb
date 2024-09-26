class Engine
  attr_accessor :player, :game_map
  def initialize(player, game_map)
    @player = player
    @game_map = game_map
    @game_map.do_fov(@player.pos_x, @player.pos_y)
  end

  def handle_enemy_turns()
    @game_map.entities.select{|e| e.name!="Player"}.each do |e|
      puts("#{e.name} wonders when it will get to take a real turn")
    end
  end

  def handle_events(events)
    if events == []
      return
    end
    events.each do |event|
      if event.type == :player_move
        r = @player.get_potential_move(event.dx, event.dy)
        if @game_map.valid_move(r[0], r[1])
          e = @game_map.get_blocking_entity_at(r[0], r[1])
          if e == []
            @player.move(event.dx, event.dy)
          else
            events << {type: :attack, x: e.pos_x, y: e.pos_y}
            # melee action
          end
          @game_map.do_fov(@player.pos_x, @player.pos_y, 10)
        end
      elsif event.type == :attack
        e = @game_map.get_blocking_entity_at(event.x, event.y)
        puts ("Destination is blocked by Entity: #{e.name}")
      end
    end
    handle_enemy_turns()
  end

  def render
  end
end
