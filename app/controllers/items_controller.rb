class ItemsController < ApplicationController

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

    # collction_selectで選択肢を呼び出す記述
    @category_parent_array = Category.where(ancestry: nil)
    @condition = Condition.all
    @postage = Postage.all
    @region = Region.all
    @delivery_day = DeliveryDay.all
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

  private

  def item_params
    params.require(:item).permit(:name, :text, :category_id, :condition_id, :region_id, :postage_id, :delivery_day_id, :price, images_attributes: [:id, :image] )
  end
end