module OFX
  module Investment
    # @see https://www.financialdataexchange.org/common/Uploaded%20files/OFX%20files/OFX%20Banking%20Specification%20v2.3.pdf 13.9.2.2 Investment Statement Response <INVSTMTRS>

    class InvestmentStatementResponse < Foundation
      # @return [Time] As of date & time for the statement download
      attr_accessor :date

      # @return [String] Default currency for the statement
      attr_accessor :currency

      # @return [OFX::Investment::Account] Account-from aggregate
      attr_accessor :account

      # @return [Time] Start date for transaction data
      attr_accessor :start_date

      # @return [Time] End date for transaction data
      attr_accessor :end_date

      # @return [Array<OFX::Investment::InvestmentTransaction>] List of statement transactions
      attr_accessor :transactions

      # @return [Array<OFX::Investment::InvestmentPositions>] List of statement positions
      attr_accessor :positions

      # @return [OFX::Investment::InvestmentBalances] Balances aggregate
      attr_accessor :balance

      # @return [Array<OFX::Investment::InvestmentOpenOrders>] List of open orders
      attr_accessor :open_orders

      # @return [OFX::Investment::Investment401k] 401(k) information
      attr_accessor :investment_401k

      # @return [OFX::Investment::Investment401kBalance] 401(k) balance information
      attr_accessor :investment_401k_balance

      def self.from_ofx_102(node)
        node = normalize_node(node)

        new(
          date: OFX::Utils.build_date(node.search('dtasof').inner_text),
          currency: node.search('curdef').inner_text,
          account: OFX::Investment::Account.from_ofx_102(node.search('invacctfrom')),
          start_date: OFX::Utils.build_date(node.search('invtranlist > dtstart').inner_text),
          end_date: OFX::Utils.build_date(node.search('invtranlist > dtend').inner_text),
          transactions: build_transactions(node),
          positions: build_positions(node),
          balance: build_balance(node)
        )
      end

      TRANSACTION_TYPES = {
        'BUYDEBT' => OFX::Investment::TransactionType::BuyDebt,
        'BUYMF' => OFX::Investment::TransactionType::BuyMutualFund,
        'BUYOPT' => OFX::Investment::TransactionType::BuyOption,
        'BUYOTHER' => OFX::Investment::TransactionType::BuyOther,
        'BUYSTOCK' => OFX::Investment::TransactionType::BuyStock,
        'CLOSUREOPT' => OFX::Investment::TransactionType::ClosureOption,
        'INCOME' => OFX::Investment::TransactionType::Income,
        'INVBANKTRAN' => OFX::Investment::TransactionType::BankTransaction,
        'INVEXPENSE' => OFX::Investment::TransactionType::InvestmentExpense,
        'JRNLFUND' => OFX::Investment::TransactionType::JournalFund,
        'JRNLSEC' => OFX::Investment::TransactionType::JournalSecurity,
        'MARGININTEREST' => OFX::Investment::TransactionType::MarginInterest,
        'REINVEST' => OFX::Investment::TransactionType::Reinvest,
        'RETOFCAP' => OFX::Investment::TransactionType::ReturnOfCapital,
        'SELLDEBT' => OFX::Investment::TransactionType::SellDebt,
        'SELLMF' => OFX::Investment::TransactionType::SellMutualFund,
        'SELLOPT' => OFX::Investment::TransactionType::SellOption,
        'SELLOTHER' => OFX::Investment::TransactionType::SellOther,
        'SELLSTOCK' => OFX::Investment::TransactionType::SellStock,
        'SPLIT' => OFX::Investment::TransactionType::Split,
        'TRANSFER' => OFX::Investment::TransactionType::Transfer,
      }.freeze

      def self.build_transactions(node)
        # Transactions can be in <invtranlist> or <invbanktran>
        # This implementation follows the investment transaction structure
        node.search('invtranlist > *').collect do |element|
          tag_name = element.name.upcase

          if tag_name == 'DTSTART'
          # TODO: Handle start date
          elsif tag_name == 'DTEND'
          # TODO: Handle end date'
          elsif tag_name == 'INVBANKTRAN'
            element.search('stmttrn').collect do |stmttrn|
              response = OFX::Investment::TransactionType::BankTransaction.from_ofx_102(stmttrn)
              response.subacctfund = element.search('subacctfund').inner_text
              response
            end
          elsif (klass = TRANSACTION_TYPES[tag_name])
            klass.from_ofx_102(element)
          else
            # No parser for this transaction type
          end
        end.compact
      end

      def self.build_positions(node)
        # Security type specific position aggregates: POSMF, POSSTOCK, POSDEBT, POSOPT, POSOTHER
        node.search('invposlist > *').collect do |element|
          # Placeholder for position parsing logic
        end
      end

      def self.build_balance(node)
        OFX::Investment::Aggregates::InvBalances.from_ofx_102(node.search('invbal'))
      end
    end
  end
end
