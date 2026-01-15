describe OFX::Investment::TransactionType::SellOption do
  let(:parsed) { OFX::Investment::TransactionType::SellOption.from_ofx_102(xml) }

  describe "Good XML" do
    let(:xml) { "
<sellopt>
  <invsell>
    <invtran>
      <fitid>SELLOPT001</fitid>
      <dttrade>20251020160000</dttrade>
    </invtran>
    <secid>
      <uniqueid>FAKECUSIPOPT</uniqueid>
      <uniqueidtype>CUSIP</uniqueidtype>
    </secid>
    <units>5</units>
    <unitprice>15</unitprice>
    <total>75</total>
  </invsell>
  <optselltype>SELLTOOPEN</optselltype>
  <shperctrct>100</shperctrct>
  <secured>Y</secured>
</sellopt>
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
          expect(invtran.fit_id).to eq("SELLOPT001")
        end

        it "returns trade_date" do
          expect(invtran.trade_date).to eq(Time.parse("2025-10-20 16:00:00 +0000"))
        end
      end

      describe "SecId" do
        let(:secid) { invsell.secid }

        it "returns SecId type" do
          expect(secid).to be_a(OFX::Investment::Aggregates::SecId)
        end

        it "returns Unique ID" do
          expect(secid.unique_id).to eq("FAKECUSIPOPT")
        end

        it "returns Unique ID Type" do
          expect(secid.unique_id_type).to eq("CUSIP")
        end
      end

      it "returns units" do
        expect(invsell.units).to eq(5)
      end

      it "returns unit price" do
        expect(invsell.unit_price).to eq(BigDecimal('15'))
      end

      it "returns total" do
        expect(invsell.total).to eq(BigDecimal('75'))
      end
    end

    it "returns opt_sell_type" do
      expect(parsed.opt_sell_type).to eq("SELLTOOPEN")
    end

    it "returns sh_per_contract" do
      expect(parsed.sh_per_contract).to eq(100)
    end

    it "returns secured" do
      expect(parsed.secured).to eq(true)
    end
  end
end
