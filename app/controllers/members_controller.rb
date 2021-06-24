class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  def index
    @members = Member.all
    @member = Member.new
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
      @user = User.new(user_params.except(:role)) #exclude role as we dont use "role" column for user table

      # update the user role
      set_user_role(params[:member][:role])
      @user.member = @member
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
    unless @member == current_user.member
      @member.destroy
      redirect_to :root, notice: 'Member was successfully destroyed.'
    else
      flash[:alert] = 'Not allowed to delete current user.'
      redirect_to root_url
    end
  end

  private
    def set_member
      @member = Member.find(params[:id])
    end

    def member_params
      params.require(:member).permit(:name, :email, :phone, :password, :password_confirmation, :role)
    end

    # set user role based on roles selected while creating member
    def set_user_role(role)
      case role
      when "superadmin"
        @user.superadmin_role = true
      when "sysadmin"
        @user.sysadmin_role = true
      when "inventoryadmin"
        @user.inventoryadmin_role = true
      when "purchasingagent"
        @user.purchasingagent_role = true
      when "salesagent"
        @user.salesagent_role = true
      end
    end
end
