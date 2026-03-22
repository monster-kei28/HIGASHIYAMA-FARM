class Admin::TopPageImagesController < Admin::BaseController
  before_action :set_page_image

  def edit; end

  def update
    if @page_image.update(page_image_params)
      redirect_to edit_admin_top_page_image_path, notice: "トップページ画像を更新しました"
    else
      flash.now[:alert] = @page_image.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_page_image
    @page_image = PageImage.find_or_initialize_by(page_type: :top, slot: :hero)
    @page_image.position ||= 1
    @page_image.published = true if @page_image.published.nil?
  end

  def page_image_params
    params.require(:page_image).permit(:image).merge(
      page_type: :top,
      slot: :hero,
      position: 1,
      published: true
    )
  end
end
