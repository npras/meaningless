class Sample

  def initialize a:, b:, c: 'cc'
    key_values = method(__method__)
      .parameters
      .map do |_, name|
      instance_variable_set :"@#{name}", binding.local_variable_get(name)
      [name, binding.local_variable_get(name)]
    end
    h = Hash[key_values]
    p key_values
  end

end


if __FILE__ == $0
  s = Sample.new(a: 'aa', b: 'bb')
  p s.instance_variable_get(:@a)
end
