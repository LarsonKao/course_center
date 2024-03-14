FactoryBot.define do
  factory :strudent , class: 'User' do
    sequence(:email) { |n| "valid_#{n}@example.com"}
    password { "password" }
    sequence(:name) { |n| "Student #{n}" }
    permissions { ["student"] }
  end

  factory :teacher , class: 'User' do
    sequence(:email) { |n| "valid_#{n}@example.com"}
    password { "password" }
    sequence(:name) { |n| "Teacher #{n}" }
    permissions { ["teacher"] }
  end
end
