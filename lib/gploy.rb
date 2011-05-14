
$:.unshift File.dirname(__FILE__) # For use/testing when no gem is installedr"

# Require all of the Ruby files in the given directory.
#
# path - The String relative path from here to the directory.
#
# Returns nothing.
def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end

# rubygems
require 'rubygems'

require "rubygems"
require 'net/ssh'
require 'fileutils'
require 'yaml'
require 'net/sftp'

require 'gploy/logger'
require 'gploy/helpers'
require 'gploy/configure'

module Gploy
  VERSION = '0.1.6'
end
