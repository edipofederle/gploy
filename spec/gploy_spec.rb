require 'spec_helper'
require 'gploy'

describe Gploy do
  
  let (:ssh_connection) { mock("SSH Connection") }
  before (:each) do
    Net::SSH.stub(:start) { ssh_connection }
    @reader = Reader.new("lib/gploy/gploy.yml")
    Reader.stub(:new).with("config/gploy.yml").and_return(@reader)
  end
  
  it 'should setup server side' do
    File.stub(:exists?).with("config/gploy.yml").and_return(true)
    new_release = Time.now.to_s.gsub(/\W/, '')

    ssh_connection.should_receive(:exec!).ordered.with("cd /var/www/apps && mkdir my_app && cd /var/www/apps/my_app && mkdir #{new_release}")
    ssh_connection.should_receive(:exec!).ordered.with("cd /var/www/apps/my_app && git clone https://github.com/edipofederle/blog.git #{new_release}")
    ssh_connection.should_receive(:exec!).ordered.with("cd /var/www/apps/my_app && ln -s #{new_release}/public/ current")
    gploy = Gploy::Configure.new
    out = capture_stdout{gploy.run("deploy:setup")}
  end
  
  it'should raise TaskFileNotFound' do
    gploy = Gploy::Configure.new
    expect {gploy.run("deploy:tasks") }.to raise_error(TaskFileNotFound, "File with tasks not found. The file should be inside config folder with name talks")
  end  
  
  it 'should read and execute tasks' do
    File.stub(:exists?).with("config/gploy.yml").and_return(true)
    File.stub(:exists?).with("config/tasks").and_return(true)
    File.stub(:readlines).with("config/tasks").and_return { ["RAILS_ENV=production rake db:migrate"] }
    ssh_connection.should_receive(:exec!).ordered.with("cd /var/www/apps/my_app && RAILS_ENV=production rake db:migrate")
    gploy = Gploy::Configure.new
    gploy.run("deploy:tasks")
  end
  
  it "test bin" do
    gploy = Gploy::Configure.new
    message = "invalid command. Valid commands are [\"help\", \"deploy:setup\", \"deploy:tasks\"]."
    expect { gploy.run("teste") }.to raise_error(ArgumentError, message)
  end
  
end