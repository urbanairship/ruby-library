unless Hash.method_defined?(:compact)
  class Hash
    def compact
      keep_if { |_, value| !value.nil? }
    end
  end
end
