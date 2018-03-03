class String
  def to_class
    split('::').inject(Object) do |mod, class_name|
      mod.const_get(class_name)
    end
  end

  def underscore_to_camelcase
    split('_').map { |part| part.capitalize }.join
  end

  def camelcase_to_underscore
    underscore = ''
    (0...self.length).each do |i|
      underscore += (self[i] >= 'a' && self[i] <= 'z' ? self[i] : "_#{self[i].downcase}")
    end
    underscore[1..-1]
  end
end
