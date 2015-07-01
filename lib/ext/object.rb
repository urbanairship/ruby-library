class Object
  def try(method)
    send method if respond_to? method
  end
end
