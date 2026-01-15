module OFX
  class Foundation
    def self.normalize_node(node)
      return node if node.is_a?(Nokogiri::XML::NodeSet)
      return node if node.is_a?(Nokogiri::XML::DocumentFragment)
      return node.root if node.is_a?(Nokogiri::XML::Document)
      return Nokogiri::XML.parse(node.to_s).root if node.is_a?(String)

      node
    end

    def initialize(attrs)
      attrs.each do |key, value|
        send("#{key}=", value)
      end
    end
  end
end