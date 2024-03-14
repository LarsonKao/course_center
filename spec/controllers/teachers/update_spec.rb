require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe Teacher, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "PUT update" do
    path = "/api/v1/teachers"
    let(:teacher) { create(:teachers) }

    context "when user is logged in" do
      let(:valid_token) { create(:access_token, resource_owner_id: teacher.user.id, application_id: client.id) }
      let(:expired_token) { create(:expired_token, resource_owner_id: teacher.user.id, application_id: client.id) }
      let(:params) do
        {
          lab: 'NEW FAB'
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
        teacher.reload
        expect(teacher.lab).to eq(params[:lab])
      end
    end
  end
end
