class DevicesController < ApplicationController
  def index
    # @q = Device.search(params[:q])
    # @devices = @q.result(distinct: true)  	
  	@devices = Device.all
  	# p @devices

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @device = Device.find(params[:id])
    @device.destroy
 
    redirect_to devices_path
  end  
end