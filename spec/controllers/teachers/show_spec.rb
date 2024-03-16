require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe Teacher, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "GET show" do
    path = "/api/v1/teacher"
    let(:teacher) { create(:teachers) }
    let(:user) { create(:users) }
    let(:valid_token) { create(:access_token, resource_owner_id: teacher.user.id, application_id: client.id) }
    let(:expired_token) { create(:expired_token, resource_owner_id: teacher.user.id, application_id: client.id) }
    let(:user_token) { create(:access_token, resource_owner_id: user.id, application_id: client.id) }


    context "when teacher is logged in" do
      it "should return http status code 200" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = get(path, headers: json_headers)
        binding.pry
        expect(result).to eq(200)
      end
    end

    context "when user has no teacher" do
      it "should return http status code 404" do
        json_headers[:Authorization] = "Bearer #{user_token.token}"
        result = get(path, headers: json_headers)
        expect(result).to eq(404)
      end
    end

    context "when token is invalid" do
      it "should return http status code 401" do
        json_headers[:Authorization] = "Bearer #{expired_token.token}"
        result = get(path, headers: json_headers)
        expect(result).to eq(401)
      end
    end
  end
end
