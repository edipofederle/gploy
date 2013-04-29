require 'spec_helper'
require 'gploy'

describe Reader do 
  
  it "should read configure file" do
    conf = Reader.new("spec/gploy.yml")
    conf.url.should eq("localhost")
    conf.user.should eq("root")
    conf.password.should eq("secret")
    conf.app_name.should eq("my_app")
    conf.branch.should eq("master")
    conf.path.should eq("/var/www/apps")
    conf.repo.should eq("https://github.com/edipofederle/blog.git")
  end
  
end