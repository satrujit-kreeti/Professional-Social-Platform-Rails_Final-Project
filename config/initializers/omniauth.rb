# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, '77qf822un3wqj0', 'QQFToJJZl8sYxqwG'
end
