module OFX
  module Investment
    module TransactionType
      class BuyMutualFund < Foundation
        # @return [OFX::Investment::Aggregates::InvBuy]
        attr_accessor :invbuy

        # @return [String] The BUYTOCOVER buy type used to close short sales.
        attr_accessor :buy_type

        # @return RELFITID used to relate transactions associated with mutual fund exchanges.
        attr_accessor :relfitid

        def self.from_ofx_102(node)
          node = normalize_node(node)

          response = new({
                           buy_type: node.search('buytype').inner_text,
                           relfitid: node.search('relfitid').inner_text
                         })

          invbuy_node = node.search('invbuy')
          response.invbuy = OFX::Investment::Aggregates::InvBuy.from_ofx_102(invbuy_node) if invbuy_node

          response
        end
      end
    end
  end
end