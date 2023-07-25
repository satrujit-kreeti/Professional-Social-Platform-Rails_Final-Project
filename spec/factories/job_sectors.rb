FactoryBot.define do
  factory :job_sector do
    sequence(:name) { |n| "Job Sector #{n}" }

    after(:build) do |job_sector|
      job_sector.job_roles << build(:job_role, name: 'Valid Job Role', job_sector:)
    end
  end
end
