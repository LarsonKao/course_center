require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe Teacher, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "GET show" do
    path = "/api/v1/teacher"
    let(:teacher) { create(:teachers) }
    let(:user) { create(:users) }

    context "when teacher is logged in" do
      let(:valid_token) { create(:access_token, resource_owner_id: teacher.user.id, application_id: client.id) }
      let(:expired_token) { create(:expired_token, resource_owner_id: teacher.user.id, application_id: client.id) }

      it "should return http status code 200" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = get(path, headers: json_headers)
        expect(result).to eq(200)
      end

      it "should return the teacher" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        get(path, headers: json_headers)
        result = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(result[:id]).to eq(teacher[:id])
      end
    end

    context "when user has no teacher" do
      let(:valid_token) { create(:access_token, resource_owner_id: user.id, application_id: client.id) }
      let(:expired_token) { create(:expired_token, resource_owner_id: user.id, application_id: client.id) }

      it "should return http status code 404" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = get(path, headers: json_headers)
        expect(result).to eq(404)
      end

    end
  end
end
