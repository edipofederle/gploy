module Gploy
   
  class Configure
    
   include Helpers
        
    def initialize
      
      begin
        unless File.exists?("config/gploy.yml")
          post_commands_server
          $stdout.puts "Add this to your gploy.conf file\nExting..."
        else
          Settings.load!("config/gploy.yml")
          puts @remote = remote_command(Settings.deploy[:url], Settings.deploy[:user], Settings.deploy[:password])
        end
      end
    end
    
    def run(command)
      validate_command(command)      
    
      if command == "deploy:setup"
        $stdout.puts "Configuring server..."
        new_release = Time.now.to_s.gsub(/\W/, '')
       puts  @remote.exec!("cd #{Settings.deploy[:path]} && mkdir #{Settings.deploy[:app_name]} && cd #{Settings.deploy[:path]}/#{Settings.deploy[:app_name]} && mkdir #{new_release}")
        puts @remote.exec!("cd #{Settings.deploy[:path]}/#{Settings.deploy[:app_name]} && git clone #{Settings.deploy[:repo]} #{new_release}")
        
        update_syn_link(new_release)
        update_number_of_deployments(new_release)
      end
      
      if command == "deploy:tasks"
        Settings.tasks.each do |command|   
          unless Settings.ruby_env == nil
            execute_task(command[1].gsub("rake" Settings.ruby_env[:rake]))
          end
        end
      end
    end
    
    def execute_task(line)
      lines = IO.readlines(".deploys")
      puts "cd #{Settings.deploy[:path]}/#{Settings.deploy[:app_name]}/#{lines.last.tr("\n","")} && #{line}"
      puts @remote.exec!("cd #{Settings.deploy[:path]}/#{Settings.deploy[:app_name]}/#{lines.last.tr("\n","")} && #{line}")
    end
    
    def update_syn_link(new_release)
     @remote.exec!("cd #{Settings.deploy[:path]}/#{Settings.deploy[:app_name]} && ln -s #{new_release}/public/ current")
    end
    
    def update_number_of_deployments(new_release)
      
      unless File.exist?(".deploys")
        File.write(".deploys", "")
      end
      
      count = File.foreach(".deploys").inject(0) {|c, line| c+1}
      puts "Number of releases: #{count}"
      
      if count == Settings.deploy[:number_releases]
        puts "Remove all releases...."
        File.open(".deploys", 'w') { |file| file.truncate(0)}  
        @remote.exec!("cd #{Settings.deploy[:path]}/#{Settings.deploy[:app_name]} &&  rm -rf *")
      end
      
      File.open(".deploys", 'a') { |file| file.puts(new_release) }
    end
  
    def validate_command(command)
      commands = %w[help deploy:setup deploy:tasks]
      unless commands.include?(command)
        raise ArgumentError, "invalid command. Valid commands are #{commands}."
      end
    end
  
  end
end