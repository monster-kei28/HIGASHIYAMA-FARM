class Admin::HarvestExperiencesController < Admin::BaseController
  def index
    @harvest_experiences = HarvestExperience.order(created_at: :asc)
  end

  def destroy
    harvest_experience = HarvestExperience.find(params[:id])

    if harvest_experience.reservations.exists?
      redirect_to admin_harvest_experiences_path,
                  alert: "予約が紐づいているため削除できません"
      return
    end

    harvest_experience.destroy
    redirect_to admin_harvest_experiences_path, notice: "収穫体験を削除しました"
  end
end