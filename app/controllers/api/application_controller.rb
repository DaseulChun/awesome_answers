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

  # The Priority for 'rescue_from' is in the reverse order of where
  # the calls are made meaning that more specific errors should be
  # rescued last and general errors should be rescued first.

  # The "StandardError" class is an ancestor of all the errors that
  # programmer could cause in their program. Rescuing from it will
  # prevent nearly all errors from crashing our program.
  # Note:- Use this very carefully and make sure to always log the
  # error message in some form. 

  rescue_from StandardError, with: :standard_error
  
  # 'rescue_from' is a method that usable inside controllers
  # to prevent applications from crashing when an exception (a crash)  occurs. if given an 'with:' with a symbol named after a 
  # method will be called instead of crashing a program.
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def not_found
    render(
      status: 404,
      json: {
        status: 404,
        error: [{
          type: "Not Found"
        }]
      }
    )  
  end

  private

  def authenticate_user!
    unless current_user.present?
      render(json: { status: 401 }, status: 401)
    end
  end

  protected
  # protected is like a private except that it prevents
  # descendent classes from using protected methods
  def record_not_found(error)
    render(
      json:{
        errors:[{
          type: error.class.to_s,
          message:error.message
        }]
      }
    )
  end
    
  def standard_error(error)
    # When we rescue an error, we prevent our program from
    # doing what it would normally do in a crash such as logging
    # the details and the backtrace. It's important to always 
    # log this information when rescue for a general type.
  
    # Use the 'logger.error' method with an error's message to 
    # log the error details again
    logger.error error.full_message
  
    render(
      status:500,
      json:{
        status:500,
        errors:[{
          type: error.class.to_s,
          message: error.message
        }]
      }
    )
  end
end
