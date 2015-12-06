class CompanyController < ApplicationController

  def index
    @company = Company.all
  end

  def new
    @company = Company.new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destory
  end
end
