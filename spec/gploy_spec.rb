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
    ssh_connection.should_receive(:exec!).ordered.with("cd /var/repo && mkdir my_app.git && cd my_app.git && git init --bare")
    gploy = Gploy::Configure.new
    out = capture_stdout{gploy.run("deploy:setup")}
    out.should eq("Configuring server...\n")
  end
  
  #it "should clone repo into server" do
  #ssh_connection.should_receive(:exec!).ordered.with("cd /var/www/apps/my_app && git clone https://github.com/edipofederle/blog.git")
  #gploy = Gploy::Configure.new
  #gploy.run("deploy")
  #end
  
  it "test bin" do
    gploy = Gploy::Configure.new
    message = "invalid command. Valid commands are [\"help\", \"deploy:setup\", \"deploy\"]."
    expect { gploy.run("teste") }.to raise_error(ArgumentError, message)
  end
  
end