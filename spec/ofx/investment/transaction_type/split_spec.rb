describe OFX::Investment::TransactionType::Split do
  let(:parsed) { OFX::Investment::TransactionType::Split.from_ofx_102(xml) }

  describe "Good XML" do
    let(:xml) { "
<split>
  <invtran>
    <fitid>SPLIT001</fitid>
    <dttrade>20251023160000</dttrade>
  </invtran>
  <secid>
    <uniqueid>FAKECUSIPSTK</uniqueid>
    <uniqueidtype>CUSIP</uniqueidtype>
  </secid>
  <oldunits>50</oldunits>
  <newunits>100</newunits>
  <numerator>2</numerator>
  <denominator>1</denominator>
</split>
" }

    describe "InvTran" do
      let(:invtran) { parsed.invtran }

      it "returns InvTran type" do
        expect(invtran).to be_a(OFX::Investment::Aggregates::InvTran)
      end

      it "returns fit_id" do
        expect(invtran.fit_id).to eq("SPLIT001")
      end

      it "returns trade_date" do
        expect(invtran.trade_date).to eq(Time.parse("2025-10-23 16:00:00 +0000"))
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

    it "returns old_units" do
      expect(parsed.old_units).to eq(50)
    end

    it "returns new_units" do
      expect(parsed.new_units).to eq(100)
    end

    it "returns numerator" do
      expect(parsed.numerator).to eq(BigDecimal('2'))
    end

    it "returns denominator" do
      expect(parsed.denominator).to eq(BigDecimal('1'))
    end
  end
end
