module ECSD
  class BaseError < RuntimeError; end

  class UnknownExportFormatError < BaseError; end

  class Config
    class ValidationError < BaseError; end
  end
end
