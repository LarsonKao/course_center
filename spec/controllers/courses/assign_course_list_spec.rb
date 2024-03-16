require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe Course, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "GET assign_course_list" do
    path = "/api/v1/courses/assign_course_list"
    let(:teacher) { create(:teachers) }
    let(:courses) { create_list(:courses, 2)}


    context "when server is ok" do
      it "should return http status code 200" do
        teacher.courses += courses
        result = get(path + "?teacher_id=#{teacher.id}", headers: json_headers)
        expect(result).to eq(200)
      end
    end

    context "when teacher is not found" do
      it "should return http status code 404" do
        teacher.courses += courses
        result = get(path + "?teacher_id=#{-5}", headers: json_headers)
        expect(result).to eq(404)
      end
    end
  end
end
