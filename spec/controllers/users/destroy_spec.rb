require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe User, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "DELETE destroy" do
    path = "/api/v1/users"
    let(:user) { create(:users) }

    context "when teacher is logged in" do
      let(:valid_token) { create(:access_token, resource_owner_id: user.id, application_id: client.id) }
      let(:expired_token) { create(:expired_token, resource_owner_id: user.id, application_id: client.id) }

      it "should return http status code 200" do
        result = delete(path, headers: {Authorization: "Bearer #{valid_token.token}"})
        expect(result).to eq(200)
      end

      it "should delete the user" do
        before = User.find_by(id: user.id)
        expect(before).to eq(user)
        delete(path, headers: {Authorization: "Bearer #{valid_token.token}"})
        after = User.find_by(id: user.id)
        expect(after).to be_nil
      end

      it "should delete the token" do
        before_valid_token = Doorkeeper::AccessToken.find_by(id: valid_token.id)
        expect(before_valid_token).to eq(valid_token)
        before_expired_token = Doorkeeper::AccessToken.find_by(id: expired_token.id)
        expect(before_expired_token).to eq(expired_token)

        delete(path, headers: {Authorization: "Bearer #{valid_token.token}"})

        after_valid_token = Doorkeeper::AccessToken.find_by(id: valid_token.id)
        expect(after_valid_token).to be_nil
        after_expired_token = Doorkeeper::AccessToken.find_by(id: expired_token.id)
        expect(after_expired_token).to be_nil
      end
    end
  end
end
