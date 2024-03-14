FactoryBot.define do
  factory :access_token, class: 'Doorkeeper::AccessToken' do
    token { SecureRandom.hex(10) }
    expires_in { 2.hours }

    factory :expired_token do
      expires_in { -2.hours }
    end
  end
end
