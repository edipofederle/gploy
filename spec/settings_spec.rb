require 'spec_helper'
require 'gploy'

describe Settings do 
  
  it "should read server configs" do
    Settings.load!("spec/config/gploy.yml")
    Settings.deploy[:url].should eq "localhost"
    Settings.deploy[:password].should eq "secret" 
    Settings.deploy[:app_name].should eq "my_app"
    Settings.deploy[:repo].should eq "https://github.com/edipofederle/blog.git"
    Settings.deploy[:path].should eq "/var/www/apps"   
    Settings.deploy[:number_releases].should eq 3
  end
  
  it "should read tasks configs" do
   Settings.load!("spec/config/gploy.yml") 
   Settings.tasks[:dbmigrate].should eq "RAILS_ENV=production rake db:migrate"
  end
end