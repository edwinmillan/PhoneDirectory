require "json"
require "httparty"

class Directory
  def initialize(options = {})
    @url        = options[:url]        || raise_argument_error(:url)
    @username   = options[:username]   || raise_argument_error(:username)
    @password   = options[:password]   || raise_argument_error(:password)
    @method     = options[:method]     || raise_argument_error(:method)
    @parameters = options[:parameters] || {}
    @auth       = { username: @username, password: @password }
  end

  def response
    json_body = {request: {method: @method, parameters: @parameters}}.to_json
    options = {
      body: json_body,
      digest_auth: @auth
    }
    return response = HTTParty.post(@url, options)
  end

  def export_extensions
    exts = []
    extensions(response).map! do |raw_ext|
      extension = Extension.new(raw_ext)
      exts << extension.to_a
    end
    return exts
  end

  private

  def extensions(response)
    body = JSON.parse(response.body)
    return body["response"]["result"]["extensions"]["extension"]
  end

  def raise_argument_error(arg)
    raise ArgumentError, "You must include a #{arg.inspect} option when calling Directory.new"
  end
end

