describe OFX::Investment::TransactionType::BuyMutualFund do
  let(:parsed) { OFX::Investment::TransactionType::BuyMutualFund.from_ofx_102(xml) }

  describe "Good XML" do
    let(:xml) { "
<buymf>
  <invbuy>
    <invtran>
      <fitid>BUYMF001</fitid>
      <dttrade>20251002160000</dttrade>
    </invtran>
    <secid>
      <uniqueid>FAKECUSIPMF</uniqueid>
      <uniqueidtype>CUSIP</uniqueidtype>
    </secid>
    <units>20</units>
    <unitprice>50</unitprice>
    <total>-1000</total>
  </invbuy>
  <buytype>BUY</buytype>
</buymf>
" }

    it "returns buy_type" do
      expect(parsed.buy_type).to eq("BUY")
    end

    it "returns relfitid" do
      expect(parsed.relfitid).to eq("")
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
          expect(invtran.fit_id).to eq("BUYMF001")
        end

        it "returns trade_date" do
          expect(invtran.trade_date).to eq(Time.parse("2025-10-02 16:00:00 +0000"))
        end
      end

      describe "SecId" do
        let(:secid) { invbuy.secid }

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
        expect(invbuy.units).to eq(20)
      end

      it "returns unit price" do
        expect(invbuy.unit_price).to eq(BigDecimal('50'))
      end

      it "returns total" do
        expect(invbuy.total).to eq(BigDecimal('-1000'))
      end
    end
  end
end
