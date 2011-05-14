require 'rubygems'
require 'test/unit'
require 'mocha'
require 'shoulda'
require 'rr'
require File.join(File.dirname(__FILE__), *%w[.. lib gploy])

include Gploy
class Test::Unit::TestCase
    include RR::Adapters::TestUnit
  def dest_dir(*subdirs)
    File.join(File.dirname(__FILE__), 'dest', *subdirs)
  end

  def source_dir(*subdirs)
    File.join(File.dirname(__FILE__), 'source', *subdirs)
  end

  def clear_dest
    FileUtils.rm_rf(dest_dir)
  end
  
  
end