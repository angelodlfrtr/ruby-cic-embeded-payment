require 'digest/hmac'
require 'uri'

module CicEmbededPayment
  module Utils

    # Permit to format amount and devise for send datas to cic in correct format
    #
    # @param amount [Integer,Float] The amount
    # @param devise [Symbol,String] The devise to use : :eur, :usd, ...
    #
    # @return [String] The formatted amount
    def self.process_amount amount, devise
      "#{amount.to_f}#{devise.to_s.upcase}"
    end

    # Permit to html encode characters
    def self.html_encode_fields parsed
      for k, v in parsed
        unless k.to_s == 'version' || k.to_s == 'montant'
          parsed[k] = URI.escape(parsed[k])
        end
      end

      parsed
    end

    # Permit to get fields list in order to create seal
    #
    # @return [Array<Symbol>]
    def self.fields_list
      [
        :TPE,
        :date,
        :montant,
        :reference,
        'texte-libre',
        :version,
        :lgue,
        :societe,
        :mail,
        :nbrech,
        :dateech1,
        :montantech1,
        :dateech2,
        :montantech2,
        :dateech3,
        :montantech3,
        :dateech4,
        :montantech4,
        :options
      ]
    end

    # Permit to get seal of datas
    # Calculed with the key provided by cic
    #
    # @return [String] the seal
    def self.calc_seal opts
      str = []

      for key in fields_list
        if opts.has_key?(key) || opts.has_key?(key.to_s)
          str << opts[key] || opts[key.to_s]
        else
          str << ''
        end
      end

      str = str.join('*')

      Digest::HMAC.hexdigest(str, CicEmbededPayment.configuration.key, get_digester)
    end

    # Permit to get the digester for hmac encryption from configuration
    #
    # @return [Class] The digester
    def self.get_digester
      {
        :sha1 => Digest::SHA1,
        :md5  => Digest::MD5
      }[CicEmbededPayment.configuration.digester] || raise(StandardError, "Digester not recognized")
    end
  end
end
