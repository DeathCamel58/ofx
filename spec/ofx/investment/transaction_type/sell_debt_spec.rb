describe OFX::Investment::TransactionType::SellDebt do
  let(:parsed) { OFX::Investment::TransactionType::SellDebt.from_ofx_102(xml) }

  describe "Good XML" do
    let(:xml) { "
<selldebt>
  <invsell>
    <invtran>
      <fitid>129837-1111</fitid>
      <dttrade>20170203</dttrade>
    </invtran>
    <secid>
      <uniqueid>78462F103</uniqueid>
      <uniqueidtype>CUSIP</uniqueidtype>
    </secid>
    <units>100</units>
    <unitprice>229.00</unitprice>
    <total>-22090.26</total>
    <subacctsec>CASH</subacctsec>
    <subacctfund>CASH</subacctfund>
  </invsell>
  <sellreason>SELL</sellreason>
</selldebt>
" }
    describe "InvSell" do
      let(:invsell) { parsed.invsell }

      it "returns InvSell type" do
        expect(invsell).to be_a(OFX::Investment::Aggregates::InvSell)
      end

      describe "InvTran" do
        let(:invtran) { invsell.invtran }

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
        let(:secid) { invsell.secid }

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

      it "returns units" do
        expect(invsell.units).to eq(100)
      end

      it "returns unit price" do
        expect(invsell.unit_price).to eq(BigDecimal('229.00'))
      end

      it "returns total" do
        expect(invsell.total).to eq(BigDecimal('-22090.26'))
      end

      it "returns subacctsec" do
        expect(invsell.subacctsec).to eq("CASH")
      end

      it "returns subacctfund" do
        expect(invsell.subacctfund).to eq("CASH")
      end
    end

    it "returns sell_reason" do
      expect(parsed.sell_reason).to eq("SELL")
    end
  end
end
