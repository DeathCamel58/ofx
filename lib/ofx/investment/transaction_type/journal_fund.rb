module OFX
  module Investment
    module TransactionType
      class JournalFund < Foundation
        # @return [OFX::Investment::Aggregates::InvTran] The transaction
        attr_accessor :invtran

        # @return Subaccount the money is being transferred to
        attr_accessor :subacct_to

        # @return Subaccount the money is being transferred from
        attr_accessor :subacct_from

        # @return [BigDecimal] The total amount of the transaction
        attr_accessor :total

        def self.from_ofx_102(node)
          node = normalize_node(node)

          response = new({
                           subacct_to: node.search('subacctto').inner_text,
                           subacct_from: node.search('subacctfrom').inner_text,
                           total: OFX::Utils.to_decimal(node.search('total').inner_text)
                         })

          tran_node = node.search('invtran')
          response.invtran = OFX::Investment::Aggregates::InvTran.from_ofx_102(tran_node) if tran_node

          response
        end
      end
    end
  end
end