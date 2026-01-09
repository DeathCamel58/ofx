module OFX
  module Investment
    module Aggregates
      # @see https://www.financialdataexchange.org/common/Uploaded%20files/OFX%20files/OFX%20Banking%20Specification%20v2.3.pdf 13.9.2.4.1 General Transaction Aggregate <INVTRAN>

      class InvTran < Foundation
        # @return [String] Unique FI-assigned transaction ID
        # @note This ID is used to detect duplicate downloads
        attr_accessor :fit_id

        # @return [String] Server assigned transaction ID
        attr_accessor :transaction_id

        # @return [Time] Trade date; for stock splits, day of record
        attr_accessor :trade_date

        # @return [Time] Settlement date; for stock splits, execution date
        attr_accessor :settlement_date

        # TODO: Handle <REVERSALFITID>

        # @return [String] Other information about transaction (at most one)
        attr_accessor :memo

        def self.from_ofx_102(node)
          return nil if node.empty?

          new({
                fit_id: node.search('fitid').inner_text,
                transaction_id: node.search('srvrtid').inner_text,
                trade_date: node.search('dttrade').inner_text,
                settlement_date: node.search('dtsettle').inner_text,
                memo: node.search('memo').inner_text,
              })
        end
      end
    end
  end
end