require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe User, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:teacher_client) }

  describe "POST create" do
    path = "/api/v1/users"
    let(:params) do
      {
      email: 'test@example.com',
      password: 'password',
      client_id: client.uid,
      name: 'John Doe'
      }
    end

    context "when all valid params" do
      it "should create a new user" do
        post(path, headers: json_headers, params: params.to_json)

        created_user = User.find_by(email: params[:email])

        expect(created_user.email).not_to eq(nil)
      end

      it "should return http status code 200" do
        result = post(path, headers: json_headers, params: params.to_json)
        expect(result).to eq(200)
      end
    end
  end
end
