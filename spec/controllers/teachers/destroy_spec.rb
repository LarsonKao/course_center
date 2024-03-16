require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe Teacher, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "DELETE destroy" do
    path = "/api/v1/teachers"
    let(:teacher) { create(:teachers) }
    let(:user) { create(:users) }

    context "when user is logged in" do
      let(:valid_token) { create(:access_token, resource_owner_id: teacher.user.id, application_id: client.id) }
      let(:expired_token) { create(:expired_token, resource_owner_id: teacher.user.id, application_id: client.id) }

      it "should return http status code 200" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = delete(path, headers: json_headers)
        expect(result).to eq(200)
      end

      it "should delete the teacher" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        id = teacher.id
        delete(path, headers: json_headers)
        result = Teacher.find_by(id: id)
        expect(result).to be_nil
      end
    end

    context "when token is bad" do
      let(:valid_token) { create(:access_token, resource_owner_id: teacher.user.id, application_id: client.id) }
      let(:expired_token) { create(:expired_token, resource_owner_id: teacher.user.id, application_id: client.id) }

      it "should return http status code 401" do
        json_headers[:Authorization] = "Bearer #{expired_token.token}"
        result = delete(path, headers: json_headers)
        expect(result).to eq(401)
      end
    end

    context "when user has no teacher" do
      let(:valid_token) { create(:access_token, resource_owner_id: user.id, application_id: client.id) }

      it "should return http status code 404" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = delete(path, headers: json_headers)
        expect(result).to eq(404)
      end
    end
  end
end
