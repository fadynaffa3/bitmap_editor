require_relative 'validation_error'

class BitmapEditor
  COMMANDS = { I: { name: 'create',          length: 3 },
               C: { name: 'clear',           length: 1 },
               L: { name: 'colour',          length: 4 },
               V: { name: 'draw_vertical',   length: 5 },
               H: { name: 'draw_horizontal', length: 5 },
               S: { name: 'show',            length: 1 } }.freeze

  MAX_ROWS    = 250
  MAX_COLUMNS = 250

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
    raise ValidationError, 'out of bound' if n > MAX_ROWS || m > MAX_COLUMNS
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
    raise ValidationError, 'out of bound' if @image[coordinates[1]].nil? || @image[coordinates[0]].nil?
    @image[coordinates[1]][coordinates[0]] = colour
  end

  def draw_vertical(command)
    # command: V X Y1 Y2 C
    segment_drawer(command[2], command[3], command[1], command[4], 'V')
  end

  def draw_horizontal(command)
    # command: H X1 X2 Y C
    segment_drawer(command[1], command[2], command[3], command[4], 'H')
  end

  def segment_drawer(start, finish, constant, colour, dir)
    start    = start.to_i - 1
    finish   = finish.to_i - 1
    constant = constant.to_i - 1
    validate_colour!(colour)
    raise ValidationError, 'start greater than finish' if start > finish
    validate_size!(constant, finish, dir)
    (start..finish).each do |px|
      dir == 'V' ? @image[px][constant] = colour : @image[constant][px] = colour
    end
  end

  def validate_size!(constant, finish, direction)
    valid = if direction == 'V'
              @image.length > finish && @image[0].length > constant
            else
              @image.length > constant && @image[0].length > finish
            end
    raise ValidationError, 'out of bound' unless valid
  end

  def array_coordinates(x, y)
    x = x.to_i
    y = y.to_i
    [x - 1, y - 1]
  end

  def validate_colour!(colour)
    raise ValidationError, 'invalid colour' unless ('A'..'Z').cover?(colour)
  end

  def validate_file!(file_path)
    return unless file_path.nil? || !File.exist?(file_path)
    raise ValidationError, 'please provide correct file'
  end

  def validate_command!(method, command)
    raise ValidationError if method.nil?
    raise ValidationError unless method[:length] == command.length

    raise ValidationError, 'There is no image' if method[:name] != 'create' && @image.nil?
  end
end
