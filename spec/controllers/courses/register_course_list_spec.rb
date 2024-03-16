require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe Course, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "GET register_course_list" do
    path = "/api/v1/courses/register_course_list"
    let(:student) { create(:students) }
    let(:courses) { create_list(:courses, 2)}
    let(:valid_token) { create(:access_token, resource_owner_id: student.user.id, application_id: client.id) }

    context "when server is ok" do
      it "should return http status code 200" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        student.courses += courses
        result = get(path, headers: json_headers)
        expect(result).to eq(200)
      end
    end
  end
end
