require 'rails_helper'

RSpec.describe JobComment, type: :model do
  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to a job_requirement' do
      association = described_class.reflect_on_association(:job_requirement)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end
