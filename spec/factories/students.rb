FactoryBot.define do
  factory :students, class: 'student' do
    user { association :users }
  end
end
