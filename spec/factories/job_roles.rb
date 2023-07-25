FactoryBot.define do
  factory :job_role do
    sequence(:name) { |n| "Job Role #{n}" }
    association :job_sector
  end
end
