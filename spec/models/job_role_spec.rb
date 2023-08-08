# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobRole, type: :model do
  describe 'associations' do
    it 'belongs to a job_sector' do
      association = described_class.reflect_on_association(:job_sector)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    it 'is valid with a name and a job_sector' do
      job_sector = create(:job_sector)
      job_role = JobRole.new(name: 'Software Engineer', job_sector:)
      expect(job_role).to be_valid
    end

    it 'is not valid without a name' do
      job_sector = create(:job_sector)
      job_role = JobRole.new(name: nil, job_sector:)
      expect(job_role).not_to be_valid
      expect(job_role.errors[:name]).to include("can't be blank")
    end

    it 'is not valid without a job_sector' do
      job_role = JobRole.new(name: 'Software Engineer', job_sector: nil)
      expect(job_role).not_to be_valid
      expect(job_role.errors[:job_sector]).to include('must exist')
    end
  end
end
