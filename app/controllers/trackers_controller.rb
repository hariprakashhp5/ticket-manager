class TrackersController < ApplicationController
  #respond_to :html, :json

  before_action :set_tracker, only: [:show, :edit, :update, :destroy]

  # GET /trackers
  # GET /trackers.json
  def index
    require_user
    stats=Tracker.where('uid=?',user).pluck("comp")
    @ontime=stats.count("On Time")
    @delay=stats.count("> ETA")
    @early=stats.count("< ETA")
    @trackers = Tracker.where('uid=?',user).order(created_at: :desc)
    @control="1"
    respond_to do |format|
      format.html
      format.csv { send_data @trackers.to_csv}
      format.xls# { send_data @trackers.to_csv(col_sep: "\t")}
    end
    
  end

  def ind_dynamic
    require_user
    stats=Tracker.where('uid=?',user).pluck("comp")
    @ontime=stats.count("On Time")
    @delay=stats.count("> ETA")
    @early=stats.count("< ETA")
    @trackers = Tracker.where('uid=?',user).order(created_at: :desc)
    @control="1"
    render :partial => "/trackers/table.html.erb"
  end


  # def completed_tasks
  # render json: Task.group_by_day(:created_at).count.chart_json
  # end

  def chart_page
    require_user
    a=DateTime.now 
    ist=a.in_time_zone("Chennai")
    my=ist.strftime("%-m-%y")

     @pie=Tracker.where('uid=? and created like ?',user, "%#{my}%")
    
  end

  def current_dynamic
    require_user
    @control="0"
    @tracker = Tracker.new
    @trackers = Tracker.where('uid=? and created_at > ? AND created_at < ?', user, Date.yesterday.beginning_of_day, Date.today.end_of_day).order(created_at: :desc)
    render :partial => "/trackers/table.html.erb"
  end

  def current
  
    require_user
    @control="0"
    @tracker = Tracker.new
    @trackers = Tracker.where('uid=? and created_at > ? AND created_at < ?', user, Date.yesterday.beginning_of_day, Date.today.end_of_day).order(created_at: :desc)
   #  stats=@trackers.pluck("comp")
   #  @ontime=stats.count("On Time")
   #  @delay=stats.count("> ETA")
   #  @early=stats.count("< ETA")
   # # Tracker.where("created_at between ? and ?", Date.yesterday.beginning_of_day, Date.today.end_of_day)

  end



  def status
    require_user
      @date = params[:month] ? Date.parse(params[:month]) : Date.today
      my=@date.strftime("%-m-%y")
      puts my
      # @dat = Tracker.where('created_at > ? AND created_at < ?', @date.beginning_of_day, @date.end_of_month.end_of_day)
      @dat=Tracker.where("uid=? and finished LIKE ? or finished Like ?", user, "%#{my}%", "#{@date.strftime("%m/%y")}").order(created_at: :asc)
      stats=@dat.pluck("comp")
      @this_month_neutral=stats.count("On Time")
      @this_month_delay=stats.count("> ETA")
      @this_month_early=stats.count("< ETA")
      @pen= Tracker.where("uid=? and finished=?",user, "")
      @trackers = Tracker.where("uid=?",user)
    stats=@trackers.pluck("comp")
    @ontime=stats.count("On Time")
    @delay=stats.count("> ETA")
    @early=stats.count("< ETA")

    respond_to do |format|
      format.html
      format.csv { send_data @dat.to_csv}
      format.xls# { send_data @trackers.to_csv(col_sep: "\t")}
    end

  end

  def pending_tickets
    if current_user.admin?
      @trackers=Tracker.where("finished=?","")
    else
    @trackers=Tracker.where("uid=? and finished=?",user, "")
  end
  end
    # GET /trackers/1
  # GET /trackers/1.json
  def show
    
  end

  # GET /trackers/new
  # def new
  #   @tracker = Tracker.new
  #   redirect_to '/trackers'
  # end

  # GET /trackers/1/edit
  def edit
  end

  # POST /trackers
  # POST /trackers.json
  def create
    @tracker = Tracker.new(tracker_params)

    respond_to do |format|
      if @tracker.save
        puts @tracker.id
        BgWorker.perform_async(@tracker.id)
        format.html { redirect_to '/home', notice: 'Ticket was added successfully.' }
        format.json { render :index, status: :created, location: @tracker }
      else
        format.html { render :new }
        format.json { render json: @tracker.errors, status: :unprocessable_entity }
      end
    end
  end

def to_qc
  tracker=Tracker.find(params[:id])
  tracker.update(:status=>"1")
  render :layout => false
end

def error
  tracker=Tracker.find(params[:id])
  tracker.update(:status=>"2")
  render :layout => false
end

def to_push
  tracker=Tracker.find(params[:id])
  tracker.update(:status=>"3")
  render :layout => false
end

def live
  tracker=Tracker.find(params[:id])
  tracker.update(:status=>"4")
  render :layout => false
end

def finished
  tracker=Tracker.find(params[:id])
  current=DateTime.now
  ist=current.in_time_zone("Chennai")
  # finish=ist.strftime("%b %d, %Y %H:%M")
  finish=ist.strftime("%d-%m-%y %H:%M")
  #eta=Tracker.where("id=?",params[:id]).pluck("eta").last
  eta = tracker.eta
  a=Date.parse(eta)
  b=Date.parse(finish)
    if a>b
      complt="< ETA"
    elsif a==b
      complt="On Time"
    elsif a<b
      complt="> ETA"
    end
  time_diff=TimeDifference.between(tracker.created,finish).in_hours
  respond_to do |format|
 if  tracker.update(:finished=>finish,:comp => complt,:status=>'5', :time_taken => time_diff )
  format.json { render :index, status: :ok, location: @tracker }
  #render :layout => false
  end
  end
end

  # PATCH/PUT /trackers/1
  # PATCH/PUT /trackers/1.json
  def update
    respond_to do |format|
      if @tracker.update(tracker_params)
        format.html { redirect_to '/quality_check', notice: 'Ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @tracker }
      else
        format.html { render :edit }
        format.json { render json: @tracker.errors, status: :unprocessable_entity }
      end
    end
    #completed
  end


def completed
  @com=Tracker.where("id=?",params[:id]).pluck("finished").last
  if @com != ""
    @eta=Tracker.where("id=?",params[:id]).pluck("eta").last
    @a=Date.parse(@eta)
    @b=Date.parse(@com)
    #        @c=(@a-@b).to_i
    if @a>@b
      @complt="< ETA"
    elsif @a==@b
      @complt="On Time"
    elsif @a<@b
      @complt="> ETA"
    end
    puts "oooo====#{@complt}"
@tracker.update(:comp => @complt) 
end
end


  # DELETE /trackers/1
  # DELETE /trackers/1.json
  def destroy
    @tracker.destroy
    respond_to do |format|
      format.html { redirect_to trackers_url, notice: 'Tracker was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def remove
    require_admin
    Tracker.delete_all
    #redirect_to '/home'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tracker
      @tracker = Tracker.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tracker_params
      params.require(:tracker).permit(:ticket_id, :comp, :staging, :created, :eta, :finished, :tow, :owner, :noc, :disc, :uid, :bugs, :status, :prod_remarks, :qc_remarks, :time_taken)
    end

end
