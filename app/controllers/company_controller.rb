class CompanyController < ApplicationController
  def index
  end

  def new
    @company = Company.new
  end

  def edit
  end

  def create
    @company = Company.create(company_params)

    if @company.save
      redirect_to company_path
    else
      render :new
    end
  end

  def show
    @company = Company.find(params[:id])
  end

  def update
  end

  def destory
  end

  private

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
