# frozen_string_literal: true

FactoryBot.define do
  factory :job_role do
    sequence(:name) { |n| "Job Role #{n}" }
    association :job_sector
  end
end
