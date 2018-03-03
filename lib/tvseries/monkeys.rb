class String
  def to_class
    self.split('::').inject(Object) do |mod, class_name|
      mod.const_get(class_name)
    end
    # TVSeries::Meta.class_from_string(self)
  end
end
