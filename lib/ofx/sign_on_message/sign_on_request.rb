module OFX
  # 2.5.1.5 Signon Request <SONRQ>
  #
  # @note `<OFXEXTENSION>` Ignored
  # @note `<MFACHALLENGEANSWER>` Ignored
  # @note This is untested. I haven't been able to to see a SONRQ message in the wild to test parsing

  class SignOnRequest < Foundation
    # @return [Time] Date and time of the request from the client computer
    attr_accessor :client_date

    # @return [String] User identification string
    attr_accessor :user_id

    # @return [String] User password on server
    attr_accessor :user_password

    # @return [String] Log in using previously authenticated context
    attr_accessor :user_key

    # @return [String] Out of band arranged token to be used for authentication
    attr_accessor :access_token

    # @return [Boolean] Request server to return a USERKEY for future use
    attr_accessor :generate_user_key

    # @return [String] Requested language for text responses
    attr_accessor :language

    # @return [OFX::FinancialInstitution, nil] {FinancialInstitution} identification
    attr_accessor :financial_institution

    # @return [String] Session cookie value received in previous {SignOnResponse}
    attr_accessor :session_cookie

    # @return [String] ID of client application
    attr_accessor :app_id

    # @return [String] Version of client application
    attr_accessor :app_version

    # @return [String] Application key/identifier
    attr_accessor :app_key

    # @return [String] Unique ID identifying OFX user
    attr_accessor :client_uid

    # @return [String] Additional user credential required by server
    attr_accessor :user_cred1

    # @return [String] Additional user credential required by server
    attr_accessor :user_cred2

    # @return [String] Authentication token required for this signon session only
    attr_accessor :auth_token

    # @return [String] Access key value received in previous {SignOnResponse}
    attr_accessor :access_key

    def self.from_ofx_102(node)
      return nil if node.empty?

      request = new({
                      client_date: OFX::Utils.build_date(node.search('dtclient').inner_text),
                      user_id: node.search('userid').inner_text,
                      user_password: node.search('userpass').inner_text,
                      user_key: node.search('userkey').inner_text,
                      access_token: node.search('accesstoken').inner_text,
                      generate_user_key: node.search('genuserkey').inner_text.casecmp('y').zero?,
                      language: node.search('language').inner_text,
                      session_cookie: node.search('sesscookie').inner_text,
                      app_id: node.search('appid').inner_text,
                      app_version: node.search('appver').inner_text,
                      app_key: node.search('appkey').inner_text,
                      client_uid: node.search('clientuid').inner_text,
                      user_cred1: node.search('usercred1').inner_text,
                      user_cred2: node.search('usercred2').inner_text,
                      auth_token: node.search('authtoken').inner_text,
                      access_key: node.search('accesskey').inner_text
                    })

      fi_node = node.search('fi')
      request.financial_institution = OFX::FinancialInstitution.from_ofx_102(fi_node) if fi_node

      request
    end
  end
end