require File.dirname(__FILE__) + '/helper'
class ConfigureTest < Test::Unit::TestCase
  
  def testeOne
    assert(true)
  end
  
  def	setup
	  
	  mockRespinse = mock("Net::SSH")
	  ssh = mock("Net::SSH")

		@connection = Gploy::Configure.new
	 
	  @connection.expects(:start).once.returns(@ssh)
	  @c = @connection.remote
	  
	   @path = File.join(Dir.pwd, '_config.yml')

	  @url = "server_name"
    @user = "user_name"
    @password = "user_senha"
    @app_name = "fake_project"
    @origin = "production"
	end
	
	
	def testShouldReturnGemVersion
	  assert_not_nil(!nil,Gploy::Configure::VERSION)
	  assert_equal("0.1.6", Gploy::VERSION)
	end
	def testShouldHaveALogPath
	  assert_equal("./log/gploylog.log", Gploy::Configure::LOG_PATH);
	end
	
	def	testCreateDirLogIfDontExist
	  dir_log = @connection.check_if_dir_log_exists
	  assert(dir_log, "Directory Log not found")
	end
	
	def	testIfSomeDirectoryExist
	  no_dir = "fakedir"
	  assert_equal(false, @connection.dirExists?(no_dir))
	  assert_equal(true, @connection.dirExists?("log"))
	end	
	
	def	testOne
	  expect_command_local "chmod +x config/post-receive && scp config/post-receive #{@user}@#{@url}:repos/#{@app_name}.git/hooks/"
	  @connection.update_hook_into_server(@user, @url, @app_name)
	end
	
	def	testUploadPostReceiveFile
    expect_command_local "scp config/post-receive #{@user}@#{@url}:repos/#{@app_name}.git/hooks/"
    @connection.update_hook(@user, @url, @app_name)
	end
	
	def testIfExistPostReceiveFileIntoConfigFolder
	  @connection.create_hook_file
	  assert File.exists?(File.join("config",'post-receive'))
	end
	
	def testReturnPathPostReceive
	  assert_equal("config/post-receive", @connection.path)
	end
	
	def testIfExistCofigFile
	  @connection.create_file_and_direcotry_unless_exists("config", "config.yaml")
	  assert File.exists?(File.join("config",'config.yaml'))
	end
	
	def	testShouldReturnPathForHookFileIntoServer
	 assert_equal("~/repos/#{@name}.git/hooks/post-receive", @connection.path_hook(@name))
	end
	
	def	testShouldCreateSysLinkIntoServer
	  expect_command_remote "ln -s ~/rails_app/#{@app_name}/public ~/public_html/#{@app_name}"
	  @connection.sys_link(@app_name)
	end
	
	def testShouldDreateTmpDirIntoProjectServer
    expect_command_remote "cd rails_app/#{@app_name}/ && mkdir tmp"
    @connection.tmp_create(@app_name)
	end
	
	def	testShouldCreateAndInitializeRepoIntoServer
	  expect_command_remote "cd repos/ && mkdir nome.git && cd nome.git && git init --bare"
    @connection.create_repo("nome")
	end

	def testShouldAddGitRemoteInLocalProject
    expect_command_local "git remote add #{@origin} #{@user}@#{@url}:~/repos/#{@app_name}.git"
    @connection.add_remote(@url, @user, @app_name, @origin)
  end
	 
	def testShoulRunCloneIntoServer
	 # @logger.expects(:log).once.with(instance_of(String))
    expect_command_remote "git clone ~/repos/#{@app_name}.git ~/rails_app/#{@app_name}"
    @connection.clone(@app_name) 
  end
	 
	def testShouldRunCloneIntoServer2
    expect_command_remote "git clone repos/#{@app_name}.git ~/rails_app/#{@app_name}"
    @connection.clone_into_server(@app_name)
  end
	
	def testShouldRunPushMaster
	 # @logger.expects(:log).once.with(instance_of(String))
    expect_command_local "git checkout master && git push #{@origin} master"
    @connection.push_local(@origin)
  end
	
	def tesShouldNotRunMigrateTask
      @connection.migrate(@app_name)
  end
    
	def testShouldRestartServer
    expect_command_remote("cd rails_app/#{@app_name}/tmp && touch restart.txt")
    @connection.restart_server(@app_name)
  end

  #FIX THIS TEST
  def RtestShouldRunMigrateTask
	  FileUtils.remove_dir("db")
    #Dir.mkdir("db")
    FileUtils.touch("db/schema.rb")
    expect_command_remote "cd rails_app/#{@app_name}/ && rake db:migrate RAILS_ENV=production"
    @connection.migrate(@app_name)
  end
  
  def testLogMessage
   a = Time.stubs(:now).returns(Time.mktime(1970,1,1))
   mock($stderr).puts(Time.now.strftime('%Y-%m-%d %H:%M:%S') + " Hello")
   @connection.log("Hello")
  end

	def expect_command_local(command)
	  Kernel.expects(:system).with(command)
	end
	
	def expect_command_remote(command)
	  @c.expects(:exec!).with(command)
	end
end