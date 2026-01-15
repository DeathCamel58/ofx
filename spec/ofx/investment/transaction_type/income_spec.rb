describe OFX::Investment::TransactionType::Income do
  let(:parsed) { OFX::Investment::TransactionType::Income.from_ofx_102(xml) }

  describe "Good XML" do
    let(:xml) { "
<income>
  <invtran>
    <fitid>2005011100000000012345</fitid>
    <dttrade>20050111000000.000[-5:EST]</dttrade>
    <dtsettle>20050111000000.000[-5:EST]</dtsettle>
    <memo>Intuit Stock Income Dividend</memo>
  </invtran>
  <secid>
    <uniqueid>888111000</uniqueid>
    <uniqueidtype>CUSIP</uniqueidtype>
  </secid>
  <incometype>DIV</incometype>
  <total>17.00</total>
  <subacctsec>CASH</subacctsec>
  <subacctfund>CASH</subacctfund>
</income>
" }

    describe "InvTran" do
      let(:invtran) { parsed.invtran }

      it "returns InvTran type" do
        expect(invtran).to be_a(OFX::Investment::Aggregates::InvTran)
      end

      it "returns fit_id" do
        expect(invtran.fit_id).to eq("2005011100000000012345")
      end

      it "returns settlement_date" do
        expect(invtran.settlement_date).to eq(Time.parse("2005-01-11 00:00:00 -0500"))
      end

      it "returns trade_date" do
        expect(invtran.trade_date).to eq(Time.parse("2005-01-11 00:00:00 -0500"))
      end

      it "returns memo" do
        expect(invtran.memo).to eq("Intuit Stock Income Dividend")
      end
    end

    describe "SecId" do
      let(:secid) { parsed.secid }

      it "returns SecId type" do
        expect(secid).to be_a(OFX::Investment::Aggregates::SecId)
      end

      it "returns Unique ID" do
        expect(secid.unique_id).to eq("888111000")
      end

      it "returns Unique ID Type" do
        expect(secid.unique_id_type).to eq("CUSIP")
      end
    end

    it "returns incometype" do
      expect(parsed.income_type).to eq("DIV")
    end

    it "returns total" do
      expect(parsed.total).to eq(BigDecimal('17'))
    end

    it "returns subacctsec" do
      expect(parsed.subacctsec).to eq("CASH")
    end

    it "returns subacctfund" do
      expect(parsed.subacctfund).to eq("CASH")
    end
  end
end
