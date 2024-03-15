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
      schedules: {
        "1": [1, 2, 3],
        "2": [4, 5, 6],
        "3": [7, 8, 9],
        "4": [10, 11],
        "5": [1, 2],
        "6": [3, 4],
        "7": [5, 6]
      },
      credit: 3
    }}
    context "when user is a teacher" do
      let(:valid_token) { create(:access_token, resource_owner_id: teacher.user.id, application_id: client.id) }

      it "should return http status code 200" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = post(path, headers: json_headers, params: params.to_json)
        expect(result).to eq(200)
      end

      it "should return a course" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        post(path, headers: json_headers, params: params.to_json)
        result = JSON.parse(response.body, symbolize_names: true)
        expect(result[:data]).not_to be_nil
      end
    end
  end
end
