class String
  def to_class
    split('::').inject(Object) do |mod, class_name|
      mod.const_get(class_name)
    end
  end
end
