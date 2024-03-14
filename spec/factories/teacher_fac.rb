FactoryBot.define do
  factory :teachers, class: 'Teacher' do
    user { association :users }
    sequence(:lab) { |n| "Lab #{n}" }
  end
end
