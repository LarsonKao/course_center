require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe Student, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "PUT update" do
    path = "/api/v1/students"
    let(:student) { create(:students) }
    let(:user) { create(:users) }

    context "when user is logged in" do
      let(:valid_token) { create(:access_token, resource_owner_id: student.user.id, application_id: client.id) }
      let(:expired_token) { create(:expired_token, resource_owner_id: student.user.id, application_id: client.id) }
      let(:params) do
        {
          status: 'freshman'
        }
      end
      it "should return http status code 200" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = patch(path, headers: json_headers, params: params.to_json)
        expect(result).to eq(200)
      end

      it "should update the user name" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        patch(path, headers: json_headers, params: params.to_json)
        student.reload
        expect(student.status).to eq(params[:status])
      end
    end

    context "when user has no student" do
      let(:valid_token) { create(:access_token, resource_owner_id: user.id, application_id: client.id) }

      let(:params) do
        {
          status: 'freshman'
        }
      end

      it "should return http status code 404" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = patch(path, headers: json_headers, params: params.to_json)
        expect(result).to eq(404)
      end
    end
  end
end
