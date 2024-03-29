require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe Student, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "POST create student" do
    path = "/api/v1/students"
    let(:user) { create(:users) }
    let(:student) { create(:students)}

    context "when user has no student" do
      let(:valid_token) { create(:access_token, resource_owner_id: user.id, application_id: client.id) }
      let(:expired_token) { create(:expired_token, resource_owner_id: user.id, application_id: client.id) }

      it "should return http status code 200" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = post(path, headers: json_headers)
        expect(result).to eq(200)
      end

      it "should return the student" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        post(path, headers: json_headers)
        result = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(result[:id]).to eq(user.student.id)
      end
    end

    context "when user has already student auth" do
      let(:valid_token) { create(:access_token, resource_owner_id: student.user.id, application_id: client.id) }
      let(:expired_token) { create(:expired_token, resource_owner_id: student.user.id, application_id: client.id) }
      it "should return 400" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = post(path, headers: json_headers)
        expect(result).to eq(400)
      end
    end

    context "when save failed" do
      let(:valid_token) { create(:access_token, resource_owner_id: user.id, application_id: client.id) }
      let(:expired_token) { create(:expired_token, resource_owner_id: user.id, application_id: client.id) }

      it "should return http status code 422" do
        allow_any_instance_of(User).to receive(:save).and_return(false)
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = post(path, headers: json_headers)
        expect(result).to eq(422)
      end
    end
  end
end
