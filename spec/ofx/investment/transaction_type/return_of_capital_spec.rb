describe OFX::Investment::TransactionType::ReturnOfCapital do
  let(:parsed) { OFX::Investment::TransactionType::ReturnOfCapital.from_ofx_102(xml) }

  describe "Good XML" do
    let(:xml) { "
<retofcap>
  <invtran>
    <fitid>129837-1111</fitid>
    <dttrade>20170203</dttrade>
  </invtran>
  <secid>
    <uniqueid>78462F103</uniqueid>
    <uniqueidtype>CUSIP</uniqueidtype>
  </secid>
  <total>2300.00</total>
  <subacctsec>CASH</subacctsec>
  <subacctfund>CASH</subacctfund>
</retofcap>
" }

    describe "InvTran" do
      let(:invtran) { parsed.invtran }

      it "returns InvTran type" do
        expect(invtran).to be_a(OFX::Investment::Aggregates::InvTran)
      end

      it "returns fit_id" do
        expect(invtran.fit_id).to eq("129837-1111")
      end

      it "returns trade_date" do
        expect(invtran.trade_date).to eq(Time.parse("2017-02-03 00:00:00 +0000"))
      end
    end

    describe "SecId" do
      let(:secid) { parsed.secid }

      it "returns SecId type" do
        expect(secid).to be_a(OFX::Investment::Aggregates::SecId)
      end

      it "returns Unique ID" do
        expect(secid.unique_id).to eq("78462F103")
      end

      it "returns Unique ID Type" do
        expect(secid.unique_id_type).to eq("CUSIP")
      end
    end

    it "returns total" do
      expect(parsed.total).to eq(BigDecimal('2300.00'))
    end

    it "returns subacctsec" do
      expect(parsed.subacctsec).to eq("CASH")
    end

    it "returns subacctfund" do
      expect(parsed.subacctfund).to eq("CASH")
    end
  end
end
