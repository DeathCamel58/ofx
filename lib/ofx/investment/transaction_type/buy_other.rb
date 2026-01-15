module OFX
  module Investment
    module TransactionType
      class BuyOther < Foundation
        # @return [OFX::Investment::Aggregates::InvBuy]
        attr_accessor :invbuy

        def self.from_ofx_102(node)
          node = normalize_node(node)

          invbuy_node = node.search('invbuy')
          new({
                invbuy: OFX::Investment::Aggregates::InvBuy.from_ofx_102(invbuy_node)
              })
        end
      end
    end
  end
end