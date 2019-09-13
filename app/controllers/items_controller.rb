class ItemsController < ApplicationController
  before_action :set_category_list, only: [:index, :show]
  before_action :set_item_form_collction_select, only: [:new, :edit]

  def show
    @item = Item.find(params[:id])
    @saler_items = Item.where(saler_id: @item.saler_id).limit(6).order('created_at DESC')
    @same_category_items = Item.where(category_id: @item.category_id).limit(6).order('created_at DESC')
  end

  def index
    ladies_categories    = Category.where('ancestry LIKE(?)', "1/%")
    mens_categories      = Category.where('ancestry LIKE(?)', "2/%")
    kids_categories      = Category.where('ancestry LIKE(?)', "3/%")
    cosmetics_categories = Category.where('ancestry LIKE(?)', "7/%")
    chanel_id            = Brand.find_by(name: "シャネル")
    louisVuitton_id      = Brand.find_by(name: "ルイ ヴィトン")
    supreme_id           = Brand.find_by(name: "シュプリーム")
    nike_id              = Brand.find_by(name: "ナイキ")

    @ladies_items       = Item.category_items(ladies_categories).recent(4)
    @mens_items         = Item.category_items(mens_categories).recent(4)
    @kids_items         = Item.category_items(kids_categories).recent(4)
    @cosmetics_items    = Item.category_items(cosmetics_categories).recent(4)
    @chanel_items       = Item.brand_items(chanel_id).recent(4)
    @louisVuitton_items = Item.brand_items(louisVuitton_id).recent(4)
    @supreme_items      = Item.brand_items(supreme_id).recent(4)
    @nike_items         = Item.brand_items(nike_id).recent(4)
  end

  def new
    @item = Item.new
    10.times{@item.images.build}
  end

  # 親カテゴリーが選択された後に動くアクション
  def get_category_children
    #選択された親カテゴリーに紐付く子カテゴリーの配列を取得
    @category_children = Category.find("#{params[:parent_id]}").children
  end

  # 子カテゴリーが選択された後に動くアクション
  def get_category_grandchildren
    #選択された子カテゴリーに紐付く孫カテゴリーの配列を取得
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end

  def create
    @item = Item.new(item_params)
    @parents = Category.where(ancestry: nil)
    if @item.save
      redirect_to root_path
    else
      render action: :new
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy! if item.saler_id == current_user.id
    redirect_to root_path
  end

  def edit
    @item = Item.find(params[:id])
    10.times{@item.images.build}
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to root_path
    else
      render action: :edit
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :text, :category_id, :condition_id, :region_id, :postage_id, :delivery_day_id, :delivery_way_id, :brand_id, :price, images_attributes: [:id, :image] ).merge(saler_id: current_user.id, size_id: 1)
  end

  # 出品フォームの選択肢をセット
  def set_item_form_collction_select
    @category_parent_array = Category.where(ancestry: nil)
    @brand                 = Brand.all
    @condition             = Condition.all
    @postage               = Postage.all
    @region                = Region.all
    @delivery_day          = DeliveryDay.all
    @delivery_way          = DeliveryWay.all
  end
end