require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe Course, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "GET index" do
    path = "/api/v1/courses"
    let(:course) { create(:courses) }
    let(:course_2) { create(:courses) }
    let(:teacher) { create(:teachers)}
    let(:teacher_2) { create(:teachers)}

    context "when user is logged in" do
      it "should return http status code 200" do
        teacher.courses << course
        teacher.courses << course_2
        teacher_2.courses << course_2
        result = get(path, headers: json_headers)
        expect(result).to eq(200)
      end
    end
  end
end
