module OFX
  module Investment
    module TransactionType
      class MarginInterest < Foundation
        # @return [OFX::Investment::Aggregates::InvTran] The transaction
        attr_accessor :invtran

        # @return [BigDecimal] TODO: Document this
        attr_accessor :total

        # @return TODO: Document this
        attr_accessor :subacctfund

        # @return [String] The currency of the transaction
        attr_accessor :currency

        # @return [String] The original currency of the transaction
        attr_accessor :origcurrency

        def self.from_ofx_102(node)
          node = normalize_node(node)

          response = new({
                           total: OFX::Utils.to_decimal(node.search('total').inner_text),
                           subacctfund: node.search('subacctfund').inner_text,
                           currency: node.search('currency').inner_text,
                           origcurrency: node.search('origcurrency').inner_text
                         })

          tran_node = node.search('invtran')
          response.invtran = OFX::Investment::Aggregates::InvTran.from_ofx_102(tran_node) if tran_node

          response
        end
      end
    end
  end
end