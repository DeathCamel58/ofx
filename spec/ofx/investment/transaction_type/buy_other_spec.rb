describe OFX::Investment::TransactionType::BuyOption do
  let(:parsed) { OFX::Investment::TransactionType::BuyOption.from_ofx_102(xml) }

  describe "Good XML" do
    let(:xml) { "
<buyother>
  <invbuy>
    <invtran>
      <fitid>2005010900000000012345</fitid>
      <dttrade>20050109000000.000[-5:EST]</dttrade>
      <dtsettle>20050109000000.000[-5:EST]</dtsettle>
      <memo>Other Security Type Purchase</memo>
    </invtran>
    <secid>
      <uniqueid>693HAY101</uniqueid>
      <uniqueidtype>CUSIP</uniqueidtype>
    </secid>
    <units>25000</units>
    <unitprice>1.000000</unitprice>
    <commission>10.00</commission>
    <taxes>0.25</taxes>
    <fees>1.75</fees>
    <load>3.00</load>
    <total>-25015.0000</total>
    <subacctsec>CASH</subacctsec>
    <subacctfund>CASH</subacctfund>
  </invbuy>
</buyother>
" }

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
          expect(invtran.fit_id).to eq("2005010900000000012345")
        end

        it "returns settlement_date" do
          expect(invtran.settlement_date).to eq(Time.parse("2005-01-09 00:00:00 -0500"))
        end

        it "returns trade_date" do
          expect(invtran.trade_date).to eq(Time.parse("2005-01-09 00:00:00 -0500"))
        end

        it "returns memo" do
          expect(invtran.memo).to eq("Other Security Type Purchase")
        end
      end

      describe "SecId" do
        let(:secid) { invbuy.secid }

        it "returns SecId type" do
          expect(secid).to be_a(OFX::Investment::Aggregates::SecId)
        end

        it "returns Unique ID" do
          expect(secid.unique_id).to eq("693HAY101")
        end

        it "returns Unique ID Type" do
          expect(secid.unique_id_type).to eq("CUSIP")
        end
      end

      it "returns units" do
        expect(invbuy.units).to eq(25000)
      end

      it "returns unit price" do
        expect(invbuy.unit_price).to eq(BigDecimal('1'))
      end

      it "returns commission" do
        expect(invbuy.commission).to eq(BigDecimal('10'))
      end

      it "returns taxes" do
        expect(invbuy.taxes).to eq(BigDecimal('0.25'))
      end

      it "returns fees" do
        expect(invbuy.fees).to eq(BigDecimal('1.75'))
      end

      it "returns load" do
        expect(invbuy.load).to eq(BigDecimal('3'))
      end

      it "returns total" do
        expect(invbuy.total).to eq(BigDecimal('-25015.0000'))
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
