module Error
  def set_handler(k, v)
    @handlers ||= {}
    @handlers[k] = v
  end

  def get_handler(k)
    @handlers[k]
  end

  def self.access_denied
    :access_denied
  end

  def self.not_found
    :not_found
  end

  def self.invalid_password
    :invalid_password
  end

  def self.invalid_username
    :invalid_username
  end

  def self.username_in_use
    :username_in_use
  end

  def self.server_error
    :server_error
  end

  def recover(type, &block)
    if type.is_a? Array
      type.each do |t|
        set_handler(t, block)
      end
    else
      set_handler(type,block)
    end
  end

  def error_response(error, &block)
    yield
    handle(error)
  end

  def handle(error)
    error_handler = get_handler(error)
    error_handler = get_handler(:rest) unless error_handler
    error_handler.call if error_handler
  end
end
