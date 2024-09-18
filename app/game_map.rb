require('app/tile.rb')

class GameMap
  attr_accessor :tiles, :w, :h

  # Multipliers for transforming coordinates into other octants
  @@mult = [
            [1,  0,  0, -1, -1,  0,  0,  1],
            [0,  1, -1,  0,  0, -1,  1,  0],
            [0,  1,  1,  0,  0, -1, -1,  0],
            [1,  0,  0,  1, -1,  0,  0, -1],
         ]

  def initialize(entities)
    @w = 80
    @h = 40
    @tiles = {}
    @visible = []
    @entities =entities
  end

  def calculate_fov(x, y)
    @tiles.each_key do |t|
      tx = @tiles[t].x
      ty = @tiles[t].y

      if Math.sqrt((x-tx)**2 + (y-ty)**2) <= 160
        @tiles[t].light
        @tiles[t].visited = true
      else
        @tiles[t].dark
      end
    end
  end


  # Determines which co-ordinates on a 2D grid are visible
  # from a particular co-ordinate.
  # start_x, start_y: center of view
  # radius: how far field of view extends
  def do_fov(start_x, start_y, radius=10)
    visible = []
    light(start_x, start_y)

    8.times do |oct|
        cast_light start_x, start_y, 1, 1.0, 0.0, radius,
            @@mult[0][oct],@@mult[1][oct],
            @@mult[2][oct], @@mult[3][oct], 0
    end
  end

  def cast_light(cx, cy, row, light_start, light_end, radius, xx, xy, yx, yy, id)
    return if light_start < light_end
    radius_sq = radius * radius
    (row..radius).each do |j| # .. is inclusive
        dx, dy = -j - 1, -j
        blocked = false
        while dx <= 0
            dx += 1
            # Translate the dx, dy co-ordinates into map co-ordinates
            mx, my = cx + dx * xx + dy * xy, cy + dx * yx + dy * yy
            # l_slope and r_slope store the slopes of the left and right
            # extremities of the square we're considering:
            l_slope, r_slope = (dx-0.5)/(dy+0.5), (dx+0.5)/(dy-0.5)
            if light_start < r_slope
                next
            elsif light_end > l_slope
                break
            else
                # Our light beam is touching this square; light it
                if (dx*dx + dy*dy) < radius_sq
                  light(mx,my)
                end

                if blocked
                    # We've scanning a row of blocked squares
                    if vision_blocked?(mx, my)
                        new_start = r_slope
                        next
                    else
                        blocked = false
                        light_start = new_start
                    end
                else
                    if vision_blocked?(mx, my) and j < radius
                        # This is a blocking square, start a child scan
                        blocked = true
                        cast_light(cx, cy, j+1, light_start, l_slope,
                            radius, xx, xy, yx, yy, id+1)
                        new_start = r_slope
                    end
                end
            end
        end # while dx <= 0
        break if blocked
    end # (row..radius+1).each
  end


  def in_bounds(x,y)
    (0 <= x  and x <= @w) and (0 <= y and y < @h)
  end

  def vision_blocked?(x,y)
    (not in_bounds(x,y)) or (not@tiles.key?([x,y])) or @tiles[[x,y]].blocks_vision
  end

  def light(x,y)
    @visible << [x,y]
    if in_bounds(x, y) and @tiles.key?([x, y])
      @tiles[[x, y]].visited = true
      @tiles[[x, y]].light
    end
  end


  def valid_move(x,y)
    x = x
    y = y
    (in_bounds(x,y) and (@tiles.key?([x,y]) and (not @tiles[[x,y]].blocks_movement)))
  end

  def render()
    out = []
    @tiles.each_key do |t|
      if @tiles[t].visited
        out << @tiles[t]
      end
    end
    @entities.each do |e|
      if @visible.include?([e.pos_x, e.pos_y])
        out << @entities
      end
    end
    out
  end
end
