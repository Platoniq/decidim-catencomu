# frozen_string_literal: true

module CivicrmStubs
  def stub_user_valid_request
    stub_request(:get, user_request_url)
      .with(
        headers: headers
      ).to_return(
        status: 200,
        body: file_fixture("user_valid_response.txt").read,
        headers: {}
      )
  end

  def stub_user_not_found_request
    stub_request(:get, user_request_url)
      .with(
        headers: headers
      ).to_return(
        status: 200,
        body: file_fixture("user_not_found_response.txt").read,
        headers: {}
      )
  end

  def stub_user_invalid_request
    stub_request(:get, user_request_url)
      .with(
        headers: headers
      ).to_return(
        status: 200,
        body: file_fixture("user_invalid_response.txt").read,
        headers: {}
      )
  end

  private

  def user_request_url
    "https://api.base/?action=Get&api_key=api-key&entity=User&id=42&json=%7B%22sequential%22:1%7D&key=secret"
  end

  # This will change depending on your gems versions.
  def headers
    {
      "Accept" => "*/*",
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent'=>'Faraday v1.2.0'
    }
  end
end
