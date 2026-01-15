describe OFX::Investment::TransactionType::Transfer do
  let(:parsed) { OFX::Investment::TransactionType::Transfer.from_ofx_102(xml) }

  describe "Good XML" do
    let(:xml) { "
<transfer>
  <invtran>
    <fitid>TRANSFER001</fitid>
    <dttrade>20251024160000</dttrade>
  </invtran>
  <secid>
    <uniqueid>FAKECUSIPSTK</uniqueid>
    <uniqueidtype>CUSIP</uniqueidtype>
  </secid>
  <units>100</units>
  <tferaction>IN</tferaction>
  <postype>LONG</postype>
</transfer>
" }

    describe "InvTran" do
      let(:invtran) { parsed.invtran }

      it "returns InvTran type" do
        expect(invtran).to be_a(OFX::Investment::Aggregates::InvTran)
      end

      it "returns fit_id" do
        expect(invtran.fit_id).to eq("TRANSFER001")
      end

      it "returns trade_date" do
        expect(invtran.trade_date).to eq(Time.parse("2025-10-24 16:00:00 +0000"))
      end
    end

    describe "SecId" do
      let(:secid) { parsed.secid }

      it "returns SecId type" do
        expect(secid).to be_a(OFX::Investment::Aggregates::SecId)
      end

      it "returns Unique ID" do
        expect(secid.unique_id).to eq("FAKECUSIPSTK")
      end

      it "returns Unique ID Type" do
        expect(secid.unique_id_type).to eq("CUSIP")
      end
    end

    it "returns units" do
      expect(parsed.units).to eq(100)
    end

    it "returns tfer_action" do
      expect(parsed.tfer_action).to eq("IN")
    end

    it "returns pos_type" do
      expect(parsed.pos_type).to eq("LONG")
    end
  end
end
