require 'rest-client'
require 'date'

module CicEmbededPayment
  class Payment
    include Utils

    attr_reader :parsed

    # Constructor method
    #
    # @param args
    def initialize *args
      @args        = args[0]
      parsed       = parse_opts
      parsed       = Utils::html_encode_fields(parsed)
      parsed[:MAC] = Utils::calc_seal(parsed)
      @parsed      = parsed
    end

    # Send POST Request to cic server
    #
    # @return [CicEmbededPayment::PaymentResponse] The response
    def send
      response = RestClient.post( CicEmbededPayment.configuration.endpoint, @parsed )
      PaymentResponse.new(response)
    end

    private

      # Permit to parse default options with payment options
      #
      # @return [Hash] The options
      def parse_opts

        # Opts to cuse for each calls
        base_opts = {
          :version => CicEmbededPayment.configuration.version,
          :TPE     => CicEmbededPayment.configuration.tpe,
          :date    => DateTime.now.strftime('%d/%m/%Y:%H:%M:%S'),
          :lgue    => CicEmbededPayment.configuration.lang.to_s.upcase,
          :societe => CicEmbededPayment.configuration.company
        }

        # Get devise from args or config
        devise = get_arg(:devise) || CicEmbededPayment.configuration.default_devise

        # Create base payment opts
        validity = get_arg(:validity)

        parsed_opts = {
          :montant        => Utils::process_amount(get_arg(:amount, true), devise),
          :numero_carte   => get_arg(:card_number, true),
          :annee_validite => validity[:year] || raise(Errors::KeyRequieredError,
                                                      "Card validity year is requiered"),
          :mois_validite  => validity[:month] || raise(Errors::KeyRequieredError,
                                                       "Card validity month is requiered"),
          :cvx            => get_arg(:ccv, true)
        }

        # Add keys for optionnals parameters

        if text = get_arg(:text)
          parsed_opts['texte-libre'] = text
        end

        if ref = get_arg(:ref)
          parsed_opts[:reference] = ref
        end

        if mail = get_arg(:mail)
          parsed_opts[:mail] = mail
        end

        if options = get_arg(:options)
          parsed_opts[:options] = options.map { |k, v| "#{k}=#{v}" }.join('&')
        end

        base_opts.merge(parsed_opts)
      end

      # Permit to get value of @args
      # if key_requiered is true and the key dont exist in @args, the method will
      # raise error
      #
      # @param key [Symbol] The key
      # @param key_requiered [Boolean] key requiered or not
      #
      # @return [Hash, String, Symbol] The [at]args[key] value
      def get_arg key, key_requiered=false
        if @args.has_key?(key)
          @args[key]
        else
          if key_requiered
            raise Errors::KeyRequieredError, "Key '#{key}' is requiered"
          else
            false
          end
        end
      end
  end
end
