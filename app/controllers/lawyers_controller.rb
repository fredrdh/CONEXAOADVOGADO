class LawyersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @lawyers = policy_scope(Lawyer)
    @lawyers = @lawyers.where("? = ANY(\"group\")", params[:group]) if params[:group].present?
  end

  def show
    @lawyer = Lawyer.find(params[:id])
    authorize @lawyer
    @connection = Connection.new
  end

  def new
    @lawyer = Lawyer.new
    authorize @lawyer
  end

  def create
    @lawyer = Lawyer.new(lawyer_params)
    @lawyer.user = current_user
    authorize @lawyer
    if @lawyer.save
      redirect_to lawyer_path(@lawyer), alert: "Lawyer created with success!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @lawyer = Lawyer.find(params[:id])
    authorize @lawyer
  end

  def update
    @lawyer = Lawyer.find(params[:id])
    authorize @lawyer
    @lawyer.update(lawyer_params)
    redirect_to lawyer_path(@lawyer)
  end

  def destroy
    @lawyer = Lawyer.find(params[:id])
    authorize @lawyer
    @lawyer.destroy
    redirect_to lawyers_path
  end

  # def my_lawyers
  # @lawyers = Lawyer.where(user: current_user)
  # end

  # def my_connections
  #   @connections = Connection.where(user: current_user)}
  # end

  private

  # def apply_filters(scope, filters)
  #   filters ||= {}

  #   filter_mapping = {
  #     group: ->(value) { scope.where("CAST(\"group\"->>'name' AS TEXT) ILIKE ?", "%#{value}%") },
  #     # Adicione outros filtros aqui, se necessário
  #   }

  #   filters.each { |key, value| scope = filter_mapping[key]&.call(value) || scope }

  #   @lawyers = scope
  # end

  def lawyer_params
    params.require(:lawyer).permit(:UF, :status, :city, :photos, :category, :detail, :OAB, :faculty, :group, :photo)
  end

  # def search
  #   @lawyers = Lawyer.where("group LIKE ?", "%#{params[:q]}%")
  #   render :index
  # end
end
