# frozen_string_literal: true

RSpec.describe CreditCardFinder::Proxy, :vcr do
  before do
    CreditCardFinder::Config.configure do |config|
      config.bincodes.api_key = '1111111111111111'
    end
  end

  describe '#lookup' do
    subject { described_class.new }

    let(:bin) { '427230' }

    it 'returns data from first winner strategy' do
      expect(subject.lookup(bin).class.name)
        .to eq 'CreditCardFinder::Strategies::CreditCardBinsStrategy'
    end

    context 'when bin is undefined for first strategy' do
      let(:bin) { '537465' }

      it 'returns data from bincodes strategy' do
        expect(subject.lookup(bin).class.name)
          .to eq 'CreditCardFinder::Strategies::BincodesStrategy'
      end
    end

    context 'when bin is invalid' do
      let(:bin) { 'foobar2' }

      it 'returns nil' do
        expect(subject.lookup(bin)).to eq nil
      end
    end
  end
end
