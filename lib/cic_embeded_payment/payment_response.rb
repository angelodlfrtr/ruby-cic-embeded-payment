require 'nokogiri'

module CicEmbededPayment
  class PaymentResponse
    attr_reader :original_response, :parsed_response

    # Parse RestClient response to cic payment gateway
    #
    # @param response [Class] The RestClient response
    def initialize response
      @original_response, @parsed_response = response, Nokogiri::XML(response.body)
    end

    # Permit to know if request is a success
    #
    # @return [Boolean] true or false
    def success?
      @parsed_response.xpath('//cdr/text()').to_s.to_i > 0
    end

    # Permit to know if request is an error
    #
    # @return [Boolean] true or false
    def error?; !success?; end

    def error
      code = @parsed_response.xpath('//cdr/text()')
      message_by_request_response_code(code)
    end

    private

      # Permit to get the message corresponding to the response code
      def message_by_request_response_code code
        {
          '2' =>
            [
              'Résultat de l\'étape 1 pour une carte enrôlée 3DSecure',
              'Le commerçant devra effectuer les étapes 2 et 3 pour l\'authentification du client'
            ],
          '1' =>
            [
              'Mise en recouvrement effectuée',
              'l’autorisation bancaire a été délivrée et la mise en recouvrement a été effectuée.'
            ],
          '0' =>
            ['Paiement non effectué',
             'L’autorisation bancaire n’a pas été délivrée'
            ],
          '-1' =>
            [
              'Problème technique',
              'Problème technique, il faut réitérer la demande'
            ],
          '-2' =>
            [
              'Commerçant non identifié',
              'Les paramètres servant à identifier le site commerçant ne sont pas corrects, vérifier les champs societe, lgue et TPE'
            ],
          '-3' =>
            [
              'Commande non authentifiée',
              'La signature MAC est invalide'
            ],
          '-4' =>
            [
              'CB expirée',
              'La date de validité de la carte bancaire n’est pas valide'
            ],
          '-5' =>
            [
              'Numéro de CB erroné',
              'Le numéro de la carte bancaire n’est pas valide'
            ],
          '-6' =>
            [
              'Commande expirée',
              'La date de la commande dépasse le délai autorisé (+/- 24h)'
            ],
          '-7' =>
            [
              'Montant erroné',
              'Le montant transmis est mal formaté ou est égal à zéro'
            ],
          '-8' =>
            [
              'Date erronée',
              'La date transmise est erronée'
            ],
          '-9' =>
            [
              'CVX erroné',
              'Le cryptogramme visuel transmis est erroné'
            ],
          '-10' =>
            [
              'Paiement déjà autorisé',
              'une autorisation a déjà été délivrée pour cette demande de paiement, il est toujours possible de mettre en recouvrement le paiement'
            ],
          '-11' =>
            [
              'Paiement déjà accepté',
              'Le paiement relatif à cette commande a déjà fait l’objet d’un recouvrement'
            ],
          '-12' =>
            [
              'Paiement déjà annulé',
              'la commande a été annulée et ne peut plus accepter de nouvelle demande d’autorisation'
            ],
          '-13' =>
            [
              'Traitement en cours',
              'La commande est en cours de traitement'
            ],
          '-14' =>
            [
              'Commande grillée',
              'Le nombre maximal de tentatives de fourniture de carte a été atteint (3 tentatives sont acceptées), la commande n’est plus acceptée par le serveur bancaire'
            ],
          '-15' =>
            [
              'Erreur paramètres',
              'Les paramètres transmis à l\'émulation TPE sont erronés'
            ],
          '-16' =>
            [
              'Erreur résultat d\'authentification 3D-Secure',
              'Le résultat d\'authentification 3D-Secure transmis à l\'émulation TPE est invalide'
            ],
          '-17' =>
            [
              'Le montant des échéances est erroné',
              'Le montant des échéances transmis est mal formaté. La somme des échéances n’est pas égale au montant de la commande.'
            ],
          '-18' =>
            [
              'La date des échéances est erronée',
              'L’une des dates transmise est mal formatée. La différence entre les dates n’est pas d’un mois.'
            ],
          '-19' =>
            [
              'Le nombre d’échéance n’est pas correct',
              'Le nombre d’échéance doit être compris entre 2 et 4'
            ],
          '-20' =>
            [
              'La version envoyée n’est pas correcte',
              'La version doit être égale à « 3.0 »'
            ],
          '-22' =>
            [
              'CB séquestrée expirée',
              'La date de la carte séquestrée utilisée est expirée'
            ],
          '-24' =>
            [
              'CVV non présent',
              'Le CVV n’a pas été fourni et est obligatoire'
            ],
          '-25' =>
            [
              'TPE fermé',
              'Le TPE utilisé est fermé'
            ],
          '-26' =>
            [
              'AVS manquant',
              '« Address Verification System » : l’adresse n’a pas été fournie'
            ]
        }[code.to_s]
      end
  end
end
