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
      description: "some description...",
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

    context "when params are bad" do
      let(:valid_token) { create(:access_token, resource_owner_id: teacher.user.id, application_id: client.id) }
      let(:expired_token) { create(:expired_token, resource_owner_id: teacher.user.id, application_id: client.id) }

      it "should return http status code 400" do
        params[:schedules] = {
          "1": [1, 2, 3],
          "8": [4, 5, 6]
        }
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = post(path, headers: json_headers, params: params.to_json)
        expect(result).to eq(400)
      end
    end

    context "when token is invalid" do
      let(:valid_token) { create(:access_token, resource_owner_id: teacher.user.id, application_id: client.id) }
      let(:expired_token) { create(:expired_token, resource_owner_id: teacher.user.id, application_id: client.id) }

      it "should return http status code 401" do
        json_headers[:Authorization] = "Bearer #{expired_token.token}"
        result = post(path, headers: json_headers, params: params.to_json)
        expect(result).to eq(401)
      end
    end

    context "when user has no teacher auth" do
      let(:user){ create(:users)}
      let(:valid_token) { create(:access_token, resource_owner_id: user.id, application_id: client.id) }

      it "should return http status code 404" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = post(path, headers: json_headers, params: params.to_json)
        expect(result).to eq(404)
      end
    end

    context "when create failed" do
      let(:valid_token) { create(:access_token, resource_owner_id: teacher.user.id, application_id: client.id) }

      it "should return http status code 422" do
        allow_any_instance_of(Course).to receive(:save).and_return(false)
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = post(path, headers: json_headers, params: params.to_json)
        expect(result).to eq(422)
      end
    end
  end
end
