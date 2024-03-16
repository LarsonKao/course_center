FactoryBot.define do
  factory :courses, class: 'course' do
    name { "Course Name" }
    description { "some description..." }
    schedules {{
      "1": [1, 2, 3]
    }}
    credit { 3 }
  end
end
