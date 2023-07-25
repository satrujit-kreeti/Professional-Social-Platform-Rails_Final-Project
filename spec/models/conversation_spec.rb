require 'rails_helper'

RSpec.describe Conversation, type: :model do
  describe 'associations' do
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

    it 'has many messages' do
      association = described_class.reflect_on_association(:messages)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe '#opposed_user' do
    let(:sender) { create(:user) }
    let(:recipient) { create(:user) }
    let(:conversation) { create(:conversation, sender:, recipient:) }

    it 'returns the opposed user' do
      expect(conversation.opposed_user(sender)).to eq(recipient)
      expect(conversation.opposed_user(recipient)).to eq(sender)
    end
  end

  describe '.between' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    it 'returns conversations between two users' do
      conversation1 = create(:conversation, sender: user1, recipient: user2)
      conversation2 = create(:conversation, sender: user2, recipient: user1)

      conversations = Conversation.between(user1, user2)

      expect(conversations).to include(conversation1, conversation2)
    end
  end
end
