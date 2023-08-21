# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { 'Satrujit' }
    email { Faker::Internet.unique.email }
    password { 'Super@71' }
  end
end
