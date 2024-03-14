FactoryBot.define do
  factory :teacher_client, class: 'Doorkeeper::Application' do
    name { "test_teacher" }
    redirect_uri { "urn:ietf:wg:oauth:2.0:oob" }
    uid { SecureRandom.uuid }
    secret { SecureRandom.hex(16) }
    scopes { "teacher" }
  end

  factory :student_client, class: 'Doorkeeper::Application' do
    name { "test_student" }
    redirect_uri { "urn:ietf:wg:oauth:2.0:oob" }
    uid { SecureRandom.uuid }
    secret { SecureRandom.hex(16) }
    scopes { "student" }
  end
end
