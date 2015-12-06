class CompanyController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { 
        render json: Company.all.map(&:name)
      }
    end
  end

  def new
    @company = Company.new
  end


  def create
    company = Company.new(company_params)
    company.guilts.build(name: params[:company][:guilt][:name])
    company.scores.build(good_or_bad: false)
    if company.save!
      redirect_to company_index_path, notice: 'GOOD'
    end
  end

  def show
    @company = Company.find(params[:id])
    fail 'fewfew'
  end

  private

  def company_params
    params.require(:company).permit(:name, :owner, :website)
  end
end
