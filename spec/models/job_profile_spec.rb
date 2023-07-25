# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobProfile, type: :model do
  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    it 'is valid with a user' do
      user = create(:user) # Assuming you have a valid user factory defined
      job_profile = JobProfile.new(user:)
      expect(job_profile).to be_valid
    end

    it 'is not valid without a user' do
      job_profile = JobProfile.new(user: nil)
      expect(job_profile).not_to be_valid
      expect(job_profile.errors[:user]).to include('must exist')
    end
  end
end
