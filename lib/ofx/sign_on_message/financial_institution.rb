module OFX
  module SignOnMessage
    # 2.5.1.8 Financial Institution ID <FI>

    class FinancialInstitution < Foundation
      # @return [String] Organization defining this FI name space
      attr_accessor :organization

      # @return [String] Financial Institution ID (unique within <ORG>)
      attr_accessor :id

      # Alias for spec consistency
      alias_method :org, :organization
      alias_method :fid, :id

      def self.from_ofx_102(node)
        node = normalize_node(node)

        return nil if node.empty?

        new({
              organization: node.search('org').inner_text,
              id: node.search('fid').inner_text
            })
      end
    end
  end
end