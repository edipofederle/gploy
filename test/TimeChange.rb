class TimeChange
  # author: Gary S. Weaver
  # from: http://stufftohelpyouout.blogspot.com/2009/09/how-to-unmock-in-mocha-and-temporarily.html
  # see also: http://stackoverflow.com/questions/1215245/ruby-unit-testing-how-to-fake-time-now
  
  def self.to(time)
    Time.stubs(:now).returns(time)
  end

  def self.back_to_now
    UnMocker.unmock(Time, 'now')
  end
end

