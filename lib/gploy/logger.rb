module Gploy
  module Logger 
    def log(msg) 
     a = Time.now.strftime('%Y-%m-%d %H:%M:%S')
     $stderr.puts(a + " " + msg)
    end
  end
end