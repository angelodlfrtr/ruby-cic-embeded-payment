require "cic_embeded_payment/version"
require "rest-client"

module CicEmbededPayment
  module Errors
    autoload :KeyRequieredError, 'cic_embeded_payment/errors/key_requiered_error'
  end

  autoload :Utils,           'cic_embeded_payment/utils'
  autoload :Configuration,   'cic_embeded_payment/configuration'
  autoload :PaymentResponse, 'cic_embeded_payment/payment_response'
  autoload :Payment,         'cic_embeded_payment/payment'

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(self.configuration)
  end
end
