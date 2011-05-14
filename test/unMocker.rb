class UnMocker
  # author: Gary S. Weaver
  # from: http://stufftohelpyouout.blogspot.com/2009/09/how-to-unmock-in-mocha-and-temporarily.html
  # based on solution from Jacob in http://szeryf.wordpress.com/2007/11/09/unstubbing-methods-in-mocha/

  def self.unmock(class_or_instance, method_name)
    Mocha::Mockery.instance.stubba.stubba_methods.each do |meth|
      if meth.stubbee == class_or_instance && meth.method == method_name
        meth.unstub
      end
    end
  end
end