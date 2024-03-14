FactoryBot.define do
  factory :client, class: 'Doorkeeper::Application' do
    name { "test_client" }
    redirect_uri { "urn:ietf:wg:oauth:2.0:oob" }
    uid { SecureRandom.uuid }
    secret { SecureRandom.hex(16) }
    scopes {}
  end
end
