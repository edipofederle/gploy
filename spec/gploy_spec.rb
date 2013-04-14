require 'spec_helper'
require 'gploy'

describe Gploy do
  
 let (:ssh_connection) { mock("SSH Connection") }
  before (:each) do
    Net::SSH.stub(:start) { ssh_connection }
  end
  
  it 'should test command' do
    ssh_connection.should_receive(:exec!).ordered.with("mkdir test")
    gploy = Gploy::Configure.new
    out = capture_stdout{gploy.run("deploy:setup")}
    out.should eq("Configuring server...\n")
  end

  
  it "test bin" do
    gploy = Gploy::Configure.new
    message = "invalid command. Valid commands are [\"help\", \"deploy:setup\", \"deploy\"]."
    expect { gploy.run("teste") }.to raise_error(ArgumentError, message)
  end

  
end