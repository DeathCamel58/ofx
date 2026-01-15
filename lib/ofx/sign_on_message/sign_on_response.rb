module OFX
  module SignOnMessage
    # 2.5.1.6 Signon Response <SONRS>
    #
    # @note `<OFXEXTENSION>` Ignored

    class SignOnResponse < Foundation
      # {Status} aggregate, see section 3.1.5. See list of possible code values in section 2.5.1.7
      attr_accessor :status

      # Date and time of the server response
      attr_accessor :server_date

      # Use user key instead of USERID and USERPASS for subsequent requests. TSKEYEXPIRE can limit lifetime.
      attr_accessor :user_key

      # @return [Time, nil] Date and time that USERKEY expires
      attr_accessor :ts_key_expire

      # @return [String] Language used in text responses
      attr_accessor :language

      # @return [Time, nil] Date and time of last update to profile information for any service supported by this FI
      attr_accessor :profile_last_updated_at

      # @return [Time, nil] Date and time of last update of user information on the server
      attr_accessor :user_last_updated_at

      # @return [Time, nil] Date and time of last update to account information
      attr_accessor :account_last_updated_at

      # @return [OFX::FinancialInstitution, nil] {FinancialInstitution} identification
      attr_accessor :financial_institution

      # @return [String] Session cookie that the client should return on the next {SignOnRequest}
      attr_accessor :session_cookie

      # @return [String] Access key that the client should send in the next {SignOnRequest}
      attr_accessor :access_key

      def self.from_ofx_102(node)
        node = normalize_node(node)

        return nil if node.empty?

        response = new({
              server_date: OFX::Utils.build_date(node.search('dtserver').inner_text),
              user_key: node.search('userkey').inner_text,
              ts_key_expire: (OFX::Utils.build_date(node.search('tskeyexpire').inner_text) rescue nil),
              language: node.search('language').inner_text,
              profile_last_updated_at: (OFX::Utils.build_date(node.search('dtprofup').inner_text) rescue nil),
              user_last_updated_at: (OFX::Utils.build_date(node.search('dtuserup').inner_text) rescue nil),
              account_last_updated_at: (OFX::Utils.build_date(node.search('dtacctup').inner_text) rescue nil),
              session_cookie: node.search('sesscookie').inner_text,
              access_key: node.search('accesskey').inner_text
            })

        status_node = node.search('status')
        response.status = OFX::SignOnMessage::Status.from_ofx_102(status_node) if status_node

        fi_node = node.search('fi')
        response.financial_institution = OFX::SignOnMessage::FinancialInstitution.from_ofx_102(fi_node) if fi_node

        response
      end
    end

    # Alias for backward compatibility
    SignOn = SignOnResponse
  end
end
