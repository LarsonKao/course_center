require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe Course, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }
  let(:course) { create(:courses) }
  let(:params) {{id: course.id}}
  describe "DELETE destroy" do
    path = "/api/v1/courses"
    context "when user is a teacher" do
      let(:teacher) { create(:teachers) }
      let(:valid_token) { create(:access_token, resource_owner_id: teacher.user.id, application_id: client.id) }

      it "should return http status code 200" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = delete(path + "?id=#{course.id}", headers: json_headers)
        expect(result).to eq(200)
      end

      it "should delete the course" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        id = course.id
        delete(path + "?id=#{course.id}", headers: json_headers)
        result = Course.find_by(id: id)
        expect(result).to be_nil
      end
    end

    context "when user is not a teacher" do
      let(:user) {create(:users)}
      let(:valid_token) { create(:access_token, resource_owner_id: user.id, application_id: client.id) }

      it "should return http status code 404" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = delete(path + "?id=#{course.id}", headers: json_headers)
        expect(result).to eq(404)
      end
    end
  end
end
