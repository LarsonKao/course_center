module HeadersHelper
  def self.get_formdata_headers(token = nil)
    if token.present?
      headers = {"Content-Type": "multipart/form-data", Authorization: "Bearer #{token}"}
    else
      headers = {"Content-Type": "multipart/form-data"}
    end
    
  end

  def self.get_json_headers(token = nil)
    if token.present?
      {"Content-Type": "application/json", Authorization: "Bearer #{token}"}
    else
      {"Content-Type": "application/json"}
    end
    
  end
end