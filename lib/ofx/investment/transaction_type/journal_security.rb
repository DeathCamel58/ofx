module OFX
  module Investment
    module TransactionType
      class JournalSecurity < Foundation
        # @return [OFX::Investment::Aggregates::InvTran] The transaction
        attr_accessor :invtran

        # @return [OFX::Investment::Aggregates::SecId] The transaction
        attr_accessor :secid

        # @return TODO: Document this
        attr_accessor :subacct_to

        # @return TODO: Document this
        attr_accessor :subacct_from

        # @return TODO: Document this
        attr_accessor :units

        def self.from_ofx_102(node)
          node = normalize_node(node)

          response = new({
                           total: OFX::Utils.to_decimal(node.search('total').inner_text),
                           subacct_to: node.search('subacctto').inner_text,
                           subacct_from: node.search('subacctfrom').inner_text,
                           currency: node.search('currency').inner_text,
                           origcurrency: node.search('origcurrency').inner_text,
                           units: node.search('units').inner_text
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