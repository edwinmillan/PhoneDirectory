require "test_helper"
require "prawn"
require "open-uri"

require "switchvox/pdf"

module Switchvox
  class PdfTest < Minitest::Test
    def setup
      num_extensions = 157
      extensions = Array.new(num_extensions)
      extensions = extensions.each_index.map { |i| ["Name#{i}", "#{i + 1234}"] }

      @pdf = Pdf.new(raw_data: extensions, filename: "pdf_test.pdf")
    end

    def test_generate
      assert_kind_of File, @pdf.generate      
    end

    def test_max_columns
      assert_kind_of Integer, @pdf.max_columns
    end

    def test_raw_data
      assert_kind_of Array, @pdf.raw_data
    end

    def test_formatted_data
      assert_kind_of Array, @pdf.formatted_data
      assert_kind_of Array, @pdf.formatted_data.first
    end

    def test_filename
      assert_kind_of String, @pdf.filename
    end

    def test_logo
      assert_kind_of String, @pdf.logo
    end

    def test_title
      assert_kind_of String, @pdf.title    
    end
  end
end
