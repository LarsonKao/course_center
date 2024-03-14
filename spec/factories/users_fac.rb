FactoryBot.define do
  factory :users , class: 'User' do
    sequence(:email) { |n| "valid_#{n}@example.com"}
    password { "password" }
    sequence(:name) { |n| "Man #{n}" }
  end
end
