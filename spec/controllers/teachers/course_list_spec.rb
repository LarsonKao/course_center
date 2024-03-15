require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe Teacher, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "GET course_list" do
    path = "/api/v1/teachers/course_list"
    let(:teacher) { create(:teachers) }
    let(:courses) { create_list(:courses, 5)}


    context "when server is ok" do
      it "should return http status code 200" do
        teacher.courses += courses
        result = get(path + "?teacher_id=#{teacher.id}", headers: json_headers)
        expect(result).to eq(200)
      end
    end
  end
end
