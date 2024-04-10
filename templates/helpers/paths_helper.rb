require_relative '../plugins/route_builder'
require_relative '../plugins/paths'

module PathsHelper
  extend RouteBuilder
  include Paths
  def self.run
    # put resources here
    resources :posts
    resources :comments, :posts
    resources :likes, :posts, :comments
  end
end