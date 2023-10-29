require 'retry'
require 'nostr'

%w[core_ext].each do |folder|
  Dir[Rails.root.join('lib', folder, '**', '*.rb')].each { |f| require f }
end
