describe OFX::SignOnMessage::SignOnResponse do
  before do
    @ofx = OFX::Parser::Base.new("spec/fixtures/creditcard.ofx")
    @parser = @ofx.parser
    @sign_on = @parser.sign_on
  end

  describe "sign_on" do
    it "should return language" do
      expect(@sign_on.language).to eq("ENG")
    end

    it 'financial institution' do
      expect(@sign_on.financial_institution).to be_a(OFX::SignOnMessage::FinancialInstitution)
    end

    it "should return status" do
      expect(@sign_on.status).to be_a(OFX::SignOnMessage::Status)
    end
  end
end
