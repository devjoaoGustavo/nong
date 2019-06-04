# frozen_string_literal: true

# Receives and deals with requests related to NGOs' stuffs
class NgosController < ApplicationController
  def index
    @ngos = UseCases::ListingNgo.new.call
  end

  def show
    @ngo = UseCases::NgoLookup.new(id: params[:id]).call
  end

  def new
    @ngo = new_boundary_ngo
    @parent_ngos = UseCases::ListingNgo.new.call
  end

  def create
    Rails.logger.info("Criando uma nova obra social com: #{create_ngo_params}")
    use_case = UseCases::NgoCreation.new(create_ngo_params)

    if use_case.call
      flash[:notice] = 'Obra social criada com sucesso'
      redirect_to(action: :show, id: use_case.created_ngo.id)
    else
      @ngo  = use_case.boundary_ngo
      @ngos = parent_ngos
      @errors = use_case.errors
      flash.now[:alert] = 'Não foi criado'
      render :new
    end
  end

  private

  def create_ngo_params
    params
      .permit(:name, :description, :image_url, :ngo_id)
      .merge(branch: (params[:branch] == '1'))
  end

  def new_boundary_ngo
    Boundary::Ngo.new(id: nil, name: nil, description: nil, image_url: nil)
  end

  def parent_ngos
    params['filial'].present? ? [fake_ngo_head] : []
  end
end
