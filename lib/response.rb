class Urbanairship::Response < Hash
  
  def initialize(response)
    @response = response
    if @response
      if success? && !body.empty?
        json = JSON.parse(body).first
        json.keys.each{|k| self[k] = json[k]}
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

end
