class Reader
  
  attr_accessor :url, :user, :password, :app_name, :branch, :path, :repo,
                :path_repo_server, :path_to_my_repo_in_server, :number_releases
  
  def initialize(path)
    config = read_config_file(path)
    @url       = config["config"]["url"]
    @user      = config["config"]["user"]
    @password  = config["config"]["password"]
    @app_name  = config["config"]["app_name"]
    @branch    = config["config"]["branch"]
    @repo      = config["config"]["repo"]
    @path      = config["config"]["path"]
    @path_repo_server      = config["config"]["path_repo_server"]
    @number_releases = config["config"]["number_releases"]
  end
  
  private 
  def read_config_file(path)
    begin
      config = YAML.load_file(path)
      raise "Invalid configuration - #{path}" if !config.is_a?(Hash)
      $stderr.puts "Configuration ok from #{path}"
    rescue => e
      $stderr.puts "WARNING: I Could not read configuration file."
      $stderr.puts "\t" + e.to_s
      config = {}
    end
    config
  end
  
  
end