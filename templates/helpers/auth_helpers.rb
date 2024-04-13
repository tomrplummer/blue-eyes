module AuthHelpers
  def warden
    request.env['warden']
  end

  def logout
    unless current_user.nil?
      session.delete(:current_user)
    end
    warden.logout
  end

  def current_user
    session[:current_user]
  end

  def authenticate!
    warden.authenticate!
  end
end