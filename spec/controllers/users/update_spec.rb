require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe User, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "PUT update" do
    path = "/api/v1/users"
    let(:user) { create(:users) }

    context "when teacher is logged in" do
      let(:valid_token) { create(:access_token, resource_owner_id: user.id, application_id: client.id) }
      let(:expired_token) { create(:expired_token, resource_owner_id: user.id, application_id: client.id) }
      let(:params) do
        {
          name: 'HIHI'
        }
      end
      it "should return http status code 200 when all right" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = patch(path, headers: json_headers, params: params.to_json)
        user.reload
        expect(result).to eq(200)
        expect(user.name).to eq(params[:name])
      end

      it "should return http status code 401 when token is invalid" do
        json_headers[:Authorization] = "Bearer #{expired_token.token}"
        result = patch(path, headers: json_headers, params: params.to_json)
        user.reload
        expect(result).to eq(401)
        expect(user.name).not_to eq(params[:name])
      end
    end
  end
end
