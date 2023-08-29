require 'retry'
require 'nostr_override'

%w[core_ext].each do |folder|
  Dir[Rails.root.join('lib', folder, '**', '*.rb')].each { |f| require f }
end
