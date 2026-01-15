module OFX
  module Investment
    module TransactionType
      class Transfer < Foundation
        # @return [OFX::Investment::Aggregates::InvTran] The transaction
        attr_accessor :invtran

        # @return [OFX::Investment::Aggregates::SecId] The transaction
        attr_accessor :secid

        # @return TODO: Document this
        attr_accessor :subacctsec

        # @return [BigDecimal] The quantity of shares bought or sold
        attr_accessor :units

        # @return TODO: Document this
        attr_accessor :tfer_action

        # @return TODO: Document this
        attr_accessor :pos_type

        # @return TODO: Document this
        attr_accessor :invacct_from

        # @return [BigDecimal] The average cost basis
        attr_accessor :avg_cost_basis

        # @return [BigDecimal] The price per share
        attr_accessor :unit_price

        # @return TODO: Document this
        attr_accessor :dt_purchase

        # @return TODO: Document this
        attr_accessor :inv401k_source

        def self.from_ofx_102(node)
          node = normalize_node(node)

          response = new({
                           subacctsec: node.search('subacctsec').inner_text,
                           units: OFX::Utils.to_decimal(node.search('units').inner_text),
                           tfer_action: node.search('tferaction').inner_text,
                           pos_type: node.search('postype').inner_text,
                           invacct_from: node.search('invacctfrom').inner_text,
                           avg_cost_basis: OFX::Utils.to_decimal(node.search('avgcostbasis').inner_text),
                           unit_price: OFX::Utils.to_decimal(node.search('unitprice').inner_text),
                           dt_purchase: OFX::Utils.build_date(node.search('dt_purchase').inner_text),
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