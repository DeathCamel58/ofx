module OFX
  module Investment
    module Aggregates
      # @see https://www.financialdataexchange.org/common/Uploaded%20files/OFX%20files/OFX%20Banking%20Specification%20v2.3.pdf 13.9.2.4.1 General Transaction Aggregate <INVTRAN>

      class SecId < Foundation
        # @return [String] Unique identifier for the security.
        # @note CUSIP for US FIs.
        attr_accessor :unique_id

        # @return [String] Name of standard used to identify the security
        # @note “CUSIP” for FIs in the United States
        attr_accessor :unique_id_type

        def self.from_ofx_102(node)
          node = normalize_node(node)

          return nil if node.empty?

          new({
                unique_id: node.search('uniqueid').inner_text,
                unique_id_type: node.search('uniqueidtype').inner_text
              })
        end
      end
    end
  end
end