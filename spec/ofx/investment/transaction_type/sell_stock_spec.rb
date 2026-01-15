describe OFX::Investment::TransactionType::SellStock do
  let(:parsed) { OFX::Investment::TransactionType::SellStock.from_ofx_102(xml) }

  describe "Good XML" do
    let(:xml) { "
<sellstock>
  <invsell>
    <invtran>
      <fitid>SELLSTOCK001</fitid>
      <dttrade>20251022160000</dttrade>
    </invtran>
    <secid>
      <uniqueid>FAKECUSIPSTK</uniqueid>
      <uniqueidtype>CUSIP</uniqueidtype>
    </secid>
    <units>25</units>
    <unitprice>40</unitprice>
    <total>1000</total>
  </invsell>
  <selltype>SELL</selltype>
</sellstock>
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
          expect(invtran.fit_id).to eq("SELLSTOCK001")
        end

        it "returns trade_date" do
          expect(invtran.trade_date).to eq(Time.parse("2025-10-22 16:00:00 +0000"))
        end
      end

      describe "SecId" do
        let(:secid) { invsell.secid }

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
        expect(invsell.units).to eq(25)
      end

      it "returns unit price" do
        expect(invsell.unit_price).to eq(BigDecimal('40'))
      end

      it "returns total" do
        expect(invsell.total).to eq(BigDecimal('1000'))
      end
    end

    it "returns sell_type" do
      expect(parsed.sell_type).to eq("SELL")
    end
  end
end
