module OFX
  module Investment
    module TransactionType
      class Split < Foundation
        # @return [OFX::Investment::Aggregates::InvTran] The transaction
        attr_accessor :invtran

        # @return [OFX::Investment::Aggregates::SecId] The transaction
        attr_accessor :secid

        # @return TODO: Document this
        attr_accessor :subacctsec

        # @return [BigDecimal] TODO: Document this
        attr_accessor :old_units

        # @return [BigDecimal] TODO: Document this
        attr_accessor :new_units

        # @return [BigDecimal] TODO: Document this
        attr_accessor :numerator

        # @return [BigDecimal] TODO: Document this
        attr_accessor :denominator

        # @return [String] The currency of the transaction
        attr_accessor :currency

        # @return [String] The original currency of the transaction
        attr_accessor :origcurrency

        # @return TODO: Document this
        attr_accessor :fracccash

        # @return TODO: Document this
        attr_accessor :subacctfund

        # @return TODO: Document this
        attr_accessor :inv401k_source

        def self.from_ofx_102(node)
          response = new({
                           subacctsec: node.search('subacctsec').inner_text,
                           old_units: OFX::Utils.to_decimal(node.search('oldunits').inner_text),
                           new_units: OFX::Utils.to_decimal(node.search('newunits').inner_text),
                           numerator: OFX::Utils.to_decimal(node.search('numerator').inner_text),
                           denominator: OFX::Utils.to_decimal(node.search('denominator').inner_text),
                           currency: node.search('currency').inner_text,
                           origcurrency: node.search('origcurrency').inner_text,
                           fracccash: node.search('fracccash').inner_text,
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