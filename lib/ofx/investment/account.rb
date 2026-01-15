module OFX
  module Investment
    # @see https://www.financialdataexchange.org/common/Uploaded%20files/OFX%20files/OFX%20Banking%20Specification%20v2.3.pdf 13.6.1 Specifying the Investment Account <INVACCTFROM>

    class Account < Foundation
      # @return [String] Unique identifier for the FI
      attr_accessor :broker_id

      # @return [String] Account number at FI
      attr_accessor :account_id

      # Alias for spec consistency
      alias_method :org, :broker_id
      alias_method :id, :account_id

      def self.from_ofx_102(node)
        node = normalize_node(node)

        return nil if node.empty?

        new({
              broker_id: node.search('brokerid').inner_text,
              account_id: node.search('acctid').inner_text
            })
      end
    end
  end
end