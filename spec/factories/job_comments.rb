FactoryBot.define do
    factory :job_comment do
      content { 'Sample job comment content' }
      association :user, factory: :user
      association :job_requirement, factory: :job_requirement 
    end
  end