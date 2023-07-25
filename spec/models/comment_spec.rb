# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it 'belongs to a user' do
      user = create(:user)
      comment = create(:comment, user:)
      expect(comment.user).to eq(user)
    end

    it 'belongs to a post' do
      post = create(:post)
      comment = create(:comment, post:)
      expect(comment.post).to eq(post)
    end
  end

  describe 'validations' do
    it 'is valid with content' do
      comment = build(:comment)
      expect(comment).to be_valid
    end

    it 'is invalid without content' do
      comment = build(:comment, content: nil)
      expect(comment).not_to be_valid
      expect(comment.errors[:content]).to include("can't be blank")
    end
  end
end
