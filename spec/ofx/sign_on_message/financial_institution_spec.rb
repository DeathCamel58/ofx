describe OFX::FinancialInstitution do
  before do
    @ofx = OFX::Parser::Base.new("spec/fixtures/creditcard.ofx")
    @parser = @ofx.parser
    @financial_institution = @parser.sign_on.fi
  end

  describe 'financial institution' do
    it 'returns financial institution object' do
      expect(@financial_institution).to be_a(OFX::FinancialInstitution)
    end

    it 'returns organization' do
      expect(@financial_institution.organization).to eq('Citigroup')
      expect(@financial_institution.org).to eq('Citigroup')
    end

    it 'returns fid' do
      expect(@financial_institution.id).to eq('24909')
      expect(@financial_institution.fid).to eq('24909')
    end
  end
end
