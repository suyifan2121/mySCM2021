class SuppliersController < ApplicationController
  # load_and_authorize_resource

  def index
    @suppliers = Supplier.all
    @supplier = Supplier.new
  end

  def new
    @supplier = Supplier.new
  end

  def edit
    @supplier = Supplier.find(params[:id])
  end

  def create
    @supplier = Supplier.new(supplier_params)
    if @supplier.save
      redirect_to :root, notice: 'Supplier was successfully created.'
    else
      render :new
    end
  end

  def update
    @supplier = Supplier.find(params[:id])
    if @supplier.update(supplier_params)
      redirect_to :root, notice: 'Supplier was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
      @supplier = Supplier.find(params[:id])
      @supplier.destroy
      redirect_to :root, notice: 'Supplier was successfully destroyed.'
  end

  private
    def supplier_params
      params.require(:supplier).permit(:name, :contact_person, :email, :phone, :address, :supplier)
    end
end
