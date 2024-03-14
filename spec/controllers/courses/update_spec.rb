require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe Course, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "PUT update" do
    path = "/api/v1/courses"
    let(:course) { create(:courses) }
    let(:teacher) { create(:teachers) }

    context "when user is logged in" do
      let(:valid_token) { create(:access_token, resource_owner_id: teacher.user.id, application_id: client.id) }
      let(:params) do
        {
          id: course.id,
          credit: 2
        }
      end
      it "should return http status code 200" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        result = patch(path, headers: json_headers, params: params.to_json)
        expect(result).to eq(200)
      end

      it "should update the creadit" do
        json_headers[:Authorization] = "Bearer #{valid_token.token}"
        patch(path, headers: json_headers, params: params.to_json)
        course.reload
        expect(course.credit).to eq(params[:credit])
      end
    end

    context "when there is no course" do
      let(:valid_token) { create(:access_token, resource_owner_id: teacher.user.id, application_id: client.id) }
      let(:params) do
        {
          id: course.id + 1,
          credit: 2
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
