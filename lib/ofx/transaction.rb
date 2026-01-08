module OFX
  class Transaction < Foundation
    # @return [BigDecimal] Amount of transaction
    attr_accessor :amount

    # @return [String] Check (or other reference) number
    attr_accessor :check_number

    # @return [String] Transaction ID issued by financial institution
    attr_accessor :fit_id

    # @return [String] Extra information
    attr_accessor :memo

    # @return [String] Name of payee or description of transaction
    attr_accessor :name

    # @return [String] Payee aggregate
    attr_accessor :payee

    # @return [Time] Date transaction was posted to account
    attr_accessor :posted_at

    # @return [Time, nil] Date user initiated transaction, if known
    attr_accessor :occurred_at

    # @return [Time, nil] Date funds are available (value date)
    attr_accessor :available_at

    # @return [String] Reference number that uniquely identifies the transaction
    attr_accessor :ref_number

    # @return [Symbol] Transaction type
    attr_accessor :type

    # @return [String] Standard Industrial Code
    attr_accessor :sic

    # @return [String] Server assigned transaction ID
    attr_accessor :server_id

    # @return [String] FITID of a previously sent transaction that is corrected by this record
    attr_accessor :correction_id

    # @return [String] Actions can be REPLACE or DELETE
    attr_accessor :correction_action

    TRANSACTION_TYPES = %w[
        ATM CASH CHECK CREDIT DEBIT DEP DIRECTDEBIT DIRECTDEP DIV
        FEE HOLD INT OTHER PAYMENT POS REPEATPMT SRVCHG XFER IN OUT
      ].each_with_object({}) do |tran_type, hash|
      hash[tran_type] = tran_type.downcase.to_sym
    end

    def self.from_ofx_102(node)
      occurred_at = begin
                      OFX::Utils.build_date(node.search('dtuser').inner_text)
                    rescue StandardError
                      nil
                    end

      available_at = begin
                       OFX::Utils.build_date(node.search('dtavail').inner_text)
                     rescue StandardError
                       nil
                     end

      new({
            amount: OFX::Utils.to_decimal(node.search('trnamt').inner_text),
            fit_id: node.search('fitid').inner_text,
            memo: node.search('memo').inner_text,
            name: node.search('name').inner_text,
            payee: node.search('payee').inner_text,
            check_number: node.search('checknum').inner_text,
            ref_number: node.search('refnum').inner_text,
            posted_at: OFX::Utils.build_date(node.search('dtposted').inner_text),
            occurred_at: occurred_at,
            available_at: available_at,
            type: TRANSACTION_TYPES[node.search('trntype').inner_text.to_s.upcase],
            sic: node.search('sic').inner_text,
            server_id: node.search('srvrtid').inner_text,
            correction_id: node.search('correctfitid').inner_text,
            correction_action: node.search('correctaction').inner_text
          })
    end
  end
end
