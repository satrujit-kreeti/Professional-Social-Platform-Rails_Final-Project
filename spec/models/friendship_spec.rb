# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to a friend (User)' do
      association = described_class.reflect_on_association(:friend)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:class_name]).to eq('User')
      expect(association.options[:foreign_key]).to eq('friend_id')
    end

    it 'belongs to the requested_by_user (User)' do
      association = described_class.reflect_on_association(:requested_by_user)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:class_name]).to eq('User')
      expect(association.options[:foreign_key]).to eq('requested_by_user_id')
    end
  end
end
