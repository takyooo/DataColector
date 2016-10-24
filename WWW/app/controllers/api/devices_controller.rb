module Api
	class DevicesController < ApplicationController
	  respond_to :json

	  # def index
	  # 	puts 'swdew'
	  # end
	  
	  def add_device
	  	token = Token.find_by(token_name: params[:token_name])
	  	if token.present?
	  		device = Device.new(device_params)
	  		device.token = token 
  	    device.save
	  		render json: {message: "Znaleziono token", device: device}
	  	else
	  		render json: {message: "Nie znaleziono tokenu", params: params}
	  	end
	  end
		private
	  def device_params
	    params.permit(:date, :sensor, :value, :window)
	  end
	end
end