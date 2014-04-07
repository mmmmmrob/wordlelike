require 'wordlelike/version'
require 'RMagick'
include Magick

module Wordlelike

  class Cloud


    def self.draw(filename, counted_words)

      puts counted_words

      counted_words.sort_by! { |word, count| count }
      counted_words.reverse!
      max_count = counted_words.map { |word, count| count }.max
      min_count = counted_words.map { |word, count| count }.min

      canvas = Magick::ImageList.new
      width, height = 1280, 1280
      canvas.new_image(width, height, Magick::HatchFill.new('white', 'gray90'))

      placements = []
      counted_words.each do |word, count|
        puts "Processing #{word} as worth #{count}"
        percentage_size = ((count - min_count) / (max_count - min_count).to_f)
        puts "Size: #{percentage_size}"
        text = Magick::Draw.new
        text.font_family = 'helvetica'
        text.pointsize = (192 * percentage_size).round + 36
        #text.gravity = Magick::CenterGravity
        #text.translate(width/2, height/2)
        metrics = text.get_type_metrics(canvas, word)
        puts metrics
        tw, th = metrics.width, metrics.height
        x_offset = width/2 - tw/2
        y_offset = height/2 - th/2
        r, theta = 0, 0
        x1 = metrics.bounds.x1 + x_offset
        y1 = metrics.bounds.y1 + (metrics.height - metrics.ascent) + y_offset
        x2 = x1 + metrics.width
        y2 = y1 + metrics.ascent - metrics.descent
        while intersects(placements, x1, y1, x2, y2)
          add_x, add_y = p2c(r += 0.01, theta += 1)
          x1 += add_x
          y1 += add_y
          x2 += add_x
          y2 += add_y
          puts "#{word} is intersecting, moving to #{x1}, #{y1}, #{x2}, #{y2}"
        end
        placements << [x1, y1, x2, y2]
        puts "Storing: #{[x1, y1, x2, y2]}"
        text.annotate(canvas, 0, 0, x1, y2 + metrics.descent, word) { self.fill = 'gray80' }
        rect = Magick::Draw.new
        rect.fill_opacity(0.1)
        rect.rectangle(x1, y1, x2, y2)
        rect.draw(canvas)
        dot = Magick::Draw.new
        dot.fill_opacity(0.2)
        dot.ellipse(x1, y1, 2, 2, 0, 360)
        dot.draw(canvas)
      end

      canvas.write(filename)

    end

    def self.intersects(placements, r1x1, r1y1, r1x2, r1y2)
      placements.each do |r2x1, r2y1, r2x2, r2y2|
        return true if (r1x2 >= r2x1) && (r1y2 >= r2y1) && (r1x1 <= r2x2) && (r1y1 <= r2y2)
      end
      false
    end

    def self.p2c(r, theta)
      [r * Math.cos(theta), r * Math.sin(theta)]
    end

  end
end