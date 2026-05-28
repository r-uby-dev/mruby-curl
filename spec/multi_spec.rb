# frozen_string_literal: true
describe "Curl::Multi" do
  describe "object creation" do
    it "creates a new Multi instance" do
      expect(Curl::Multi.new).must_be_instance_of Curl::Multi
    end
  end

  describe "instance methods" do
    before do
      @multi = Curl::Multi.new
    end

    it "responds to send" do
      expect(@multi).must_respond_to :send
    end

    it "responds to perform" do
      expect(@multi).must_respond_to :perform
    end

    it "responds to done?" do
      expect(@multi).must_respond_to :done?
    end

    it "responds to running" do
      expect(@multi).must_respond_to :running
    end

    it "responds to timeout" do
      expect(@multi).must_respond_to :timeout
    end

    it "responds to timeout=" do
      expect(@multi).must_respond_to :timeout=
    end

    it "responds to timeout_ms" do
      expect(@multi).must_respond_to :timeout_ms
    end

    it "responds to timeout_ms=" do
      expect(@multi).must_respond_to :timeout_ms=
    end

    it "is done when no requests are queued" do
      expect(@multi.done?).must_equal true
    end

    it "reports zero running when idle" do
      expect(@multi.running).must_equal 0
    end
  end

  describe "live HTTP requests" do
    before do
      @multi = Curl::Multi.new
      @multi.timeout_ms = 10_000
    end

    it "performs a single GET request" do
      req = HTTP::Request.new
      req.method = "GET"
      curl_req = @multi.send("https://google.com", req)
      while !@multi.done?
        @multi.perform
      end
      expect(curl_req.done?).must_equal true
      expect(curl_req.error).must_be_nil
    end

    it "returns a parsed response" do
      req = HTTP::Request.new
      req.method = "GET"
      curl_req = @multi.send("https://google.com", req)
      while !@multi.done?
        @multi.perform
      end
      response = curl_req.response
      expect(response).wont_be_nil
      expect(response.status_code).must_equal 200
    end

    it "performs concurrent GET requests" do
      req1 = HTTP::Request.new
      req1.method = "GET"
      req2 = HTTP::Request.new
      req2.method = "GET"
      r1 = @multi.send("https://google.com", req1)
      r2 = @multi.send("https://google.com", req2)
      while !@multi.done?
        @multi.perform
      end
      expect(r1.done?).must_equal true
      expect(r2.done?).must_equal true
      expect(r1.error).must_be_nil
      expect(r2.error).must_be_nil
    end

    it "tracks running count during requests" do
      req = HTTP::Request.new
      req.method = "GET"
      @multi.send("https://google.com", req)
      expect(@multi.running).must_equal 1
      while !@multi.done?
        @multi.perform
      end
      expect(@multi.running).must_equal 0
    end
  end
end

describe "Curl::Multi::Request" do
  it "defines the Request class" do
    expect(Curl::Multi::Request).must_be_instance_of Class
  end

  describe "live request lifecycle" do
    before do
      @multi = Curl::Multi.new
      @multi.timeout_ms = 10_000
    end

    it "transitions from not done to done" do
      req_obj = HTTP::Request.new
      req_obj.method = "GET"
      curl_req = @multi.send("https://google.com", req_obj)
      expect(curl_req.done?).must_equal false
      while !@multi.done?
        @multi.perform
      end
      expect(curl_req.done?).must_equal true
    end

    it "returns error on unreachable host" do
      req_obj = HTTP::Request.new
      req_obj.method = "GET"
      @multi.timeout_ms = 1000
      curl_req = @multi.send("https://192.0.2.1/test", req_obj)
      while !@multi.done?
        @multi.perform
      end
      expect(curl_req.done?).must_equal true
      expect(curl_req.error).wont_be_nil
    end
  end
end
Minitest.run(ARGV) || exit(1)
