module ECSD
  class BaseError < RuntimeError; end

  class Config
    class ValidationError < BaseError; end
  end
end
