class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  def index
    @members = Member.all
  end

  def new
    @member = Member.new
  end

  def edit
  end

  def create
    user_params = member_params

    @member = Member.new(member_params.except(:password, :password_confirmation))
    if @member.save
      # create a new user for this particular member
      @user = User.new(user_params)
      @user.save

      redirect_to :root, notice: 'Member was successfully created.'
    else
      render :new
    end
  end

  def update
    if @member.update(member_params)
      redirect_to :root, notice: 'Member was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @member.orders.where(status: true).count == 0
      @member.destroy
      redirect_to :root, notice: 'Member was successfully destroyed.'
    else
      flash[:alert] = 'Members with active orders can not be deleted. Mark his/hers open orders as returned and try again.'
      redirect_to root_url
    end
  end

  private
    def set_member
      @member = Member.find(params[:id])
    end

    def member_params
      params.require(:member).permit(:name, :email, :phone, :password, :password_confirmation)
    end
end
