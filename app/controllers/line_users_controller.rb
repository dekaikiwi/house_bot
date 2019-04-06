class LineUsersController < ApplicationController
  before_action :set_line_user, only: [:show, :edit, :update, :destroy]

  # GET /line_users
  # GET /line_users.json
  def index
    @line_users = LineUser.all
  end

  # GET /line_users/1
  # GET /line_users/1.json
  def show
  end

  # GET /line_users/new
  def new
    @line_user = LineUser.new
  end

  # GET /line_users/1/edit
  def edit
  end

  # POST /line_users
  # POST /line_users.json
  def create
    @line_user = LineUser.new(line_user_params)

    respond_to do |format|
      if @line_user.save
        format.html { redirect_to @line_user, notice: 'Line user was successfully created.' }
        format.json { render :show, status: :created, location: @line_user }
      else
        format.html { render :new }
        format.json { render json: @line_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_users/1
  # PATCH/PUT /line_users/1.json
  def update
    respond_to do |format|
      if @line_user.update(line_user_params)
        format.html { redirect_to @line_user, notice: 'Line user was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_user }
      else
        format.html { render :edit }
        format.json { render json: @line_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_users/1
  # DELETE /line_users/1.json
  def destroy
    @line_user.destroy
    respond_to do |format|
      format.html { redirect_to line_users_url, notice: 'Line user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_user
      @line_user = LineUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_user_params
      @line_user_params = params.require(:line_user).permit(:line_id, :line_username, :is_tasks_user, :central_ids)
      @line_user_params[:central_ids] = @line_user_params[:central_ids].split(',')

      @line_user_params
    end
end
