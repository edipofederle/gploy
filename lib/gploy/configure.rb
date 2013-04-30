module Gploy
  
  class Configure
    
   include Helpers
        
    def initialize
      begin
        unless File.exists?("config/gploy.yml")
          post_commands_server
          $stdout.puts "Add this to your gploy.conf file\nExting..."
        else
          @conf = Reader.new("config/gploy.yml")
          @remote = remote_command(@conf.url, @conf.user, @conf.password)
        end
      rescue
        $stderr.puts "WARNING: I Could not read configuration file."
        $stderr.puts "\t" + e.to_s
      end
    end
    
    def run(command)
      validate_command(command)      
    
      if command == "deploy:setup"
        $stdout.puts "Configuring server..."
        new_release = Time.now.to_s.gsub(/\W/, '')
        @remote.exec!("cd #{@conf.path} && mkdir #{@conf.app_name} && cd #{@conf.path}/#{@conf.app_name} && mkdir #{new_release}")
        @remote.exec!("cd #{@conf.path}/#{@conf.app_name} && git clone #{@conf.repo} #{new_release}")
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