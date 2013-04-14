$:.unshift File.dirname(__FILE__) # For use/testing when no gem is installedr"

def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end


require "rubygems"
require 'net/ssh'
require 'fileutils'
require 'yaml'
require 'net/sftp'

require 'gploy/reader'
require 'gploy/remote'
require 'gploy/gploy'
require 'gploy/helpers'
require 'gploy/version'