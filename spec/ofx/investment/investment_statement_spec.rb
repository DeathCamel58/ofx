describe OFX::Investment::InvestmentStatementResponse do
  let(:parser) { ofx.parser }
  let(:investment_statement) { parser.investment_statements.first }

  describe "spec/fixtures/invstmtrs.ofx" do
    let(:ofx) { OFX::Parser::Base.new("spec/fixtures/invstmtrs.ofx") }

    it "returns currency" do
      expect(investment_statement.currency).to eq("USD")
    end

    it "returns start date" do
      expect(investment_statement.start_date).to eq(Time.parse("2005-08-24 13:01:05.000000000 +0000"))
    end

    it "returns end date" do
      expect(investment_statement.end_date).to eq(Time.parse("2005-08-28 10:10:00.000000000 +0000"))
    end

    describe "account" do
      it "returns account type" do
        expect(investment_statement.account).to be_a(OFX::Investment::Account)
      end

      it "returns broker id" do
        expect(investment_statement.account.broker_id).to eq('121099999')
      end

      it "returns account id" do
        expect(investment_statement.account.account_id).to eq('999988')
      end
    end

    describe "transactions" do
      it "returns array" do
        expect(investment_statement.transactions).to be_a(Array)
      end

      it "returns correct number of transactions" do
        expect(investment_statement.transactions.size).to eq(2)
      end
    end

    describe "balance" do
      let(:balance) { investment_statement.balance }

      it "returns InvBalances type" do
        expect(balance).to be_a(OFX::Investment::Aggregates::InvBalances)
      end

      it "returns available cash" do
        expect(balance.available_cash).to eq(BigDecimal('200.00'))
      end

      it "returns buying power" do
        expect(balance.buying_power).to eq(BigDecimal('0'))
      end

      it "returns margin balance" do
        expect(balance.margin_balance).to eq(BigDecimal('-50'))
      end

      it "returns short balance" do
        expect(balance.short_balance).to eq(BigDecimal('0'))
      end
    end
  end

  describe "spec/fixtures/investment_2.ofx" do
    let(:ofx) { OFX::Parser::Base.new("spec/fixtures/investment_2.ofx") }

    it "returns currency" do
      expect(investment_statement.currency).to eq("USD")
    end

    it "returns start date" do
      expect(investment_statement.start_date).to eq(Time.parse("2006-01-05 17:25:32.000000000 -0500"))
    end

    it "returns end date" do
      expect(investment_statement.end_date).to eq(Time.parse("2006-01-31 17:25:32.000000000 -0400"))
    end

    describe "account" do
      it "returns account type" do
        expect(investment_statement.account).to be_a(OFX::Investment::Account)
      end

      it "returns broker id" do
        expect(investment_statement.account.broker_id).to eq('121099999')
      end

      it "returns account id" do
        expect(investment_statement.account.account_id).to eq('999988')
      end
    end

    describe "transactions" do
      it "returns array" do
        expect(investment_statement.transactions).to be_a(Array)
      end

      it "returns correct number of transactions" do
        expect(investment_statement.transactions.size).to eq(3)
      end
    end
  end
end
