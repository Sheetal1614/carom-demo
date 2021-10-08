# frozen_string_literal: true

class DocumentsController < ApplicationController

  # --------- Filters ------------------------------------------------------
  skip_before_action :restricted_to_logged_in_user_only

  def index
    @apis_listing = {
        'Step 01' => <<EOF,
Ask application admin for creating a new team (after signup).
EOF
        'Step 02' => <<EOF,
Update team leaders and members. Create a new poke with a cron expression and url (only team leaders can create/update a poke

Cron expression hint:
#{Poke::CRON_HELP}
Note: Url should accept POST request with(/out) parameters and respond with 2xx response.
And returning response should have response header 'validating-uuid' with value duplicating from request header of same name, 
else 'doable' & 'live' will fail.
EOF
    }
  end

  def cron_expression_description
    @description = (Cronex::ExpressionDescriptor.new(params[:cron_expression]).description rescue "that's gibberish")
  end

  def test_callback
    Rails.logger.debug("========#{request.headers["HTTP_VALIDATING_UUID"].inspect}")
    Rails.logger.debug("========#{params.inspect}")
    response.set_header('Validating-Uuid', request.headers["HTTP_VALIDATING_UUID"])

    head :ok
  end
end
