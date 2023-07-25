Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, '77qf822un3wqj0', 'QQFToJJZl8sYxqwG', scope: 'r_liteprofile r_emailaddress',
                                                            fields: %w[id first-name last-name email-address public-profile-url]
end
