module OFX
  module Investment
    module TransactionType
      class BuyOption < Foundation
        # @return [OFX::Investment::Aggregates::InvBuy]
        attr_accessor :invbuy

        # @return [String] The BUYTOOPEN buy type is like “ordinary” buying of option and works like stocks.
        attr_accessor :opt_buy_type

        # @return TODO: Document this
        attr_accessor :sh_per_contract

        def self.from_ofx_102(node)
          response = new({
                           opt_buy_type: node.search('optbuytype').inner_text,
                           sh_per_contract: node.search('shperctrct').inner_text
                         })

          invbuy_node = node.search('invbuy')
          response.invbuy = OFX::Investment::Aggregates::InvBuy.from_ofx_102(invbuy_node) if invbuy_node

          response
        end
      end
    end
  end
end