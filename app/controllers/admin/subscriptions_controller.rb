class Admin::SubscriptionsController < Admin::BaseController
  before_action :set_subscription, only: [:edit, :update, :destroy]

  def index
    @subscriptions = Subscription.all
  end

  def new
    @subscription = Subscription.new
  end

  def create
    @subscription = Subscription.new(subscription_params)
    if @subscription.save
      redirect_to admin_subscriptions_path, notice: 'サブスクリプションを追加しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @subscription.update(subscription_params)
      redirect_to admin_subscriptions_path, notice: 'サブスクリプションを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @subscription.destroy
    redirect_to admin_subscriptions_path, notice: 'サブスクリプションを削除しました'
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.require(:subscription).permit(:name, :monthly_fee)
  end
end