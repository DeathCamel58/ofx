describe OFX::Investment::TransactionType::BuyStock do
  let(:parsed) { OFX::Investment::TransactionType::BuyStock.from_ofx_102(xml) }

  describe "Good XML" do
    let(:xml) { "
<buystock>
  <invbuy>
    <invtran>
      <fitid>729483191</fitid>
      <dttrade>20170203</dttrade>
      <dtsettle>20170207</dtsettle>
    </invtran>
    <secid>
      <uniqueid>78462F103</uniqueid>
      <uniqueidtype>CUSIP</uniqueidtype>
    </secid>
    <units>100</units>
    <unitprice>229.00</unitprice>
    <commission>9.00</commission>
    <total>-22909.00</total>
    <subacctsec>CASH</subacctsec>
    <subacctfund>CASH</subacctfund>
  </invbuy>
  <buytype>BUY</buytype>
</buystock>
" }

    it "returns buytype" do
      expect(parsed.buy_type).to eq("BUY")
    end

    describe "InvBuy" do
      let(:invbuy) { parsed.invbuy }

      it "returns InvBuy type" do
        expect(invbuy).to be_a(OFX::Investment::Aggregates::InvBuy)
      end

      describe "InvTran" do
        let(:invtran) { invbuy.invtran }

        it "returns InvTran type" do
          expect(invtran).to be_a(OFX::Investment::Aggregates::InvTran)
        end

        it "returns fit_id" do
          expect(invtran.fit_id).to eq("729483191")
        end

        it "returns settlement_date" do
          expect(invtran.settlement_date).to eq(Time.parse("2017-02-07 00:00:00 +0000"))
        end

        it "returns trade_date" do
          expect(invtran.trade_date).to eq(Time.parse("2017-02-03 00:00:00 +0000"))
        end
      end

      describe "SecId" do
        let(:secid) { invbuy.secid }

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
        expect(invbuy.units).to eq(100)
      end

      it "returns unit price" do
        expect(invbuy.unit_price).to eq(BigDecimal('229.00'))
      end

      it "returns commission" do
        expect(invbuy.commission).to eq(BigDecimal('9.00'))
      end

      it "returns total" do
        expect(invbuy.total).to eq(BigDecimal('-22909.00'))
      end

      it "returns subacctsec" do
        expect(invbuy.subacctsec).to eq("CASH")
      end

      it "returns subacctfund" do
        expect(invbuy.subacctfund).to eq("CASH")
      end
    end
  end
end
