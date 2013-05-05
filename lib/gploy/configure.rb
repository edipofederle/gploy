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
        
        update_syn_link(new_release)
        update_number_of_deployments
      end
      
      if command == "deploy:tasks"
        unless File.exists?("config/tasks")
          raise TaskFileNotFound, "File with tasks not found. The file should be inside config folder with name talks"
        else
         File.readlines('config/tasks').each do |line|
          execute_task(line)
         end
        end
      end
    end
    
    def execute_task(command)
      @remote.exec!("cd #{@conf.path}/#{@conf.app_name} && #{command}")
    end
    
    def update_syn_link(new_release)
     @remote.exec!("cd #{@conf.path}/#{@conf.app_name} && ln -s #{new_release}/public/ current")
    end
    
    def update_number_of_deployments
      
      unless File.exist?(".deploys")
        File.write(".deploys", "")
      end
      
      count = File.foreach(".deploys").inject(0) {|c, line| c+1}
      puts "Number of releases: #{count}"
      
      if count == @conf.number_releases
        puts "Remove all releases...."
        File.open(".deploys", 'w') { |file| file.truncate(0)}  
        @remote.exec!("cd #{@conf.path}/#{@conf.app_name} &&  rm -rf *")
      end
      
      File.open(".deploys", 'a') { |file| file.puts("1") }
    end
  
    def validate_command(command)
      commands = %w[help deploy:setup deploy:tasks]
      unless commands.include?(command)
        raise ArgumentError, "invalid command. Valid commands are #{commands}."
      end
    end
  
  end
end