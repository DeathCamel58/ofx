module OFX
  module Investment
    module TransactionType
      class SellStock < Foundation
        # @return [OFX::Investment::Aggregates::InvSell]
        attr_accessor :invsell

        # @return TODO: Document this
        attr_accessor :sell_type

        def self.from_ofx_102(node)
          response = new({
                           sell_type: node.search('selltype').inner_text
                         })

          invsell_node = node.search('invsell')
          response.invsell = OFX::Investment::Aggregates::InvSell.from_ofx_102(invsell_node) if invsell_node

          response
        end
      end
    end
  end
end