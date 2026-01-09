module OFX
  module Investment
    module Aggregates
      # @see https://www.financialdataexchange.org/common/Uploaded%20files/OFX%20files/OFX%20Banking%20Specification%20v2.3.pdf 13.9.2.7 Investment Balances <INVBAL>

      class InvBalances < Foundation
        # @return [BigDecimal] Cash balance across all sub-accounts. Should include sweep funds.
        attr_accessor :available_cash

        # @return [BigDecimal] Margin balance. A positive balance indicates a positive cash balance, while a negative balance indicates the customer has borrowed funds.
        attr_accessor :margin_balance

        # @return [BigDecimal] Market value of all short positions. This is a positive balance
        attr_accessor :short_balance

        # @return [BigDecimal, nil] Buying power
        attr_accessor :buying_power

        # TODO: Handle <BALLIST>

        def self.from_ofx_102(node)
          return nil if node.empty?

          new({
                available_cash: OFX::Utils.to_decimal(node.search('availcash').inner_text),
                margin_balance: OFX::Utils.to_decimal(node.search('marginbalance').inner_text),
                short_balance: OFX::Utils.to_decimal(node.search('shortbalance').inner_text),
                buying_power: OFX::Utils.to_decimal(node.search('buypower').inner_text)
              })
        end
      end
    end
  end
end