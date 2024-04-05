require_relative '../lib/frank'

args = ARGV

action = args.shift
g_type = args.shift if action == 'g'
name = args.shift

case action
when 'n'
  Frank::Actions::new name
when 'g'
  case g_type
  when 'model'
    Frank::Actions::generate_model name, args
  else
    Frank::Actions::generate_controller name
  end
end
