class Base
  def self.before(x)
    puts x
  end
end

class A < Base
  before(:aa)
end

class B < A
  before(:bb)
  before(:BB)
end
