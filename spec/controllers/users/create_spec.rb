require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe User, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "POST create teacher" do
    path = "/api/v1/users"
    let(:params) do
      {
      email: 'test@example.com',
      password: 'password',
      client_id: client.uid,
      name: 'John Doe'
      }
    end

    it "should return http status code 200 when all right" do
      result = post(path, headers: json_headers, params: params.to_json)
      user = User.find_by(email: params[:email])
      expect(result).to eq(200)
      expect(user).to be_present
    end

    it "should return http status code 403 when client is invalid" do
      params[:client_id] = "invalid_id"
      result = post(path, headers: json_headers, params: params.to_json)
      user = User.find_by(email: params[:email])
      expect(result).to eq(403)
      expect(user).to be_nil
    end

    it "should return http status code 422 when activerecord exception" do
      allow_any_instance_of(User).to receive(:save).and_return(false)
      result = post(path, headers: json_headers, params: params.to_json)
      user = User.find_by(email: params[:email])
      expect(result).to eq(422)
      expect(user).to be_nil
    end
  end
end
