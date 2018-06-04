# frozen_string_literal: true

RSpec.describe CreditCardFinder::Strategies::BincodesStrategy, :vcr do
  before do
    CreditCardFinder::Config.configure do |config|
      config.bincodes.api_key = '1111111111111111'
    end
  end

  let(:bin) { '427230' }

  describe '#lookup' do
    subject { described_class.new }

    it 'responds instance with card info methods' do
      expect(subject.lookup(bin)).to eq subject
      expect(subject.bin).to eq bin
      expect(subject.card).to eq 'VISA'
      expect(subject.type).to eq 'CREDIT'
      expect(subject.level).to eq 'GOLD'
      expect(subject.countrycode).to eq 'RU'
      expect(subject.country).to eq 'RUSSIAN FEDERATION'
    end

    context 'when api key is wrong' do
      before do
        CreditCardFinder::Config.configure do |config|
          config.bincodes.api_key = 'foobar2'
        end
      end

      it 'returns nil' do
        expect(subject.lookup(bin)).to eq nil
      end
    end
  end
end
