FactoryBot.define do
  factory :job_requirement do
    job_title { 'Sample Job Title' }
    job_description { 'Sample job description' }
    vacancies { 1 }
    skills_required { 'Sample skills required' }
    status { :pending }
    association :job_sector
    association :job_role
    association :user, factory: :user
  end
end
