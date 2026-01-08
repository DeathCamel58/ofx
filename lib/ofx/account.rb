module OFX
  # 11.3.1 Banking Account <BANKACCTFROM> and <BANKACCTTO>
  # @note This isn't strictly the OFX spec data, but also some computed data

  class Account < Foundation
    attr_accessor :balance

    # Bank Identifier (usage varies by country)
    attr_accessor :bank_id

    # Branch Identifier (usage varies by country)
    attr_accessor :branch_id
    attr_accessor :account_number
    attr_accessor :currency

    # Account number
    attr_accessor :id
    attr_accessor :transactions

    # Type of account
    attr_accessor :type
    attr_accessor :available_balance

    # Checksum (usage varies by country)
    attr_accessor :acctkey

    ACCOUNT_TYPES = {
      'CHECKING' => :checking,
      'SAVINGS' => :savings,
      'CREDITLINE' => :creditline,
      'CD' => :cd,
      'MONEYMRKT' => :moneymrkt
    }.freeze

    def self.from_ofx_102(node)
      new({
            bank_id: node.search('bankacctfrom > bankid').inner_text,
            branch_id: node.search('bankacctfrom > branchid').inner_text,
            id: node.search('bankacctfrom > acctid, ccacctfrom > acctid').inner_text,
            type: ACCOUNT_TYPES[node.search('bankacctfrom > accttype').inner_text.to_s.upcase],
            transactions: OFX::Statement.build_transactions(node),
            balance: build_balance(node),
            available_balance: build_available_balance(node),
            currency: node.search('stmtrs > curdef, ccstmtrs > curdef').inner_text,
            acctkey: node.search('bankacctfrom > acctkey').inner_text
          })
    end

    def self.build_balance(node)
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

    def self.build_available_balance(node)
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
