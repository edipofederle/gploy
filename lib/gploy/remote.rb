require 'net/ssh'

module Gploy
  module Remote
   def remote_command(host, user, password)
     Net::SSH.start(host, user, :password => password)
   end
  end
end