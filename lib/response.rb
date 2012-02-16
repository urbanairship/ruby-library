class Urbanairship::Response < Hash
  
  def initialize(response)
    @response = response
    if @response
      if success? && !body.empty?
        parse_body(body)
      end
    else
      @timeout = true
    end
  end

  def code
    @response.code
  end

  def body
    @response.body
  end

  def success?
    (code =~ /^2/) == 0 && !@timeout
  end

  def request_timeout?
    @timeout
  end

  private

  def parse_body(body)
    json = JSON.parse(body)
    if json.class == Array
      json.each_with_index do |item, index| 
        self[index] = item
      end
    else
      json.keys.each{|k| self[k] = json[k]}
    end
  end
end
