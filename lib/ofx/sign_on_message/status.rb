module OFX
  module SignOnMessage
    # 2.5.1.7 Status Codes

    class Status < Foundation
      attr_accessor :code     # Error code
      attr_accessor :severity # Severity of the error
      attr_accessor :message  # Textual explanation

      MAPPINGS = {
        '0' => { severity: :info, message: 'Success' },
        '2000' => { severity: :error, message: 'General error' },
        '3000' => { severity: :error, message: 'User credentials are correct, but further authentication required' },
        '3001' => { severity: :error, message: 'MFACHALLENGEANSWER contains invalid information' },
        '13504' => { severity: :error, message: '<FI> Missing or Invalid in <SONRQ>' },
        '13505' => { severity: :error, message: 'Server undergoing maintenance; try again later' },
        '15000' => { severity: :info, message: 'Must change USERPASS' },
        '15500' => { severity: :error, message: 'Signon invalid' },
        '15501' => { severity: :error, message: 'Customer account already in use' },
        '15502' => { severity: :error, message: 'USERPASS Lockout' },
        '15506' => { severity: :error, message: 'Empty signon transaction not supported' },
        '15507' => { severity: :error, message: 'Signon invalid without supporting pin change request' },
        '15510' => { severity: :error, message: 'CLIENTUID error' },
        '15511' => { severity: :error, message: 'User should contact financial institution' },
        '15512' => { severity: :error, message: 'OFX server requires AUTHTOKEN in signon during the next session' },
        '15513' => { severity: :error, message: 'AUTHTOKEN invalid' },
        '15514' => { severity: :error, message: 'OFX Server requires ACCESSTOKEN for authentication' },
        '15515' => { severity: :error, message: 'Authentication failed; ACCESSTOKEN provided is invalid/unrecognized by the server' },
        '15516' => { severity: :error, message: 'ACCESSTOKEN provided is expired and needs refresh' },
      }

      def self.from_ofx_102(node)
        return nil if node.empty?

        code = node.search('code').inner_text.to_s.strip
        severity_text = node.search('severity').inner_text.to_s.upcase.strip
        message_text = node.search('message').inner_text.to_s.strip

        # Get default from MAPPINGS if they exist for this code
        default = MAPPINGS[code] || {}

        # Priority: XML Value > MAPPINGS Value > Default Fallback
        severity = if !severity_text.empty?
                     # Map string to symbol (e.g., "INFO" -> :info)
                     { 'INFO' => :info, 'WARN' => :warn, 'ERROR' => :error }[severity_text]
                   else
                     default[:severity]
                   end

        message = !message_text.empty? ? message_text : default[:message]

        new({
              code: code.to_i,
              severity: severity || :error,
              message: message || "Unknown status"
            })
      end

      def success?
        code == 0
      end
    end
  end
end
