<p align="center">
  <a href="https://github.com/llmrb/mruby-curl">
    <img src="https://github.com/llmrb/llm.rb/raw/main/llm.png" width="200"
         height="200" border="0" alt="mruby-curl">
  </a>
</p>

<p align="center">
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-orange.svg"
         alt="License">
  </a>
</p>

## About

mruby-curl is an [mruby](https://mruby.org) wrapper for
[libcurl](https://curl.se/libcurl/). It provides HTTP client capabilities
with support for GET, POST, PUT, PATCH, DELETE, streaming responses,
concurrent requests through the multi interface, and configurable timeouts,
SSL verification, and HTTP version selection.

Responses are parsed through
[mruby-http](https://github.com/llmrb/mruby-http), which returns structured
`HTTP::Response` objects with `body`, `headers`, `status_code`, and other
attributes.

## Quick start

#### GET request

```ruby
curl = Curl.new

headers = {
  "User-Agent" => "mruby-curl"
}

response = curl.get("https://www.ruby-lang.org/en/", headers)
puts response.body
```

Pass query parameters with the `params:` keyword. The hash is
URL-encoded and appended to the request URL for you:

```ruby
response = curl.get("https://api.example.com/search", params: {q: "ruby curl"})
# Requests https://api.example.com/search?q=ruby+curl
```

**Explanation**

* `Curl.new`<br>
  Creates a new curl easy handle. Each `Curl` instance manages one HTTP
  connection at a time.
* `curl.get(url, headers)`<br>
  Sends a GET request. The second argument is an optional hash of HTTP
  headers. Returns an `HTTP::Response` parsed by mruby-http.
* `params: {...}`<br>
  Adds query parameters to the URL. Keys and values are URL-encoded
  automatically.
* `response.body`<br>
  The response body as a string. The response object also exposes
  `headers`, `status_code`, and other attributes through mruby-http.

#### POST, PUT, PATCH, DELETE

HTTP methods that accept a body require two positional arguments: the URL
and the data string. Headers are optional:

```ruby
curl = Curl.new

headers = {"Content-Type" => "application/json"}
data = '{"title": "Hello"}'

response = curl.post("https://api.example.com/posts", data, headers)
puts response.status_code
```

The same pattern works for `put`, `patch`, and `delete`:

```ruby
curl.patch("https://api.example.com/posts/1", '{"title": "Updated"}', headers)
curl.put("https://api.example.com/posts/1", '{"title": "Replaced"}', headers)
curl.delete("https://api.example.com/posts/1", headers)
```

#### Class-level convenience methods

Each instance method has a corresponding class method that lazily creates
and reuses a singleton `Curl` instance:

```ruby
response = Curl.get("https://api.example.com/data")
response = Curl.get("https://api.example.com/search", params: {q: "ruby curl"})
response = Curl.post("https://api.example.com/data", "body")
response = Curl.put("https://api.example.com/data", "body")
response = Curl.patch("https://api.example.com/data", "body")
response = Curl.delete("https://api.example.com/data")
```

#### Streaming responses

Pass a block to receive the response incrementally. The block receives the
parsed header and a body chunk on each invocation. This is useful for large
responses or streaming APIs:

```ruby
Curl.new.get("https://stream.example.com/data") do |header, chunk|
  puts "chunk received: #{chunk}"
end
```

#### Concurrent requests with Curl::Multi

Use `Curl::Multi` to send multiple requests concurrently through libcurl's
multi interface. Create a `Multi`, call `send` for each request, then poll
with `perform` and check `done?`:

```ruby
multi = Curl::Multi.new

req1 = HTTP::Request.new
req1.method = "GET"

req2 = HTTP::Request.new
req2.method = "GET"

r1 = multi.send("https://api.example.com/data1", req1)
r2 = multi.send("https://api.example.com/data2", req2)

while !multi.done?
  multi.perform
end

puts r1.response.body
puts r2.response.body
```

Each `send` call returns a `Curl::Multi::Request` object that provides:

* `done?`<br>
  Whether the request has finished.
* `response`<br>
  The parsed `HTTP::Response` on success. Raises on error.
* `error`<br>
  A string describing the error, or `nil` if the request succeeded.

#### Custom request with Curl#send

For full control over the request, build an `HTTP::Request` object and pass
it to `Curl#send`:

```ruby
req = HTTP::Request.new
req.method = "POST"
req.body = '{"key": "value"}'
req.headers["Authorization"] = "token secret"

response = Curl.new.send("https://api.example.com/endpoint", req)
puts response.body
```

#### Configuration

**Timeouts**

Set timeouts in seconds or milliseconds:

```ruby
curl = Curl.new
curl.timeout = 30       # 30 seconds
curl.timeout_ms = 5000  # 5 seconds (overrides timeout if both are set)
```

**SSL verification**

Disable SSL peer verification (not recommended for production):

```ruby
Curl::SSL_VERIFYPEER = 0
```

**HTTP version**

The default is `Curl::HTTP_2TLS`, which tries HTTP/2 for HTTPS requests and
falls back when HTTP/2 is not available.

Switch to HTTP/1.0 explicitly:

```ruby
Curl::HTTP_VERSION = Curl::HTTP_1_0
```

Or set a custom CA info path:

```ruby
Curl::CAINFO = "/etc/ssl/certs/ca-certificates.crt"
```

#### Thread safety

By default mruby-curl does not call `curl_global_init`. If you use
mruby-curl from multiple threads, call `Curl.global_init` before starting
any threads:

```ruby
Curl.global_init
```

This initializes libcurl with `CURL_GLOBAL_DEFAULT` flags. It must be
called once and only once. See the
[curl_global_init](https://curl.se/libcurl/c/curl_global_init.html)
documentation for more details.

## Integration

Add to your mruby build configuration:

```ruby
MRuby::Build.new("app") do |conf|
  conf.toolchain

  curldir = File.expand_path(ENV["CURLDIR"] || "/usr/local")
  conf.cc.include_paths << File.join(curldir, "include")
  conf.linker.library_paths << File.join(curldir, "lib")

  conf.gembox "default"
  conf.gem github: "llmrb/mruby-curl", branch: "main"
end
```

The gem depends on `mruby-http` and links against `libcurl`.

## License

MIT

See [LICENSE](LICENSE).
