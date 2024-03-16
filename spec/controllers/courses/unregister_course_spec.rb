require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe Course, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "DELETE unregister_course" do
    path = "/api/v1/courses/unregister_course"
    let(:student) { create(:students) }
    let(:course) { create(:courses)}
    let(:user) { create(:users) }

    context "when user is logged in" do
      let(:valid_token) { create(:access_token, resource_owner_id: student.user.id, application_id: client.id) }
      let(:params) do
        {
          course_id: course.id
        }
      end
      it "should return http status code 200" do
        student.courses << course
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = post(path, headers: json_headers, params: params.to_json)
        expect(result).to eq(200)
      end

      it "should delete the course" do
        student.courses << course
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        post(path, headers: json_headers, params: params.to_json)
        student.reload
        expect(student.courses.count).to be_zero
      end
    end

    context "when the course is not found" do
      let(:valid_token) { create(:access_token, resource_owner_id: student.user.id, application_id: client.id) }

      let(:params) do
        {
          course_id: -1
        }
      end

      it "should return http status code 404" do
        student.courses << course
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = post(path, headers: json_headers, params: params.to_json)
        expect(result).to eq(404)
      end
    end
  end
end
