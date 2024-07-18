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
