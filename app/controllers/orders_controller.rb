class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.all
    # display price as 2 decimal places and append zeroes on the decimal
    @total_purchase_order = '%.2f' % Order.where(order_type: "purchase").sum(:price)
    @total_sales_order = '%.2f' % Order.where(order_type: "sales").sum(:price)
    @upcoming_purchase = Order.where(order_type: "purchase").where("date > ?", Date.today).where(status: false)
    @upcoming_sales = Order.where(order_type: "sales").where("date > ?", Date.today).where(status: false)
    
    @pending_purchase_orders = @upcoming_purchase.count
    @pending_sales_orders = @upcoming_sales.count
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

  def return_purchase
    @suppliers = Supplier.all
    @order = Order.find(params[:id])
    @items = JSON.parse(@order.items)
  end

  def return_sales
    @clients = Client.all
    @order = Order.find(params[:id])
    @items = JSON.parse(@order.items)
  end

  # def create_return
  #   puts "Params: #{params.to_hash}"
  #   return_order_items = JSON.parse(params[:order][:return_items]) 

  #   puts "Params: #{return_order_items.to_hash}"

  #   @order = Order.new(return_order_items)


  #   ActiveRecord::Base.transaction do
  #     return_order_items.each do |item|
  #       @ordered_item = Item.find_by_id(item["id"].to_i)
  #       @ordered_item.increment!(:remaining_quantity, item["quantity"].to_i)
  #     end
  #   end

  #   if @order.merge(return: true).create
  #     @current_user = current_user
  #     redirect_to :root, notice: 'Return Order was successfully created.'
  #   else
  #     render :new
  #   end
  # end

  # update is used to mark an order as a return order
  def update
    puts "params: #{params.to_hash}"
    return_order_items = JSON.parse(params[:order][:items]) 

    puts "Params: #{return_order_items}"

    @order = Order.find(params[:id])


    ActiveRecord::Base.transaction do
      return_order_items.each do |item|
        if params[:order].has_key?(:supplier) 
          @ordered_item = Item.find_by_id(item["id"].to_i)
          @ordered_item.decrement!(:remaining_quantity, item["quantity"].to_i)
        else
          @ordered_item = Item.find_by_id(item["id"].to_i)
          @ordered_item.increment!(:remaining_quantity, item["quantity"].to_i)
        end
      end

      @order.return = true
      if @order.save
        @current_user = current_user
        redirect_to :root, notice: 'Return Order was successfully created.'
      else
        render :new
      end
    end

  end

  def new
    @order = Order.new
    @pending_orders = Order.pending?
    @purchase_items = Item.all
    @sales_items = Item.where("remaining_quantity > ?", 0).all
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
        # increase commodity count for purchase orders
        if params[:order].has_key?(:supplier)
          @ordered_item = Item.find_by_id(item["id"].to_i)
          @ordered_item.increment!(:remaining_quantity, item["quantity"].to_i)
        else # decrease for sales orders
          if Item.find_by_id(item["id"].to_i).remaining_quantity >= item["quantity"].to_i
            @ordered_item = Item.find_by_id(item["id"].to_i)
            @ordered_item.decrement!(:remaining_quantity, item["quantity"].to_i)
          else
            flash[:alert] = 'The quantity you entered is not currently available'
            redirect_to :back
          end
        end
      end

      @order = Order.new(order_params.merge(member_id: member_id).except(:item_list).except(:client)) if params[:order][:order_type] == "purchase"
      @order = Order.new(order_params.merge(member_id: member_id).except(:item_list).except(:supplier)) if params[:order][:order_type] == "sales"
      puts "attributes: #{@order.attributes}"

      @order.status = false
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
      params.require(:order).permit(:quantity, :expire_at, :status, :member_id, :supplier, :items, :purchase_items, :sales_items, :purchase_price, :retail_price, :client, :item_list, :order_type, :date, :price, :return_items, :return, :return_date, :return_price)
    end
end
