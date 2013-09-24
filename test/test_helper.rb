require "simplecov"
SimpleCov.start do
  add_filter "/vendor/"
  add_filter "/test/"
end

require "minitest/autorun"

$LOAD_PATH.unshift "lib"