describe OFX::Investment::TransactionType::SellMutualFund do
  let(:parsed) { OFX::Investment::TransactionType::SellMutualFund.from_ofx_102(xml) }

  describe "Good XML" do
    let(:xml) { "
<sellmf>
  <invsell>
    <invtran>
      <fitid>SELLMF001</fitid>
      <dttrade>20251019160000</dttrade>
    </invtran>
    <secid>
      <uniqueid>FAKECUSIPMF</uniqueid>
      <uniqueidtype>CUSIP</uniqueidtype>
    </secid>
    <units>-10</units>
    <unitprice>55</unitprice>
    <total>550</total>
  </invsell>
  <avgcostbasis>50.22</avgcostbasis>
  <selltype>SELL</selltype>
</sellmf>
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
          expect(invtran.fit_id).to eq("SELLMF001")
        end

        it "returns trade_date" do
          expect(invtran.trade_date).to eq(Time.parse("2025-10-19 16:00:00 +0000"))
        end
      end

      describe "SecId" do
        let(:secid) { invsell.secid }

        it "returns SecId type" do
          expect(secid).to be_a(OFX::Investment::Aggregates::SecId)
        end

        it "returns Unique ID" do
          expect(secid.unique_id).to eq("FAKECUSIPMF")
        end

        it "returns Unique ID Type" do
          expect(secid.unique_id_type).to eq("CUSIP")
        end
      end

      it "returns units" do
        expect(invsell.units).to eq(-10)
      end

      it "returns unit price" do
        expect(invsell.unit_price).to eq(BigDecimal('55'))
      end

      it "returns total" do
        expect(invsell.total).to eq(BigDecimal('550'))
      end
    end

    it "returns sell_type" do
      expect(parsed.sell_type).to eq("SELL")
    end

    it "returns avg_cost_basis" do
      expect(parsed.avg_cost_basis).to eq(BigDecimal('50.22'))
    end
  end
end
