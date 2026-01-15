describe OFX::Investment::TransactionType::ClosureOption do
  let(:parsed) { OFX::Investment::TransactionType::ClosureOption.from_ofx_102(xml) }

  describe "Good XML" do
    let(:xml) { "
<closureopt>
  <invtran>
    <fitid>2005123100000000012345</fitid>
    <dttrade>20051231000000.000[-5:EST]</dttrade>
    <dtsettle>20051231000000.000[-5:EST]</dtsettle>
    <memo>Intuit Option Expire Jan 01 @ 30.50</memo>
  </invtran>
  <secid>
    <uniqueid>9KG1119KG</uniqueid>
    <uniqueidtype>OTHER</uniqueidtype>
  </secid>
  <optaction>EXPIRE</optaction>
  <units>-1.0000</units>
  <shperctrct>100</shperctrct>
  <subacctsec>OTHER</subacctsec>
</closureopt>
" }

    describe "InvTran" do
      let(:invtran) { parsed.invtran }

      it "returns InvTran type" do
        expect(invtran).to be_a(OFX::Investment::Aggregates::InvTran)
      end

      it "returns fit_id" do
        expect(invtran.fit_id).to eq("2005123100000000012345")
      end

      it "returns settlement_date" do
        expect(invtran.settlement_date).to eq(Time.parse("2005-12-31 00:00:00 -0500"))
      end

      it "returns trade_date" do
        expect(invtran.trade_date).to eq(Time.parse("2005-12-31 00:00:00 -0500"))
      end

      it "returns memo" do
        expect(invtran.memo).to eq("Intuit Option Expire Jan 01 @ 30.50")
      end
    end

    describe "SecId" do
      let(:secid) { parsed.secid }

      it "returns SecId type" do
        expect(secid).to be_a(OFX::Investment::Aggregates::SecId)
      end

      it "returns Unique ID" do
        expect(secid.unique_id).to eq("9KG1119KG")
      end

      it "returns Unique ID Type" do
        expect(secid.unique_id_type).to eq("OTHER")
      end
    end

    it "returns option_action" do
      expect(parsed.option_action).to eq("EXPIRE")
    end

    it "returns units" do
      expect(parsed.units).to eq(BigDecimal('-1.0000'))
    end

    it "returns sh_per_contract" do
      expect(parsed.sh_per_contract).to eq(BigDecimal('100'))
    end

    it "returns subacctsec" do
      expect(parsed.subacctsec).to eq("OTHER")
    end
  end
end
