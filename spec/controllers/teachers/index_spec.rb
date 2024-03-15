require 'rails_helper'
require 'helpers/headers_helper'
RSpec.describe Teacher, type: :request do
  let(:json_headers){HeadersHelper.get_json_headers}
  let(:client) { create(:client) }

  describe "GET show" do
    path = "/api/v1/teachers"
    let!(:teachers) { create_list(:teachers, 5) }


    context "when server is ok" do
      it "should return http status code 200" do
        result = get(path, headers: json_headers)
        expect(result).to eq(200)
      end
    end
  end
end
