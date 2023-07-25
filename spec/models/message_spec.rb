# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'associations' do
    it 'belongs to a conversation' do
      association = described_class.reflect_on_association(:conversation)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to a sender' do
      association = described_class.reflect_on_association(:sender)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:class_name]).to eq('User')
    end

    it 'belongs to a recipient' do
      association = described_class.reflect_on_association(:recipient)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:class_name]).to eq('User')
    end
  end

  describe 'validations' do
    it 'is valid with a body' do
      message = build(:message)
      expect(message).to be_valid
    end

    it 'is not valid without a body' do
      message = build(:message, body: nil)
      expect(message).not_to be_valid
      expect(message.errors[:body]).to include("can't be blank")
    end
  end
end
