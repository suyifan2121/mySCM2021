class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.all
    @members = Member.all
    @items = Item.all
    @pending_orders = Order.pending?
    # @expired = Order.expired?
  end

  def purchase_history
    @pending = Order.where(order_type: "purchase")
  end

  def sales_history
    @pending = Order.where(order_type: "sales")
  end

  def renew
    @current_user = current_user
    @order = Order.find_by_id(params[:id])
    Order.renew(params[:id])
    redirect_to :root
    flash[:notice] = "Renewed for 7 days from now. Enjoy!"

    begin
      OrderMailer.delay.renew_order(@order, @current_user).deliver
    rescue Exception => e
    end
  end

  def disable
    borrowed_qty = Order.find_by_id(params[:id]).quantity.to_i
    @borrowed_item = Order.find_by_id(params[:id]).item
    @borrowed_item.increment!(:remaining_quantity, borrowed_qty)
    @current_user = current_user
    @order = Order.find_by_id(params[:id])
    Order.disable(params[:id])
    redirect_to :root
    flash[:notice] = "Item marked as returned. Thank you!"

    begin
      OrderMailer.delay.return_order(@order, @current_user).deliver
    rescue Exception => e
    end
  end

  def approve
    @current_user = current_user
    @order = Order.find_by_id(params[:id])
    Order.approve(params[:id])
    redirect_to :root
    flash[:notice] = "Orders Approved"

    begin
      OrderMailer.delay.return_order(@order, @current_user).deliver
    rescue Exception => e
    end
  end

  def new
    @order = Order.new
    @pending_orders = Order.pending?
    @items = Item.where("remaining_quantity > ?", 0).all
  end

  def create
    @items = Item.where("remaining_quantity > ?", 0).all
    member_id = current_user.member.id

    order_items = JSON.parse(params[:order][:items]) 

    # if params[:order][:order_type] == "purchase"
    #   order_items = JSON.parse(params[:order][:purchase_items]) 
    #   order_params[:items] = params[:order][:purchase_items]
    # elsif params[:order][:order_type] == "sales"
    #   order_items = JSON.parse(params[:order][:sales_items])
    #   order_params[:items] = params[:order][:sales_items]
    # end

    puts "params: #{order_params.to_hash}"

    ActiveRecord::Base.transaction do
      order_items.each do |item|
        if Item.find_by_id(item["id"].to_i).remaining_quantity >= item["quantity"].to_i
          @ordered_item = Item.find_by_id(item["id"].to_i)
          @ordered_item.decrement!(:remaining_quantity, item["quantity"].to_i)
        else
          flash[:alert] = 'The quantity you entered is not currently available'
          redirect_to :back
        end
      end

      @order = Order.new(order_params.merge(member_id: member_id).except(:item_list))
      puts "attributes: #{@order.attributes}"
      if @order.save
        @current_user = current_user
        redirect_to :root, notice: 'Order was successfully created.'
        begin
          OrderMailer.delay.create_order(@order, @current_user).deliver
        rescue Exception => e
        end
      else
        render :new
      end
    end

    # if Item.find_by_id(params[:order][:item_id]).remaining_quantity >= params[:order][:quantity].to_i
    #   # params[:order][:status] = true
    #   @order = Order.new(order_params)
    #   if @order.save
    #     @current_user = current_user
    #     @borrowed_item = Item.find_by_id(params[:order][:item_id])
    #     @borrowed_item.decrement!(:remaining_quantity, params[:order][:quantity].to_i)
    #     redirect_to :root, notice: 'Order was successfully created.'
    #     begin
    #       OrderMailer.delay.create_order(@order, @current_user).deliver
    #     rescue Exception => e
    #     end
    #   else
    #     render :new
    #   end
    # else
    #   flash[:alert] = 'The quantity you entered is not currently available'
    #   redirect_to :back
    # end
  end

  def destroy
    borrowed_qty = @order.quantity.to_i
    @borrowed_item = @order.item
    @borrowed_item.increment!(:remaining_quantity, borrowed_qty)
    @current_user = current_user
    @order.destroy

    redirect_to orders_url, notice: 'Order was successfully destroyed.'
    begin
      OrderMailer.delay.cancel_order(@order, @current_user).deliver
    rescue Exception => e
    end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:quantity, :expire_at, :status, :member_id, :supplier, :items, :purchase_items, :sales_items, :purchase_price, :retail_price, :client, :item_list, :order_type, :date, :price)
    end
end
