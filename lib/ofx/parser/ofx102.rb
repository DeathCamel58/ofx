# frozen_string_literal: true

module OFX
  module Parser
    class OFX102
      VERSION = '1.0.2'

      SEVERITY = {
        'INFO' => :info,
        'WARN' => :warn,
        'ERROR' => :error
      }.freeze

      attr_reader :headers, :body, :html

      def initialize(options = {})
        @headers = options[:headers]
        @body = options[:body]
        @html = Nokogiri::HTML.parse(body)
      end

      def statements
        @statements ||= html.search('stmttrnrs, ccstmttrnrs').collect { |node| build_statement(node) }
      end

      def investment_statements
        @investment_statements ||= html.search('invstmtrs').collect { |node| build_investment_statement(node) }
      end

      def accounts
        @accounts ||= html.search('stmttrnrs, ccstmttrnrs').collect { |node| build_account(node) }
      end

      # DEPRECATED: kept for legacy support
      def account
        @account ||= build_account(html.search('stmttrnrs, ccstmttrnrs').first)
      end

      def sign_on
        @sign_on ||= build_sign_on
      end

      def self.parse_headers(header_text)
        # Change single CR's to LF's to avoid issues with some banks
        header_text.gsub!(/\r(?!\n)/, "\n")

        # Parse headers. When value is NONE, convert it to nil.
        headers = header_text.to_enum(:each_line).each_with_object({}) do |line, memo|
          _, key, value = *line.match(/^(.*?):(.*?)\s*(\r?\n)*$/)

          unless key.nil?
            memo[key] = value == 'NONE' ? nil : value
          end
        end

        return headers unless headers.empty?
      end

      private

      def build_statement(node)
        account = build_account(node)
        statement = OFX::Statement.from_ofx_102(node)

        statement.account = account
        statement.balance = account.balance
        statement.available_balance = account.available_balance

        statement
      end

      def build_investment_statement(node)
        OFX::Investment::InvestmentStatementResponse.from_ofx_102(node)
      end

      def build_account(node)
        OFX::Account.from_ofx_102(node)
      end

      def build_sign_on
        if (node = html.search('signonmsgsrsv1 > sonrs')).any?
          OFX::SignOnMessage::SignOnResponse.from_ofx_102(node)
        elsif (node = html.search('signonmsgsrqv1 > sonrq')).any?
          OFX::SignOnMessage::SignOnRequest.from_ofx_102(node)
        end
      end
    end
  end
end
