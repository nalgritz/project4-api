class Api::EnquiriesController < ApplicationController
  before_action :authenticate_renter!, except: [:index, :show]
  before_action :set_enquiry, only:  [:show, :update]

  def index
    @enquiries = Enquiry.all
  end

  def show
  end

  def create
    @enquiry = current_renter.enquiries.new(enquiry_params)
    if @enquiry.save
      render 'show'
    else
      render json: @enquiry.errors.messages, status: 400
    end
  end

  def update
    @enquiry.assign_attributes(enquiry_params)
    if @enquiry.save
      render 'show'
    else
      render json: {errors: @enquiry.errors.messages}, status: 400
    end
  end

  def destroy
    @enquiry.destroy
  end

private

  def set_enquiry
    @enquiry = Enquiry.find_by_id(params[:id])
    if @enquiry.nil?
      render json: {message: "Cannot find enquiry with ID #{params[:id]}"}
    end
  end

  # refer to schema
  def enquiry_params
    params.permit(:region, :area, :bedroom_num, :bathroom_num, :property_size_min, :property_size_max, :price_min, :price_max, :building_type, :timeslot_1_date, :timeslot_1_time, :timeslot_2_date, :timeslot_2_time, :archived, :renter_id)
  end
end