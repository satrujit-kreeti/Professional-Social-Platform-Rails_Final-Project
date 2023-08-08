# rubocop:disable all


require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:user) { User.new }

    it 'validates presence of email' do
      user.email = ''
      user.valid?
      errors = user.errors[:email]
      assert(errors.include?("can't be blank"), 'Expected presence of email validation')
    end

    it 'validates uniqueness of email' do
      existing_user = create(:user)
      user.email = existing_user.email
      user.valid?
      errors = user.errors[:email]
      assert(errors.include?('has already been taken'), 'Expected uniqueness of email validation')
    end

    it 'validates presence of username' do
      user.username = ''
      user.valid?
      errors = user.errors[:username]
      assert(errors.include?("can't be blank"), 'Expected presence of username validation')
    end
  end

  it 'creates a user instance using FactoryBot' do
    user = create(:user)
    assert(user.valid?, 'Expected the user instance to be valid')
  end
end
