# frozen_string_literal: true

RSpec.describe CreditCardFinder::Strategies::CreditCardBinsStrategy, :vcr do
  let(:bin) { '427230' }

  describe "#lookup" do
    subject { described_class.new }

    it 'returns instance with card info methods' do
      expect(subject.lookup(bin)).to eq subject
      expect(subject.bin).to eq bin
      expect(subject.card).to eq 'VISA'
      expect(subject.type).to eq 'CREDIT'
      expect(subject.level).to eq 'PREMIER'
      expect(subject.countrycode).to eq 'RU'
    end

    context 'when bin is undefined' do
      let(:bin) { '537465' }

      it 'returns nil' do
        expect(subject.lookup(bin)).to eq nil
      end
    end
  end
end
