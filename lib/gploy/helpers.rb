require 'net/ssh'

module Gploy
  module Helpers
   def remote_command(host, user, password)
     Net::SSH.start(host, user, :password => password)
   end
   
   def run_local(command)
      Kernel.system command
    end
    
    def post_commands_server
      commands = <<CMD
        config:
        url: <user_server>
        user: <userbae>
        password: <password>
        app_name: <app_name>
        origin: <git origin>
CMD
        puts commands
    end
    
  end
end