require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe Teacher, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "POST create teacher" do
    path = "/api/v1/teachers"
    let(:user) { create(:users) }
    let(:teacher) { create(:teachers)}
    let(:params) {{ lab: "LAB202" }}
    let(:valid_token) { create(:access_token, resource_owner_id: user.id, application_id: client.id) }
    let(:expired_token) { create(:expired_token, resource_owner_id: user.id, application_id: client.id) }

    context "when user has no teacher" do
      it "should return http status code 200" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = post(path, headers: json_headers, params: params.to_json)
        expect(result).to eq(200)
      end

      it "should return the teacher" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        post(path, headers: json_headers, params: params.to_json)
        result = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(result[:id]).to eq(user.teacher.id)
      end
    end

    context "when user has no teacher" do
      let(:valid_token) { create(:access_token, resource_owner_id: teacher.user.id, application_id: client.id) }
      let(:expired_token) { create(:expired_token, resource_owner_id: teacher.user.id, application_id: client.id) }
      it "should return 404" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = post(path, headers: json_headers, params: params.to_json)
        expect(result).to eq(400)
      end
    end

    context "when user already has a teacher auth" do
      it "should return http status code 400" do
        user.teacher = teacher
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = post(path, headers: json_headers)
        expect(result).to eq(400)
      end
    end

    context "when create failed" do
      it "should return http status code 422" do
        allow_any_instance_of(User).to receive(:save).and_return(false)
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = post(path, headers: json_headers, params: params.to_json)
        expect(result).to eq(422)
      end
    end
  end
end
