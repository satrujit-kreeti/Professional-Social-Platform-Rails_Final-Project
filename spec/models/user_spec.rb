require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) } 

    it 'validates presence of email' do
      expect(subject).to validate_presence_of(:email)
    end

    it 'validates uniqueness of email' do
      expect(subject).to validate_uniqueness_of(:email)
    end

    it 'validates presence of username' do
      expect(subject).to validate_presence_of(:username)
    end
  end

  it 'creates a user instance using FactoryBot' do
    user = create(:user) 
    expect(user).to be_valid
  end
end
