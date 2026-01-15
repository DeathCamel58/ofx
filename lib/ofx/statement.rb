module OFX
  class Statement < Foundation
    # @return [OFX::Account] Account-from aggregate
    attr_accessor :account

    # @return [OFX::Balance] Available balance aggregate
    attr_accessor :available_balance

    # @return [OFX::Balance] Ledger balance aggregate
    attr_accessor :balance

    # @return [String] Default currency for the statement
    attr_accessor :currency

    # @return [Time] Start date for transaction data
    attr_accessor :start_date

    # @return [Time] End date for transaction data
    attr_accessor :end_date

    # @return [Array<OFX::Transaction>] List of statement transactions
    attr_accessor :transactions

    # @return [Array<OFX::Transaction>] List of pending statement transactions
    attr_accessor :pending_transactions

    # @return [Time, nil] Date and time the set of pending transactions was generated
    attr_accessor :pending_transactions_as_of

    # @return [BigDecimal, nil] Current balance amount for cash advances (CREDITLINE only)
    attr_accessor :cash_advance_balance

    # @return [BigDecimal, nil] Current interest rate in effect
    attr_accessor :interest_rate

    def self.from_ofx_102(node)
      node = normalize_node(node)

      stmrs_node = node.search('stmtrs, ccstmtrs')

      new(
        currency: stmrs_node.search('curdef').inner_text,
        start_date: OFX::Utils.build_date(stmrs_node.search('banktranlist > dtstart').inner_text),
        end_date: OFX::Utils.build_date(stmrs_node.search('banktranlist > dtend').inner_text),
        transactions: build_transactions(node),
        pending_transactions: build_pending_transactions(node),
        pending_transactions_as_of: build_pending_as_of(node),
        cash_advance_balance: OFX::Utils.to_decimal(stmrs_node.search('cashadvbalamt').inner_text),
        interest_rate: OFX::Utils.to_decimal(stmrs_node.search('intrate').inner_text)
      )
    end

    def self.build_transactions(node)
      node.search('banktranlist > stmttrn').collect do |element|
        OFX::Transaction.from_ofx_102(element)
      end
    end

    def self.build_pending_transactions(node)
      node.search('banktranlistp > stmttrnp').collect do |element|
        OFX::Transaction.from_ofx_102(element)
      end
    end

    def self.build_pending_as_of(node)
      date_text = node.search('banktranlistp > dtasof').inner_text
      OFX::Utils.build_date(date_text) if date_text.strip != ''
    rescue StandardError
      nil
    end
  end
end
