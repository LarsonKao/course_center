require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe User, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "GET show" do
    path = "/api/v1/users"
    let(:user) { create(:users) }
    let(:valid_token) { create(:access_token, resource_owner_id: user.id, application_id: client.id) }
    let(:invalid_token) { create(:expired_token, resource_owner_id: user.id, application_id: client.id) }

    it "should return http status code 200 when all right" do
      json_headers[:Authorization] = "Bearer #{valid_token.token}"
      result = get(path, headers: json_headers)
      expect(result).to eq(200)
    end

    it "should return http status code 401 when token is invalid" do
      json_headers[:Authorization] = "Bearer #{invalid_token.token}"
      result = get(path, headers: json_headers)
      expect(result).to eq(401)
    end
  end
end
