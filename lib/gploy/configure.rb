module Gploy
  
  class Configure
    
   include Helpers
        
    def initialize
      unless File.exists?("config/gploy.yml")
        post_commands_server
        exit(1)
      else
        @conf = Reader.new("config/gploy.yml")
        @remote = remote_command(@conf.url, @conf.user, @conf.password)
      end
    end
    
    def run(command)
      validate_command(command)      
    
      if command == "deploy:setup"
        $stdout.puts "Add this to your gploy.conf file"
        $stdout.puts "Configuring server..."
        @remote.exec!("cd #{@conf.path} && mkdir #{@conf.app_name}")
      end
      
      if command == "deploy"
        $stdout.puts "Cloning Repo into Server"
        @remote.exec!("cd #{@conf.path}/#{@conf.app_name} && git clone #{@conf.repo}")
      end
    
    end
  
    def validate_command(command)
      commands = %w[help deploy:setup deploy]
      unless commands.include?(command)
        raise ArgumentError, "invalid command. Valid commands are #{commands}."
      end
    end
  
  end

end