require 'warden'
require 'bcrypt'
require 'logger'

# Warden::Manager.serialize_into_session(&:id)
# Warden::Manager.serialize_from_session { |id| User.find(id)}

Warden::Strategies.add(:password) do |params = nil|
  def valid?
    params["username"] && params["password"]
    true
  end

  def authenticate!
    # puts "from auth: #{request.path_info}"
    # session[:return_to] = request.path_info unless request.path_info == "/login" || request.path_info == "/unauthenticated"
    user = User.find(:username => params["username"])
    if session[:current_user]
      success!(user)
    end
    if user && BCrypt::Password.new(user[:password_hash]) == params["password"]
      session[:current_user] = {
        :username => user[:username],
        :full_name => user[:full_name],
        :id => user[:id]
      }
      success!(user)
    else
      fail!("Could not log in")
    end
  end
end