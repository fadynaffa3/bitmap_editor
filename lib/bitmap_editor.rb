require_relative 'validation_error'

class BitmapEditor
  COMMANDS = { I: { name: 'create',          length: 3 },
               C: { name: 'clear',           length: 1 },
               L: { name: 'colour',          length: 4 },
               V: { name: 'draw_vertical',   length: 5 },
               H: { name: 'draw_horizontal', length: 5 },
               S: { name: 'show',            length: 1 } }.freeze

  def run(file_path)
    validate_file!(file_path)
    File.open(file_path, 'r').each do |line|
      command = line.split(' ')
      method  = COMMANDS[command[0].to_sym]
      validate_command!(method, command)
      send(method[:name], command)
    end
  rescue ValidationError => e
    puts e
  end

  private

  def create(command)
    m = command[1].to_i
    n = command[2].to_i
    validate_boundaries!(n, m)
    @image = Array.new(n) { Array.new(m, 'O') }
  end

  def show(_command)
    @image.each do |r|
      puts r.each { |p| p }.join(' ')
    end
  end

  def clear(_command)
    @image = Array.new(@image.length) { Array.new(@image[0].length, 'O') }
  end

  def colour(command)
    colour = command[3]
    validate_colour!(colour)
    coordinates = array_coordinates(command[1], command[2])
    @image[coordinates[1]][coordinates[0]] = colour
  end

  def draw_vertical(command)
    colour_changer(command[2], command[3], command[1], command[4], 'V')
  end

  def draw_horizontal(command)
    colour_changer(command[1], command[2], command[3], command[4], 'H')
  end

  def colour_changer(start, finish, y, colour, dir)
    start  = start.to_i - 1
    finish = finish.to_i - 1
    y      = y.to_i - 1
    validate_colour!(colour)
    raise ValidationError, 'start greater than finish' if start > finish
    (start..finish).each do |x|
      dir == 'V' ? @image[x][y] = colour : @image[y][x] = colour
    end
  end

  def array_coordinates(x, y)
    x = x.to_i
    y = y.to_i
    validate_boundaries!(x, y)
    [x - 1, y - 1]
  end

  def validate_colour!(colour)
    raise ValidationError, 'invalid colour' unless ('A'..'Z').cover?(colour)
  end

  def validate_boundaries!(n, m)
    raise ValidationError, 'OutOfBound' if n > 250 || m > 250
  end

  def validate_file!(file_path)
    return unless file_path.nil? || !File.exist?(file_path)
    raise ValidationError, 'please provide correct file'
  end

  def validate_command!(method, command)
    raise ValidationError if method.nil?
    raise ValidationError unless method[:length] == command.length

    raise ValidationError, 'There is no image to colour' if method == method[:I] && @image.nil?
  end
end
