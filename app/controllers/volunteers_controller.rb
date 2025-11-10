
class VolunteersController < ApplicationController
  before_action :authenticate, only: [:index]

  def index
    @volunteers = Volunteer.all
  end

  def new
    @volunteer = Volunteer.new
  end

  def create
    @volunteer = Volunteer.new(volunteer_params)
    if @volunteer.save
      redirect_to new_volunteer_path, notice: "Thank you for registering!"
    else
      flash.now[:alert] = "There were errors with your submission."
      render "volunteers/new"
    end
  end

  private

  def volunteer_params
    params.require(:volunteer).permit(:name, :nickname, :email, :phone, :city, :date, :training, :waiver, shifts: [])
  end


  def authenticate
    authenticate_or_request_with_http_basic("Restricted Area") do |username, password|
      # Replace "mysecretpass" with your desired passphrase
      password == "edmontonvolunteers"
    end
  end
end