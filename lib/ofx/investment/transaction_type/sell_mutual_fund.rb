module OFX
  module Investment
    module TransactionType
      class SellMutualFund < Foundation
        # @return [OFX::Investment::Aggregates::InvSell]
        attr_accessor :invsell

        # @return [String] TODO: Document this
        attr_accessor :sell_type

        # @return [BigDecimal] The average cost basis
        attr_accessor :avg_cost_basis

        # @return RELFITID used to relate transactions associated with mutual fund exchanges.
        attr_accessor :relfitid

        def self.from_ofx_102(node)
          response = new({
                           sell_type: node.search('selltype').inner_text,
                           avg_cost_basis: OFX::Utils.to_decimal(node.search('avgcostbasis').inner_text),
                           relfitid: node.search('relfitid').inner_text
                         })

          invsell_node = node.search('invsell')
          response.invsell = OFX::Investment::Aggregates::InvSell.from_ofx_102(invsell_node) if invsell_node

          response
        end
      end
    end
  end
end