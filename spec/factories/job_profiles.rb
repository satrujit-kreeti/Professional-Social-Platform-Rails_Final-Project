# frozen_string_literal: true

FactoryBot.define do
  factory :job_profile do
    title { 'Sample Job Profile' }
    association :user, factory: :user
  end
end
