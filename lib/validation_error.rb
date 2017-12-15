class ValidationError < StandardError
  def initialize(msg = 'Invalid Command :(')
    super
  end
end
