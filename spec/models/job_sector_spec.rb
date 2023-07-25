require 'rails_helper'

RSpec.describe JobSector, type: :model do
  describe 'associations' do
    it 'has many job_roles' do
      association = described_class.reflect_on_association(:job_roles)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe 'validations' do
    subject { build(:job_sector) }

    it 'validates presence of name' do
      subject.name = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of job_roles' do
      subject.job_roles.clear
      expect(subject).not_to be_valid
      expect(subject.errors[:job_roles]).to include('must have at least one job role')
    end
  end
end
