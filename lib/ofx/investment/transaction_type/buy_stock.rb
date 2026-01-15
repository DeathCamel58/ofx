module OFX
  module Investment
    module TransactionType
      class BuyStock < Foundation
        # @return [OFX::Investment::Aggregates::InvBuy]
        attr_accessor :invbuy

        # @return [String] The BUYTOCOVER buy type used to close short sales.
        attr_accessor :buy_type

        def self.from_ofx_102(node)
          node = normalize_node(node)

          response = new({
                           buy_type: node.search('buytype').inner_text
                         })

          invbuy_node = node.search('invbuy')
          response.invbuy = OFX::Investment::Aggregates::InvBuy.from_ofx_102(invbuy_node) if invbuy_node

          response
        end
      end
    end
  end
end