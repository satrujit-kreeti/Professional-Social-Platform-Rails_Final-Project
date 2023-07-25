# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations' do
    it 'should belong to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'should have many comments' do
      association = described_class.reflect_on_association(:comments)
      expect(association.macro).to eq(:has_many)
    end

    it 'should have many likes' do
      association = described_class.reflect_on_association(:likes)
      expect(association.macro).to eq(:has_many)
    end

    it 'should have many liking_users through likes' do
      association = described_class.reflect_on_association(:liking_users)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:likes)
      expect(association.options[:source]).to eq(:user)
    end
  end

  describe 'liked_by?' do
    let(:post) { create(:post) }

    context 'when the user has liked the post' do
      it 'should return true' do
        user = create(:user)
        Like.create(post:, user:)
        expect(post.liked_by?(user)).to be true
      end
    end

    context 'when the user has not liked the post' do
      it 'should return false' do
        user = create(:user)
        expect(post.liked_by?(user)).to be false
      end
    end
  end
end
