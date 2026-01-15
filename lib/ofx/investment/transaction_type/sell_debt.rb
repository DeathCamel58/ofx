module OFX
  module Investment
    module TransactionType
      class SellDebt < Foundation
        # @return [OFX::Investment::Aggregates::InvSell]
        attr_accessor :invsell

        # @return [String] TODO: Document this
        attr_accessor :sell_reason

        # @return [BigDecimal] Accrued interest.
        attr_accessor :accrued_interest

        def self.from_ofx_102(node)
          response = new({
                           sell_reason: node.search('sellreason').inner_text,
                           accrued_interest: OFX::Utils.to_decimal(node.search('accrdint').inner_text)
                         })

          invsell_node = node.search('invsell')
          response.invsell = OFX::Investment::Aggregates::InvSell.from_ofx_102(invsell_node) if invsell_node

          response
        end
      end
    end
  end
end