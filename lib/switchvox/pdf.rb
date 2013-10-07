require "prawn"
require "open-uri"

class Pdf
  attr_accessor :max_columns, :max_rows, :raw_data, :formatted_data, :filename, :logo, :title, :count
  def initialize(options = {})
    @raw_data = options[:raw_data] || raise_argument_error(:raw_data)
    @filename = options[:filename] || raise_argument_error(:filename)
    @logo = options[:logo] || 'logo.png'
    @title = options[:title] || "Company Phone Directory"
    @max_rows = 60
  end

  def generate
    return prawn_pdf_generation
  end

  def max_columns
    col_capacity = max_rows
    col_count = 1
    while raw_data.count > col_capacity
      col_capacity += max_rows
      col_count += 1
    end

    return col_count
  end

  def formatted_data
    columns = raw_data.each_slice(max_rows).inject([]) { |cols,col| cols << col }
    columns.fill([], columns.length...max_columns)
    columns.each { |column| column.fill([" "," "], column.length...max_rows) }
    data = columns.transpose.flatten!.each_slice(max_columns*2).to_a
    return data
  end

  private
  
  def prawn_pdf_generation
    Prawn::Document.generate(filename, page_size: "LEGAL", page_layout: :portrait) do |pdf|
      pdf.font_size 24
      pdf.draw_text title, at: [175,890]
      pdf.font_size 7.5
      logo_url = logo
      widthoptions = {
        1 => 50,
        3 => 50,
        5 => 50
      }
      pdf.image open(logo_url), width: 122, height: 56, at: [50,926]

      pdf.bounding_box([50,880],width: 450, height: 900) do
        header = [["Name","Extension"] * max_columns]
        pdf.text "Revision #{Time.now.strftime "%-m.%d.%Y"}", align: :right
        pdf.table(header + formatted_data, width: 450, position: :center, cell_style: {padding: 2}, row_colors: ["EBF0DE","FFFFFF"], header: true, column_widths: widthoptions) do
          row(0).font_style = :bold
          row(0).text_color = "FFFFFF"
          row(0).background_color = "9BBA58"
        end
      end
    end
  end

  def raise_argument_error(arg)
    raise ArgumentError, "You must include a #{arg.inspect} option when calling Pdf.new"
  end
end