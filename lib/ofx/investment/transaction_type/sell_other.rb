module OFX
  module Investment
    module TransactionType
      class SellOther < Foundation
        # @return [OFX::Investment::Aggregates::InvSell]
        attr_accessor :invsell

        def self.from_ofx_102(node)
          response = new({})

          invsell_node = node.search('invsell')
          response.invsell = OFX::Investment::Aggregates::InvSell.from_ofx_102(invsell_node) if invsell_node

          response
        end
      end
    end
  end
end