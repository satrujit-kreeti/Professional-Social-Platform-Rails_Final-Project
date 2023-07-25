require 'rails_helper'

RSpec.describe JobRequirement, type: :model do
  describe 'associations' do
    it 'belongs to job_sector' do
      association = described_class.reflect_on_association(:job_sector)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to job_role' do
      association = described_class.reflect_on_association(:job_role)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has many job_comments' do
      association = described_class.reflect_on_association(:job_comments)
      expect(association.macro).to eq(:has_many)
    end
  end

  describe 'enums' do
    it 'defines the status enum with expected values' do
      expect(JobRequirement.statuses).to eq({ 'pending' => 'pending', 'approved' => 'approved',
                                              'rejected' => 'rejected' })
    end
  end
end
