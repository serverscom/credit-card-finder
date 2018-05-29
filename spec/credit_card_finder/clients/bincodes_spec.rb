# frozen_string_literal: true

RSpec.describe CreditCardFinder::Clients::Bincodes, :vcr do
  describe "#fetch" do
    before do
      CreditCardFinder::Config.configure do |config|
        config.bincodes.api_key = '1111111111111111'
      end
    end

    let(:bin) { '427664' }
    subject { described_class.new }

    it 'returns self instance with data' do
      expect(subject.fetch(bin)).to eq subject
      expect(subject.data['card']).to eq 'VISA'
      expect(subject.data['type']).to eq 'DEBIT'
      expect(subject.data['bank']).to match /SBERBANK/
      expect(subject.data['countrycode']).to eq 'RU'
      expect(subject.data['level']).to eq 'CLASSIC'
    end

    context 'when api key is invalid' do
      before do
        CreditCardFinder::Config.configure do |config|
          config.bincodes.api_key = 'foobar2'
        end
      end

      it 'returns with error' do
        expect(subject.fetch(bin)).to eq subject
        expect(subject.valid?).to eq false
        expect(subject.errors[:code]).to eq "1002"
        expect(subject.errors[:message]).to eq "Invalid API Key"
      end
    end

    context 'when api key is empty' do
      before do
        CreditCardFinder::Config.configure do |config|
          config.bincodes.api_key = nil
        end
      end

      it 'responds bad status' do
        expect(subject.fetch(bin)).to eq subject
        expect(subject.valid?).to eq false
        expect(subject.errors[:code]).to eq '404'
        expect(subject.errors[:message]).to match /Unexpected error/
      end
    end
  end
end
