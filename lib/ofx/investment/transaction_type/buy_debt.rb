module OFX
  module Investment
    module TransactionType
      class BuyDebt < Foundation
        # @return [String] Buy stock aggregate
        attr_accessor :invbuy

        # @return [BigDecimal] Accrued interest. This amount is not reflected in the <TOTAL> field of a containing aggregate.
        attr_accessor :accrued_interest

        def self.from_ofx_102(node)
          response = new({
                           accrued_interest: OFX::Utils.to_decimal(node.search('accrdint').inner_text)
                         })

          invbuy_node = node.search('invbuy')
          response.invbuy = OFX::Investment::Aggregates::InvBuy.from_ofx_102(invbuy_node) if invbuy_node

          response
        end
      end
    end
  end
end