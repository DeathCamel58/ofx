module OFX
  module Investment
    module TransactionType
      # @see https://www.financialdataexchange.org/common/Uploaded%20files/OFX%20files/OFX%20Banking%20Specification%20v2.3.pdf 13.9.2.3 Bank Transactions <INVBANKTRAN>
      #
      # @note OFX Spec says this should contain a list of all transactions from a bank account, but we're using this as a single transaction for simplicity. This allows us to count the TXs in an investment account by just checking `investment_statement.transactions.size`

      class BankTransaction < Foundation
        # @return [OFX::Transaction] Statement transaction
        attr_accessor :transaction

        # @return TODO: Document this
        attr_accessor :subacctfund

        def self.from_ofx_102(node)
          new({
                transaction: OFX::Transaction.from_ofx_102(node),
              })
        end
      end
    end
  end
end