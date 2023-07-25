# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    association :user
    content { 'This is a sample post content.' }
  end
end
