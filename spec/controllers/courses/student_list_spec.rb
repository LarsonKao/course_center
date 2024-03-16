require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe Course, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "GET course_list" do
    path = "/api/v1/courses/student_list"
    let(:teacher) { create(:teachers) }
    let(:course) { create(:courses)}
    let(:students) { create_list(:students, 2)}
    let(:valid_token) { create(:access_token, resource_owner_id: teacher.user.id, application_id: client.id) }


    context "when server is ok" do
      it "should return http status code 200" do
        course.students += students
        course.teachers << teacher
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = get(path + "?id=#{course.id}", headers: json_headers)
        expect(result).to eq(200)
      end
    end
  end
end
