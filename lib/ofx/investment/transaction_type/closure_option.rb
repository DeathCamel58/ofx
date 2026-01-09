module OFX
  module Investment
    module TransactionType
      class ClosureOption < Foundation
        # @return [OFX::Investment::Aggregates::InvTran] The transaction
        attr_accessor :invtran

        # @return [OFX::Investment::Aggregates::SecId] The transaction
        attr_accessor :secid

        # @return TODO: Document this
        attr_accessor :option_action

        # @return TODO: Document this
        attr_accessor :units

        # @return TODO: Document this
        attr_accessor :sh_per_contract

        # @return TODO: Document this
        attr_accessor :subacctsec

        # @return TODO: Document this
        attr_accessor :relfitid

        # @return TODO: Document
        attr_accessor :gain

        def self.from_ofx_102(node)
          response = new({
                           option_action: node.search('optaction').inner_text,
                           units: node.search('units').inner_text,
                           sh_per_contract: node.search('shperctrct').inner_text,
                           relfitid: node.search('relfitid').inner_text,
                           gain: node.search('gain').inner_text
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