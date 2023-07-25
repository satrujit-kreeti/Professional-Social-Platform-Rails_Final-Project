# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content { 'Sample comment content' }
    association :user, factory: :user
    association :post, factory: :post
  end
end
