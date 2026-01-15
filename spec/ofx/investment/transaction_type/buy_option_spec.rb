describe OFX::Investment::TransactionType::BuyOption do
  let(:parsed) { OFX::Investment::TransactionType::BuyOption.from_ofx_102(xml) }

  describe "Good XML" do
    let(:xml) { "
<buyopt>
  <invbuy>
    <invtran>
      <fitid>2005010500000000012345</fitid>
      <dttrade>20050105000000.000[-5:EST]</dttrade>
      <dtsettle>20050105000000.000[-5:EST]</dtsettle>
      <memo>Option Purchase Call Intuit Jan 5 1/2</memo>
    </invtran>
    <secid>
      <uniqueid>9KG1119KG</uniqueid>
      <uniqueidtype>OTHER</uniqueidtype>
    </secid>
    <units>5</units>
    <unitprice>35.000000</unitprice>
    <commission>5.00</commission>
    <taxes>1.00</taxes>
    <fees>3.00</fees>
    <load>1.00</load>
    <total>-17510.00</total>
    <subacctsec>CASH</subacctsec>
    <subacctfund>CASH</subacctfund>
  </invbuy>
  <optbuytype>BUYTOOPEN</optbuytype>
  <shperctrct>100</shperctrct>
</buyopt>
" }

    it "returns optbuytype" do
      expect(parsed.opt_buy_type).to eq("BUYTOOPEN")
    end

    it "returns shperctrct" do
      expect(parsed.sh_per_contract).to eq(BigDecimal(100))
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
          expect(invtran.fit_id).to eq("2005010500000000012345")
        end

        it "returns settlement_date" do
          expect(invtran.settlement_date).to eq(Time.parse("2005-01-05 00:00:00 -0500"))
        end

        it "returns trade_date" do
          expect(invtran.trade_date).to eq(Time.parse("2005-01-05 00:00:00 -0500"))
        end

        it "returns memo" do
          expect(invtran.memo).to eq("Option Purchase Call Intuit Jan 5 1/2")
        end
      end

      describe "SecId" do
        let(:secid) { invbuy.secid }

        it "returns SecId type" do
          expect(secid).to be_a(OFX::Investment::Aggregates::SecId)
        end

        it "returns Unique ID" do
          expect(secid.unique_id).to eq("9KG1119KG")
        end

        it "returns Unique ID Type" do
          expect(secid.unique_id_type).to eq("OTHER")
        end
      end

      it "returns units" do
        expect(invbuy.units).to eq(5)
      end

      it "returns unit price" do
        expect(invbuy.unit_price).to eq(BigDecimal('35.000000'))
      end

      it "returns commission" do
        expect(invbuy.commission).to eq(BigDecimal('5.00'))
      end

      it "returns taxes" do
        expect(invbuy.taxes).to eq(BigDecimal('1'))
      end

      it "returns fees" do
        expect(invbuy.fees).to eq(BigDecimal('3'))
      end

      it "returns load" do
        expect(invbuy.load).to eq(BigDecimal('1'))
      end

      it "returns total" do
        expect(invbuy.total).to eq(BigDecimal('-17510.00'))
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
