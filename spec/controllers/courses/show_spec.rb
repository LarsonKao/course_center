require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe Course, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "GET show" do
    path = "/api/v1/courses"
    let(:course) { create(:courses) }

    context "when user is logged in" do
      it "should return http status code 200" do
        result = get(path + "?id=#{course.id}", headers: json_headers)
        expect(result).to eq(200)
      end

      it "should return the course" do
        get(path + "?id=#{course.id}", headers: json_headers)
        result = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(result[:id]).to eq(course.id)
      end
    end
  end
end
