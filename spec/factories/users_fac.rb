FactoryBot.define do
  factory :strudents , class: 'User' do
    sequence(:email) { |n| "valid_#{n}@example.com"}
    password { "password" }
    sequence(:name) { |n| "Student #{n}" }
    permissions { ["student"] }
  end

  factory :teachers , class: 'User' do
    sequence(:email) { |n| "valid_#{n}@example.com"}
    password { "password" }
    sequence(:name) { |n| "Teacher #{n}" }
    permissions { ["teacher"] }
  end
end
