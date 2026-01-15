module OFX
  module Investment
    module Aggregates
      # @see https://www.financialdataexchange.org/common/Uploaded%20files/OFX%20files/OFX%20Banking%20Specification%20v2.3.pdf 13.9.2.4.3 Investment Buy/Sell Aggregates <INVBUY>/<INVSELL>
      # InvSell

      class InvSell < Foundation
        # @return [OFX::Investment::Aggregates::InvTran] The transaction
        attr_accessor :invtran

        # @return [OFX::Investment::Aggregates::SecId] The transaction
        attr_accessor :secid

        # @return [BigDecimal] The quantity of shares bought or sold
        attr_accessor :units

        # @return [BigDecimal] The price per share
        attr_accessor :unit_price

        # @return [BigDecimal] TODO: Document this
        attr_accessor :markdown

        # @return [BigDecimal] The commission paid for the transaction
        attr_accessor :commission

        # @return [BigDecimal] TODO: Document this
        attr_accessor :taxes

        # @return [BigDecimal] TODO: Document this
        attr_accessor :fees

        # @return TODO: Document this
        attr_accessor :load

        # @return TODO: Document this
        attr_accessor :withholding

        # @return TODO: Document this
        attr_accessor :tax_exempt

        # @return [BigDecimal] TODO: Document this
        attr_accessor :total

        # @return [BigDecimal] TODO: Document this
        attr_accessor :gain

        # @return [String] The currency of the transaction
        attr_accessor :currency

        # @return [String] The original currency of the transaction
        attr_accessor :origcurrency

        # @return TODO: Document this
        attr_accessor :subacctsec

        # @return TODO: Document this
        attr_accessor :subacctfund

        # @return TODO: Document this
        attr_accessor :loan_id

        # @return TODO: Document this
        attr_accessor :state_withholding

        # @return TODO: Document this
        attr_accessor :penalty

        # @return TODO: Document this
        attr_accessor :inv401k_source

        def self.from_ofx_102(node)
          node = normalize_node(node)

          response = new({
                           units: OFX::Utils.to_decimal(node.search('units').inner_text),
                           unit_price: OFX::Utils.to_decimal(node.search('unitprice').inner_text),
                           markdown: OFX::Utils.to_decimal(node.search('markdown').inner_text),
                           commission: OFX::Utils.to_decimal(node.search('commission').inner_text),
                           taxes: OFX::Utils.to_decimal(node.search('taxes').inner_text),
                           fees: OFX::Utils.to_decimal(node.search('fees').inner_text),
                           load: node.search('load').inner_text,
                           withholding: node.search('withholding').inner_text,
                           tax_exempt: node.search('taxexempt').inner_text == 'Y',
                           total: OFX::Utils.to_decimal(node.search('total').inner_text),
                           gain: OFX::Utils.to_decimal(node.search('gain').inner_text),
                           currency: node.search('currency').inner_text,
                           origcurrency: node.search('origcurrency').inner_text,
                           subacctsec: node.search('subacctsec').inner_text,
                           subacctfund: node.search('subacctfund').inner_text,
                           loan_id: node.search('loanid').inner_text,
                           state_withholding: node.search('statewithholding').inner_text,
                           penalty: node.search('penalty').inner_text,
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