describe OFX::Investment::TransactionType::Reinvest do
  let(:parsed) { OFX::Investment::TransactionType::Reinvest.from_ofx_102(xml) }

  describe "Good XML" do
    let(:xml) { "
<reinvest>
  <invtran>
    <fitid>2005082300000000012345</fitid>
    <dttrade>20050823000000.000[-5:EST]</dttrade>
    <dtsettle>20050823000000.000[-5:EST]</dtsettle>
    <memo>Mutual Fund Dividend Automatically Reinvested</memo>
  </invtran>
  <secid>
    <uniqueid>151515151</uniqueid>
    <uniqueidtype>CUSIP</uniqueidtype>
  </secid>
  <incometype>DIV</incometype>
  <total>-9.02</total>
  <subacctsec>CASH</subacctsec>
  <units>9.02</units>
  <unitprice>1</unitprice>
</reinvest>
" }

    describe "InvTran" do
      let(:invtran) { parsed.invtran }

      it "returns InvTran type" do
        expect(invtran).to be_a(OFX::Investment::Aggregates::InvTran)
      end

      it "returns fit_id" do
        expect(invtran.fit_id).to eq("2005082300000000012345")
      end

      it "returns trade_date" do
        expect(invtran.trade_date).to eq(Time.parse("2005-08-23 00:00:00 -0500"))
      end

      it "returns settlement_date" do
        expect(invtran.settlement_date).to eq(Time.parse("2005-08-23 00:00:00 -0500"))
      end
    end

    describe "SecId" do
      let(:secid) { parsed.secid }

      it "returns SecId type" do
        expect(secid).to be_a(OFX::Investment::Aggregates::SecId)
      end

      it "returns Unique ID" do
        expect(secid.unique_id).to eq("151515151")
      end

      it "returns Unique ID Type" do
        expect(secid.unique_id_type).to eq("CUSIP")
      end
    end

    it "returns income_type" do
      expect(parsed.income_type).to eq("DIV")
    end

    it "returns total" do
      expect(parsed.total).to eq(BigDecimal('-9.02'))
    end

    it "returns subacctsec" do
      expect(parsed.subacctsec).to eq("CASH")
    end

    it "returns units" do
      expect(parsed.units).to eq(BigDecimal('9.02'))
    end

    it "returns unit_price" do
      expect(parsed.unit_price).to eq(BigDecimal('1'))
    end
  end
end
