# frozen_string_literal: true

module OFX
  module Parser
    class OFX102
      VERSION = '1.0.2'

      ACCOUNT_TYPES = {
        'CHECKING' => :checking,
        'SAVINGS' => :savings,
        'CREDITLINE' => :creditline,
        'MONEYMRKT' => :moneymrkt
      }.freeze

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
        stmrs_node = node.search('stmtrs, ccstmtrs')
        account = build_account(node)
        OFX::Statement.new(
          currency: stmrs_node.search('curdef').inner_text,
          start_date: OFX::Utils.build_date(stmrs_node.search('banktranlist > dtstart').inner_text),
          end_date: OFX::Utils.build_date(stmrs_node.search('banktranlist > dtend').inner_text),
          account: account,
          transactions: account.transactions,
          balance: account.balance,
          available_balance: account.available_balance
        )
      end

      def build_account(node)
        OFX::Account.new({
                           bank_id: node.search('bankacctfrom > bankid').inner_text,
                           id: node.search('bankacctfrom > acctid, ccacctfrom > acctid').inner_text,
                           type: ACCOUNT_TYPES[node.search('bankacctfrom > accttype').inner_text.to_s.upcase],
                           transactions: build_transactions(node),
                           balance: build_balance(node),
                           available_balance: build_available_balance(node),
                           currency: node.search('stmtrs > curdef, ccstmtrs > curdef').inner_text
                         })
      end

      def build_sign_on
        if (node = html.search('signonmsgsrsv1 > sonrs')).any?
          OFX::SignOnMessage::SignOnResponse.from_ofx_102(node)
        elsif (node = html.search('signonmsgsrqv1 > sonrq')).any?
          OFX::SignOnMessage::SignOnRequest.from_ofx_102(node)
        end
      end

      def build_transactions(node)
        # TODO: also parse `banktranlistp > stmttrnp` (pending TXs)
        node.search('banktranlist > stmttrn').collect do |element|
          OFX::Transaction.from_ofx_102(element)
        end
      end

      def build_balance(node)
        amount = OFX::Utils.to_decimal(node.search('ledgerbal > balamt').inner_text)
        posted_at = begin
          OFX::Utils.build_date(node.search('ledgerbal > dtasof').inner_text)
        rescue StandardError
          nil
        end

        OFX::Balance.new({
                           amount: amount,
                           amount_in_pennies: (amount * 100).to_i,
                           posted_at: posted_at
                         })
      end

      def build_available_balance(node)
        if node.search('availbal').size > 0
          amount = OFX::Utils.to_decimal(node.search('availbal > balamt').inner_text)

          OFX::Balance.new({
                             amount: amount,
                             amount_in_pennies: (amount * 100).to_i,
                             posted_at: OFX::Utils.build_date(node.search('availbal > dtasof').inner_text)
                           })
        end
      end
    end
  end
end
