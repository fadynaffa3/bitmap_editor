module Validator
  def validate_size!(constant, finish, direction)
    valid = if direction == 'V'
              @image.length > finish && @image[0].length > constant
            else
              @image.length > constant && @image[0].length > finish
            end
    raise ValidationError, 'out of bound' unless valid
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
