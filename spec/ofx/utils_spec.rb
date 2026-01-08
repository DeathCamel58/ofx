describe OFX::Utils do
  describe "#build_date" do
    context "without a Time Zone" do
      it "should default to GMT" do
        expect(OFX::Utils.build_date("20170904")).to eq(Time.gm(2017, 9, 4))
        expect(OFX::Utils.build_date("20170904082855")).to eq(Time.gm(2017, 9, 4, 8, 28, 55))
      end
    end

    context "with a Time Zone" do
      it "should returns the correct date" do
        expect(OFX::Utils.build_date("20150507164333[-0300:BRT]")).to eq(Time.new(2015, 5, 7, 16, 43, 33, "-03:00"))
        expect(OFX::Utils.build_date("20180507120000[0:GMT]")).to eq(Time.gm(2018, 5, 7, 12))
        expect(OFX::Utils.build_date("20170904082855[-3:GMT]")).to eq(Time.new(2017, 9, 4, 8, 28, 55, "-03:00"))
      end
    end
  end
end
