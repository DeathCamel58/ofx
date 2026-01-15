module OFX
  module Investment
    module TransactionType
      class SellOption < Foundation
        # @return [OFX::Investment::Aggregates::InvSell]
        attr_accessor :invsell

        # @return [String]
        attr_accessor :opt_sell_type

        # @return TODO: Document this
        attr_accessor :sh_per_contract

        # @return RELFITID used to relate transactions associated with mutual fund exchanges.
        attr_accessor :relfitid

        # @return TODO: Document this
        attr_accessor :reltype

        # @return TODO: Document this
        attr_accessor :secured

        def self.from_ofx_102(node)
          node = normalize_node(node)

          response = new({
                           opt_sell_type: node.search('optselltype').inner_text,
                           sh_per_contract: node.search('shperctrct').inner_text,
                           relfitid: node.search('relfitid').inner_text,
                           reltype: node.search('reltype').inner_text,
                           secured: node.search('secured').inner_text,
                         })

          invsell_node = node.search('invsell')
          response.invsell = OFX::Investment::Aggregates::InvSell.from_ofx_102(invsell_node) if invsell_node

          response
        end
      end
    end
  end
end