# frozen_string_literal: true
describe "Curl" do
  describe "object creation" do
    it "creates a new Curl instance" do
      expect(Curl.new).must_be_instance_of Curl
    end

    it "creates independent instances" do
      c1 = Curl.new
      c2 = Curl.new
      expect(c1).wont_be_same_as c2
    end
  end

  describe "timeout configuration" do
    before do
      @curl = Curl.new
    end

    it "sets and gets timeout in seconds" do
      @curl.timeout = 30
      expect(@curl.timeout).must_equal 30
    end

    it "sets and gets timeout in milliseconds" do
      @curl.timeout_ms = 5000
      expect(@curl.timeout_ms).must_equal 5000
    end

    it "defaults timeout to nil" do
      expect(@curl.timeout).must_be_nil
    end

    it "defaults timeout_ms to nil" do
      expect(@curl.timeout_ms).must_be_nil
    end

    it "overrides timeout with timeout_ms" do
      @curl.timeout = 30
      @curl.timeout_ms = 1000
      expect(@curl.timeout_ms).must_equal 1000
    end

    it "sets and gets connect timeout in seconds" do
      @curl.connect_timeout = 10
      expect(@curl.connect_timeout).must_equal 10
    end

    it "sets and gets connect timeout in milliseconds" do
      @curl.connect_timeout_ms = 2500
      expect(@curl.connect_timeout_ms).must_equal 2500
    end

    it "sets and gets low speed limit" do
      @curl.low_speed_limit = 1
      expect(@curl.low_speed_limit).must_equal 1
    end

    it "sets and gets low speed time" do
      @curl.low_speed_time = 60
      expect(@curl.low_speed_time).must_equal 60
    end
  end

  describe "constants" do
    it "defines HTTP_1_0" do
      expect(Curl::HTTP_1_0).wont_be_nil
    end

    it "defines HTTP_1_1" do
      expect(Curl::HTTP_1_1).wont_be_nil
    end

    it "defines SSL_VERIFYPEER" do
      expect(Curl::SSL_VERIFYPEER).must_equal 1
    end

    it "defines TIMEOUT" do
      expect(Curl::TIMEOUT).must_be_nil
    end

    it "defines TIMEOUT_MS" do
      expect(Curl::TIMEOUT_MS).must_be_nil
    end

    it "defines CONNECT_TIMEOUT" do
      expect(Curl::CONNECT_TIMEOUT).must_be_nil
    end

    it "defines CONNECT_TIMEOUT_MS" do
      expect(Curl::CONNECT_TIMEOUT_MS).must_be_nil
    end

    it "defines LOW_SPEED_LIMIT" do
      expect(Curl::LOW_SPEED_LIMIT).must_be_nil
    end

    it "defines LOW_SPEED_TIME" do
      expect(Curl::LOW_SPEED_TIME).must_be_nil
    end

    it "defaults CAINFO to nil" do
      expect(Curl::CAINFO).must_be_nil
    end

    it "defaults HTTP_VERSION to HTTP_2TLS" do
      expect(Curl::HTTP_VERSION).must_equal Curl::HTTP_2TLS
    end
  end

  describe "global_init" do
    it "responds to global_init" do
      expect(Curl).must_respond_to :global_init
    end
  end

  describe "instance methods" do
    before do
      @curl = Curl.new
    end

    it "responds to get" do
      expect(@curl).must_respond_to :get
    end

    it "responds to post" do
      expect(@curl).must_respond_to :post
    end

    it "responds to put" do
      expect(@curl).must_respond_to :put
    end

    it "responds to patch" do
      expect(@curl).must_respond_to :patch
    end

    it "responds to delete" do
      expect(@curl).must_respond_to :delete
    end

    it "responds to send" do
      expect(@curl).must_respond_to :send
    end
  end

  describe "class-level convenience methods" do
    it "responds to .get" do
      expect(Curl).must_respond_to :get
    end

    it "responds to .post" do
      expect(Curl).must_respond_to :post
    end

    it "responds to .put" do
      expect(Curl).must_respond_to :put
    end

    it "responds to .patch" do
      expect(Curl).must_respond_to :patch
    end

    it "responds to .delete" do
      expect(Curl).must_respond_to :delete
    end

    it "responds to .send" do
      expect(Curl).must_respond_to :send
    end
  end
end
Minitest.run(ARGV) || exit(1)
