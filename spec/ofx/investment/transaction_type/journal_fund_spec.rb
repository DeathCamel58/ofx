describe OFX::Investment::TransactionType::JournalFund do
  let(:parsed) { OFX::Investment::TransactionType::JournalFund.from_ofx_102(xml) }

  describe "Good XML" do
    let(:xml) { "
<jrnsfund>
  <invtran>
    <fitid>129837-1112</fitid>
    <dttrade>20170203</dttrade>
  </invtran>
  <total>2300</total>
  <subacctto>CASH</subacctto>
  <subacctfrom>CASH</subacctfrom>
</jrnsfund>
" }

    describe "InvTran" do
      let(:invtran) { parsed.invtran }

      it "returns InvTran type" do
        expect(invtran).to be_a(OFX::Investment::Aggregates::InvTran)
      end

      it "returns fit_id" do
        expect(invtran.fit_id).to eq("129837-1112")
      end

      it "returns trade_date" do
        expect(invtran.trade_date).to eq(Time.parse("2017-02-03 00:00:00 +0000"))
      end
    end

    it "returns total" do
      expect(parsed.total).to eq(BigDecimal('2300'))
    end

    it "returns subacct_to" do
      expect(parsed.subacct_to).to eq("CASH")
    end

    it "returns subacct_from" do
      expect(parsed.subacct_from).to eq("CASH")
    end
  end
end
