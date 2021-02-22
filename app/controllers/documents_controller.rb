# frozen_string_literal: true

class DocumentsController < ApplicationController

  # --------- Filters ------------------------------------------------------
  skip_before_action :restricted_to_logged_in_almighty_only

  def index
    @apis_listing = {
        'Step 01' => <<EOF,
Create a new account (after signup).
EOF
        'Step 02' => <<EOF,
Update account details, configure frequency and url.

Note: Url should accept POST request with(/out) parameters and respond with 2xx response.
And returning response should have response header 'validating-uuid' with value duplicating from request header of same name, 
else 'doable' & 'live' will fail.
EOF
    }
  end

  def test_callback
    Rails.logger.debug("========#{request.headers["HTTP_VALIDATING_UUID"].inspect}")
    Rails.logger.debug("========#{params.inspect}")
    response.set_header('Validating-Uuid', request.headers["HTTP_VALIDATING_UUID"])

    head :ok
  end
end
