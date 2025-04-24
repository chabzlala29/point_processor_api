require 'rails_helper'

RSpec.describe Api::V1::Response do
  describe '#as_json' do
    context 'when status and message are present' do
      it 'returns the correct hash with status and message' do
        response = described_class.new(status: 'success', message: 'Created', data: { id: 1 })
        expect(response.as_json).to eq({
          status: 'success',
          message: 'Created',
          id: 1
        })
      end
    end

    context 'when message is nil' do
      it 'excludes message from the hash' do
        response = described_class.new(status: 'success', data: { id: 1 })
        expect(response.as_json).to eq({
          status: 'success',
          id: 1
        })
      end
    end

    context 'when data is empty' do
      it 'returns only status and message if provided' do
        response = described_class.new(status: 'error', message: 'Invalid')
        expect(response.as_json).to eq({
          status: 'error',
          message: 'Invalid'
        })
      end
    end
  end
end
