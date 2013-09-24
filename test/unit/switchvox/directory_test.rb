require "test_helper"
require "json"
require "httparty"

require "switchvox/directory"
require "switchvox/extension"

module Switchvox
  class DirectoryTest < Minitest::Test
    def setup
      options = { 
        username: "api_user",
        password: "api_password",
        url: "https://switchvox_url/json",
        method: "switchvox.extensions.search",
        parameters: {"items_per_page" => "500"}
      }
      @directory = Directory.new(options)
    end

    def test_response
      assert_respond_to @directory.response, 'to_h'
    end

    def test_export_extensions
      assert_kind_of Array, @directory.export_extensions
      assert_kind_of Array, @directory.export_extensions[0]
      assert_kind_of String, @directory.export_extensions[0][0]
      assert_kind_of String, @directory.export_extensions[0][1]
    end
  end
end