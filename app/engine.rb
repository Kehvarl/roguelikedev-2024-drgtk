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
          if @game_map.valid_move(event.dx, event.dy)
            @player.move(event.dx, event.dy)
          end
        end
      end
  end

  def render
    @entities
  end
end
