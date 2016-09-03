module HanamiWebpack
  class WebpackError < StandardError
    def initialize(errors)
      super "Error in webpack compile, details follow below:\n#{errors.join("\n\n")}"
    end
  end
end
