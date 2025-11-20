class VolunteersController < ApplicationController
  before_action :authenticate_user!, only: [:index]

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
end