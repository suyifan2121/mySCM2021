class ClientsController < ApplicationController
  def index
    @clients = Client.all
    @client = Client.new
  end

  def new
    @client = Client.new
  end

  def edit
    @client = Client.find(params[:id])
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      redirect_to :root, notice: 'Client was successfully created.'
    else
      render :new
    end
  end

  def update
    @client = Client.find(params[:id])
    if @client.update(client_params)
      redirect_to :root, notice: 'Client was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
      @client = Client.find(params[:id])
      @client.destroy
      redirect_to :root, notice: 'Client was successfully destroyed.'
  end

  private
    def client_params
      params.require(:client).permit(:name, :contact_person, :email, :phone, :address)
    end
end
