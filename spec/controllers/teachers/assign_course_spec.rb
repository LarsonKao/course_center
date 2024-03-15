require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe Teacher, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "POST assign_course" do
    path = "/api/v1/teachers/assign_course"
    let(:teacher) { create(:teachers) }
    let(:course) { create(:courses)}
    let(:user) { create(:users) }

    context "when user is logged in" do
      let(:valid_token) { create(:access_token, resource_owner_id: teacher.user.id, application_id: client.id) }
      let(:params) do
        {
          course_id: course.id
        }
      end
      it "should return http status code 200" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = post(path, headers: json_headers, params: params.to_json)
        expect(result).to eq(200)
      end

      it "should add the course" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        post(path, headers: json_headers, params: params.to_json)
        teacher.reload
        teacher_course = teacher.courses.last
        expect(teacher_course).to eq(course)
      end
    end

    context "when the course is not found" do
      let(:valid_token) { create(:access_token, resource_owner_id: teacher.user.id, application_id: client.id) }

      let(:params) do
        {
          course_id: -1
        }
      end

      it "should return http status code 404" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = post(path, headers: json_headers, params: params.to_json)
        expect(result).to eq(404)
      end
    end
  end
end
