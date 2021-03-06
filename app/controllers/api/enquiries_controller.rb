class Api::EnquiriesController < ApplicationController
  before_action :authenticate_renter!, except: [:index, :show]
  before_action :set_enquiry, only:  [:show, :update]

  def index
    @enquiries = current_renter.enquiries
  end

  def show
  end

  # save enquiry, match agents with enquiry and create new enquiry_agent
  def create
    @enquiry = current_renter.enquiries.new(enquiry_params)
    if @enquiry.save
      areas = @enquiry.areas
      areas.each do |area|
        matched_agents = Agent.where("'#{area}' = ANY (areas) ")
        matched_agents.each do |agent|
          # push enquiry with agent id and current enquiry id
          EnquiryAgent.create(agent_id: agent.id, enquiry_id: @enquiry.id)
        end
      end
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

   params.require(:enquiry).permit( :bedroom_num, :bathroom_num, :property_size_min, :property_size_max, :price_min, :price_max, :archived, :renter_id, :region, :remarks, :urgent, :movein_date, :walkup, :open_kitchen, :pet_friendly, :areas => [], :available_days => [],:timeslot => [] )
    # params.require(:enquiry).permit(:areas, :bedroom_num, :bathroom_num, :property_size_min, :property_size_max, :price_min, :price_max, :archived, :renter_id, :region, :remarks, :urgent, :movein_date, :available_days, :timeslot, :walkup, :open_kitchen, :pet_friendly)

  end
end
