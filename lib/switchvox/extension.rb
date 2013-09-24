class Extension
  attr_accessor :name, :ext
  def initialize(options = {})
    @name = options["display"] || "unknown"
    @ext = options["number"] || "0000"
  end

  def to_a
    return [name, ext]
  end

end
