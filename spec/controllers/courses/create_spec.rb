require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe Course, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "POST create course" do
    path = "/api/v1/courses"
    let(:teacher) { create(:teachers) }
    let(:params) {{
      name: "Course Name",
      start_time: "09:00:00",
      end_time: "12:00:00",
      days: [1, 3, 5],
      credit: 3
    }}
    context "when user is a teacher" do
      let(:valid_token) { create(:access_token, resource_owner_id: teacher.user.id, application_id: client.id) }
      let(:expired_token) { create(:expired_token, resource_owner_id: teacher.user.id, application_id: client.id) }

      it "should return http status code 200" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = post(path, headers: json_headers, params: params.to_json)
        expect(result).to eq(200)
      end

      it "should return the course" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        post(path, headers: json_headers, params: params.to_json)
        result = JSON.parse(response.body, symbolize_names: true)[:data]
        course = Course.last
        expect(result[:id]).to eq(course.id)
      end
    end

    context "when user is not a teacher" do
      let(:user) { create(:users) }
      let(:valid_token) { create(:access_token, resource_owner_id: user.id, application_id: client.id) }
      it "should return 403" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = post(path, headers: json_headers, params: params.to_json)
        expect(result).to eq(403)
      end
    end
  end
end
