require File.dirname(__FILE__) + '/helper'

class ConfigureTest < Test::Unit::TestCase
  
  def  setup
    @path = File.join(Dir.pwd, '_config.yml')
  end
  
  def testLoadFileConfire
		connection = Gploy::Configure.new
    mock(YAML).load_file(@path){ Hash.new}
    mock($stderr).puts("Configuration ok from #{@path}")
    connection.read_config_file(@path)
  end
  
  def testBadConfi
		connection = Gploy::Configure.new
    mock(YAML).load_file(@path) { raise "No such file or directory - #{@path}" }
    mock($stderr).puts("WARNING: I Could not read configuration file.")
    mock($stderr).puts("\tNo such file or directory - #{@path}")
    connection.read_config_file(@path)
  end

end