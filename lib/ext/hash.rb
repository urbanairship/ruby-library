class Hash
  def compact
    keep_if { |_, value| !value.nil? }
  end
end
