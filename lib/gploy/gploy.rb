module Gploy
  
  class Configure
    
    include Remote
    def initialize
      conf = Reader.new("spec/gploy.yml")
      @remote = remote_command(conf.url, conf.user, conf.password)
    end
    
    def run(command)
      validate_command(command)      
    
      if command == "deploy:setup"
        $stdout.puts "Configuring server..."
        @remote.exec!("mkdir test")
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