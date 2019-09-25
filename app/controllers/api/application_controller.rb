class Api::ApplicationController < ApplicationController
  # When making POST, DELETE and PATCH request to our
  # controllers, Rails requires that an authenticity token 
  # is included as part of the params. Normally Rails will add
  # this to any form that generates form helper methods
  # (e.g. form_with, form_for, form_tag)
  # This prevents third parties from making such requests to
  # our Rails. It's a security measure that is unneccessary
  # in the context of a web API.
  skip_before_action :verify_authenticity_token

  private

  def authenticate_user!
    unless current_user.present?
      render(json: { status: 401 }, status: 401)
    end
  end
end
