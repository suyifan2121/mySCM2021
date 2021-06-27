class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.all
    @pending_purchase_orders = Order.where(order_type: "purchase").where(status: false).count
    @pending_sales_orders = Order.where(order_type: "sales").where(status: false).count

    # display price as 2 decimal places and append zeroes on the decimal
    @total_purchase_order = '%.2f' % Order.where(order_type: "purchase").sum(:price)
    @total_sales_order = '%.2f' % Order.where(order_type: "sales").sum(:price)
    @upcoming_purchase = Order.where(order_type: "purchase").where("date > ?", Date.today)
    @upcoming_sales = Order.where(order_type: "sales").where("date > ?", Date.today)
    # @expired = Order.expired?
  end

  def purchase_history
    @pending = Order.where(order_type: "purchase")
  end

  def sales_history
    @pending = Order.where(order_type: "sales")
  end

  def purchase_order
    @suppliers = Supplier.all
    @order = Order.find(params[:id])
    @items = JSON.parse(@order.items)
  end

  def sales_order
    @clients = Client.all
    @order = Order.find(params[:id])
    @items = JSON.parse(@order.items)
  end

  def verify
    @order = Order.find(params[:id])

    # perform item decrement if it is a rejected order
    # note: only rejected order will show status as false and not nil
    puts "order status: #{@order.status}"
    if !@order.status.nil?
      unless @order.status
        order_items = JSON.parse(@order.items)

        ActiveRecord::Base.transaction do
          order_items.each do |item|
            @ordered_item = Item.find_by_id(item["id"].to_i)
            @ordered_item.decrement!(:remaining_quantity, item["quantity"].to_i)
          end
        end
      end
    end

    @order.verify
    if @order.save
      redirect_to :root
      flash[:notice] = "Order Verified"
    else
      redirect_to :root
      flash[:notice] = "Order Unable to Verify"
    end
  end

  def reject
    @order = Order.find(params[:id])

    order_items = JSON.parse(@order.items)

    ActiveRecord::Base.transaction do
      order_items.each do |item|
        @ordered_item = Item.find_by_id(item["id"].to_i)
        @ordered_item.increment!(:remaining_quantity, item["quantity"].to_i)
      end
    end

    @order.reject
    if @order.save
      redirect_to :root
      flash[:notice] = "Order Rejected"
    else
      redirect_to :root
      flash[:notice] = "Order Unable to Reject"
    end
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
    @suppliers = Supplier.all
    @clients = Client.all
  end

  def create
    @items = Item.where("remaining_quantity > ?", 0).all
    member_id = current_user.member.id

    order_items = JSON.parse(params[:order][:items]) 

    puts "Params: #{order_params.to_hash}"

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

      @order = Order.new(order_params.merge(member_id: member_id).except(:item_list).except(:client)) if params[:order][:order_type] == "purchase"
      @order = Order.new(order_params.merge(member_id: member_id).except(:item_list).except(:supplier)) if params[:order][:order_type] == "sales"
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
