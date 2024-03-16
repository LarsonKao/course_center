require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe Course, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "GET show" do
    path = "/api/v1/course"
    let(:course) { create(:courses) }
    let(:teacher) { create(:teachers)}
    context "when user is logged in" do
      it "should return http status code 200" do
        course.teachers << teacher
        result = get(path + "?id=#{course.id}", headers: json_headers)
        expect(result).to eq(200)
      end

      it "should return http status code 200" do
        teacher.courses << course
        result = get(path + "?id=#{course.id}", headers: json_headers)
        expect(result).to eq(200)
      end
    end
  end
end
