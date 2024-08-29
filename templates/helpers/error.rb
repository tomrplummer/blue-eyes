module Err
  class HaltError < StandardError
    attr_reader :error_type

    def initialize(error_type)
      @error_type = error_type
    end
  end

  class Error
    def initialize(type)
      @type = type
    end

    def ==(other)
      @type == other
    end

    def eql?(other)
      self == other
    end

    def hash
      @type.hash
    end
  end

  def self.access_denied
    Error.new :access_denied
  end

  def self.not_found
    Error.new :not_found
  end

  def self.invalid_password
    Error.new :invalid_password
  end

  def self.invalid_username
    Error.new :invalid_username
  end

  def self.username_in_use
    Error.new :username_in_use
  end

  def self.server_error
    Error.new :server_error
  end

  def set_handler(k, v)
    @handlers ||= {
      access_denied: -> { haml :access_denied },
      server_error: -> { haml :error }
    }
    @handlers[k] = v
  end

  def get_handler(k)
    @handlers[k]
  end

  def recover(type, http_status = 200, &block)
    @status = http_status
    if type.is_a? Array
      type.each do |t|
        set_handler(t, block)
      end
    else
      set_handler(type, block)
    end
  end

  def error_response(error)
    yield
    handle(error)
  end

  def handle(error)
    status @status
    error_handler = get_handler(error)
    error_handler ||= get_handler(:rest)
    return unless error_handler && error.is_a?(Error)

    response = error_handler.call
    throw :halt, response
  end
end
