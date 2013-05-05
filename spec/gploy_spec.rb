require 'spec_helper'
require 'gploy'

describe Gploy do
  
  let (:ssh_connection) { mock("SSH Connection") }
  before (:each) do
    Net::SSH.stub(:start) { ssh_connection }
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
  
  
  it "test bin" do
    gploy = Gploy::Configure.new
    message = "invalid command. Valid commands are [\"help\", \"deploy:setup\", \"deploy:tasks\"]."
    expect { gploy.run("teste") }.to raise_error(ArgumentError, message)
  end
  
  it "should execute tasks" do
    new_release = Time.now.to_s.gsub(/\W/, '')
    ssh_connection.should_receive(:exec!).ordered.with("cd /var/www/apps/my_app/#{new_release} && /root/.rbenv/versions/1.9.3-p194/bin/rake RAILS_ENV=production rake db:migrate")
    gploy = Gploy::Configure.new
    gploy.run("deploy:tasks")
    
    
    
  end
  
end