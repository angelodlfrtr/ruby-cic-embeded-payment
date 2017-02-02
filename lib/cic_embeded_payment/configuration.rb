module CicEmbededPayment
  class Configuration
    attr_accessor :mode,
      :key,
      :tpe,
      :version,
      :lang,
      :company,
      :default_devise,
      :digester

    def initialize
      @mode,
      @key,
      @tpe,
      @version,
      @lang,
      @company,
      @digester,
      @default_devise = :test,
                        '',
                        '',
                        '3.0',
                        :fr,
                        '',
                        :sha1,
                        :eur
    end

    def endpoint
      if self.mode.to_sym == :production
        "https://ssl.paiement.cic-banques.fr/emulation3ds.cgi"
      else
        "https://ssl.paiement.cic-banques.fr/test/emulation3ds.cgi"
      end
    end
  end
end
