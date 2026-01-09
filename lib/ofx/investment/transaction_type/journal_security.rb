module OFX
  module Investment
    module TransactionType
      class JournalSecurity < Foundation
        # @return [OFX::Investment::Aggregates::InvTran] The transaction
        attr_accessor :invtran

        # @return [OFX::Investment::Aggregates::SecId] The transaction
        attr_accessor :secid

        # @return [BigDecimal] TODO: Document this
        attr_accessor :total

        # @return TODO: Document this
        attr_accessor :subacctsec

        # @return TODO: Document this
        attr_accessor :subacctfund

        # @return [String] The currency of the transaction
        attr_accessor :currency

        # @return [String] The original currency of the transaction
        attr_accessor :origcurrency

        # @return TODO: Document this
        attr_accessor :inv401k_source

        def self.from_ofx_102(node)
          response = new({
                           total: OFX::Utils.to_decimal(node.search('total').inner_text),
                           subacctsec: node.search('subacctsec').inner_text,
                           subacctfund: node.search('subacctfund').inner_text,
                           currency: node.search('currency').inner_text,
                           origcurrency: node.search('origcurrency').inner_text,
                           inv401k_source: node.search('inv401ksource').inner_text
                         })

          tran_node = node.search('invtran')
          response.invtran = OFX::Investment::Aggregates::InvTran.from_ofx_102(tran_node) if tran_node

          sec_id_node = node.search('secid')
          response.secid = OFX::Investment::Aggregates::SecId.from_ofx_102(sec_id_node) if sec_id_node

          response
        end
      end
    end
  end
end