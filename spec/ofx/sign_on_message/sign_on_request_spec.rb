describe OFX::SignOnMessage::SignOnRequest do
  before do
    @ofx = OFX::Parser::Base.new("spec/fixtures/statement_download_request.ofx")
    @parser = @ofx.parser
    @sign_on = @parser.sign_on
  end

  describe "sign_on request" do
    it "should be an instance of SignOnRequest" do
      expect(@sign_on).to be_a(OFX::SignOnMessage::SignOnRequest)
    end

    it "should return client_date (DTCLIENT)" do
      expect(@sign_on.client_date).to be_a(Time)
      expect(@sign_on.client_date.strftime("%Y%m%d%H%M%S")).to eq("20051029101000")
    end

    it "should return user_id (USERID)" do
      expect(@sign_on.user_id).to eq("MyUserID")
    end

    it "should return user_password (USERPASS)" do
      expect(@sign_on.user_password).to eq("MyPassword")
    end

    it "should return language (LANGUAGE)" do
      expect(@sign_on.language).to eq("ENG")
    end

    it "should return app_id (APPID)" do
      expect(@sign_on.app_id).to eq("MyApp")
    end

    it "should return app_version (APPVER)" do
      expect(@sign_on.app_version).to eq("0500")
    end

    it "should return financial institution (FI) aggregate" do
      expect(@sign_on.financial_institution).to be_a(OFX::SignOnMessage::FinancialInstitution)
    end

    describe "empty or missing fields" do
      it "should return empty strings for fields not present in fixture" do
        expect(@sign_on.user_key).to eq("")
        expect(@sign_on.access_token).to eq("")
        expect(@sign_on.client_uid).to eq("")
      end

      it "should return false for generate_user_key (GENUSERKEY)" do
        expect(@sign_on.generate_user_key).to be false
      end
    end

    it "should not respond to response-only fields" do
      expect(@sign_on).not_to respond_to(:status)
      expect(@sign_on).not_to respond_to(:server_date)
    end
  end
end