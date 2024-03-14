FactoryBot.define do
  factory :courses, class: 'course' do
    name { "Course Name" }
    start_time { "09:00:00" }
    end_time { "12:00:00" }
    days { [1, 3, 5] }
    credit { 3 }
  end
end
