describe OFX::Investment::TransactionType::SellOther do
  let(:parsed) { OFX::Investment::TransactionType::SellOther.from_ofx_102(xml) }

  describe "Good XML" do
    let(:xml) { "
<sellother>
  <invsell>
    <invtran>
      <fitid>SELLOTHER001</fitid>
      <dttrade>20251021160000</dttrade>
    </invtran>
    <secid>
      <uniqueid>FAKECUSIPOTH</uniqueid>
      <uniqueidtype>CUSIP</uniqueidtype>
    </secid>
    <units>1</units>
    <unitprice>250</unitprice>
    <total>250</total>
  </invsell>
</sellother>
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
          expect(invtran.fit_id).to eq("SELLOTHER001")
        end

        it "returns trade_date" do
          expect(invtran.trade_date).to eq(Time.parse("2025-10-21 16:00:00 +0000"))
        end
      end

      describe "SecId" do
        let(:secid) { invsell.secid }

        it "returns SecId type" do
          expect(secid).to be_a(OFX::Investment::Aggregates::SecId)
        end

        it "returns Unique ID" do
          expect(secid.unique_id).to eq("FAKECUSIPOTH")
        end

        it "returns Unique ID Type" do
          expect(secid.unique_id_type).to eq("CUSIP")
        end
      end

      it "returns units" do
        expect(invsell.units).to eq(1)
      end

      it "returns unit price" do
        expect(invsell.unit_price).to eq(BigDecimal('250'))
      end

      it "returns total" do
        expect(invsell.total).to eq(BigDecimal('250'))
      end
    end
  end
end
