class TokensController < ApplicationController
  def index 
    # @q = Token.search(params[:q])
    # @tokens = @q.result(distinct: true)
    @tokens = Token.all
  end

  def new
    @token = Token.new
  end 

  def create
  	@token = Token.new(token_params)
 
  	@token.save
  	redirect_to tokens_path
  end

  def edit
    @token = Token.find(params[:id])
  end

  def update
    @token = Token.find(params[:id])
 
    if @token.update(token_params)
      redirect_to tokens_path
    else
      render 'edit'
    end
  end

  def destroy
    @token = Token.find(params[:id])
    @token.destroy
 
    redirect_to tokens_path
  end

  private
    def token_params
      params.require(:token).permit(:token_name, :location)
    end

end