module Urbanairship
  module Util
    module_function

    # @raise [ArgumentError] unless obj matches the pattern.
    def validate(obj, name, regex)
      fail ArgumentError, "#{obj} isn't a valid #{name}" unless obj =~ regex
    end

    # @return the datetime formatted as expected by the API
    def time_format(datetime)
      datetime.strftime('%Y-%m-%dT%H:%M:%S')
    end

  end
end
