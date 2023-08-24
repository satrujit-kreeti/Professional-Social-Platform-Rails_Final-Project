# frozen_string_literal: true

class CertificatesController < ApplicationController
  before_action :find_certificate, only: [:destroy]

  def destroy
    @certificate.destroy
    redirect_to user_profile_user_path(current_user), notice: 'Certificate deleted successfully.'
  end

  private

  def find_certificate
    @certificate = Certificate.find(params[:id])
  end
end
