require_relative './blue_eyes/tmpl'
require_relative './blue_eyes/version'
require_relative './blue_eyes/txt'
require_relative './blue_eyes/fget'
require_relative './blue_eyes/actions'
require_relative './blue_eyes/paths'
require_relative './blue_eyes/bndl'
require_relative './blue_eyes/routes'

module BlueEyes
  include Tmpl
  include TXT
  include Fget
  include Actions
  include Paths
  include Bndl
  include Routes
end
