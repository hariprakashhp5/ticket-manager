class TrackersController < ApplicationController
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
    respond_to do |format|
      format.html
      format.csv { send_data @trackers.to_csv}
      format.xls# { send_data @trackers.to_csv(col_sep: "\t")}
    end
    
  end

  # def completed_tasks
  # render json: Task.group_by_day(:created_at).count.chart_json
  # end

  def chart_page
    require_user
    a=Time.now 
    my=a.strftime("%-m-%y")

    @pie=Tracker.where('uid=? and created like ?',user, "%#{my}%")
  end

  def current
    require_user
    @tracker = Tracker.new
    @trackers = Tracker.where('uid=? and created_at > ? AND created_at < ?', user, Date.yesterday.beginning_of_day, Date.today.end_of_day).order(created_at: :desc)
    stats=@trackers.pluck("comp")
    @ontime=stats.count("On Time")
    @delay=stats.count("> ETA")
    @early=stats.count("< ETA")
   # Tracker.where("created_at between ? and ?", Date.yesterday.beginning_of_day, Date.today.end_of_day)
  end

def testcod
end

def posttestcod

if params[:accept] == "1"
      path=["//ul/li/p"]
else
      path=["//table/tbody/tr/td/p", "//ul/li/p"]
end

    nogo={'<p> </p>' => '', 
      '<table>' => "\n<table width='100%' border='0' cellspacing='0' cellpadding='0' class='table table-curved'>", 
     '&lt;' => '<', '&gt;'=>'>','<br>' => '','<p></p>' => '', ' rel="nofollow"' => '', "http://www.bankbazaar.com"=>"",
        "https://www.bankbazaar.com"=>"",'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">'=>"",
          "<html><body>"=>"","</body></html>"=>""}  

      
      c=params[:content]
       bundle_out=Sanitize.fragment(c,Sanitize::Config.merge(Sanitize::Config::BASIC,
       :elements=> Sanitize::Config::BASIC[:elements]+['table', 'tbody', 'tr', 'td', 'h1', 'h2', 'h3'],
       :attributes=>{'a' => ['href']}) )

      re = Regexp.new(nogo.keys.map { |x| Regexp.escape(x) }.join('|'))

      puts "re====#{re}"
      intr=bundle_out.gsub(re, nogo)

      doc=Nokogiri::HTML.parse(intr)
      
      path.each do |p|
        puts p
        doc.xpath(p).each do |pp|
          pp.replace(pp.text)
        end
      end
      filter=doc.to_html
      @bundle_out=filter.gsub(re,nogo)


      open_tags= @bundle_out.scan(/</).count
      close_tags= @bundle_out.scan(/<\//).count

      if open_tags/2 == close_tags
        @tags=["Open and close tags are equal"]
      else
        @p=@bundle_out.scan(/<p/).count
        @cp=@bundle_out.scan(/<\/p/).count
        @li=@bundle_out.scan(/<li/).count
        @cli=@bundle_out.scan(/<\/li/).count
        @ul=@bundle_out.scan(/<ul/).count
        @cul=@bundle_out.scan(/<\/ul/).count
        @ol=@bundle_out.scan(/<ol/).count
        @col=@bundle_out.scan(/<\/ol/).count
        @tab=@bundle_out.scan(/<table/).count
        @ctab=@bundle_out.scan(/<\/table/).count
        @tr=@bundle_out.scan(/<tr/).count
        @ctr=@bundle_out.scan(/<\/tr/).count
        @td=@bundle_out.scan(/<td/).count
        @ctd=@bundle_out.scan(/<\/td/).count

        arr=[[@li,@cli,'li'],[@ul,@cul,'ul'],[@ol,@col,'ol'],[@p,@cp,'p'],[@tab,@ctab,'table'],[@tr,@ctr,'tr'],[@td,@ctd,'td']]
        bar=[] #initializing empty array to appand the results
        for i in 0..arr.count-1
        if arr[i][0] != arr[i][1]
        var=arr[i][2]+"="+arr[i][0].to_s+"|"+arr[i][1].to_s
        @error=bar<<var
        end
        end
        @tags=@error
        end
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
    @trackers=Tracker.where("uid=? and finished=?",user, "")
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
        format.html { redirect_to '/home', notice: 'Ticket was added successfully.' }
        format.json { render :index, status: :created, location: @tracker }
      else
        format.html { render :new }
        format.json { render json: @tracker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trackers/1
  # PATCH/PUT /trackers/1.json
  def update
    respond_to do |format|
      if @tracker.update(tracker_params)
        format.html { redirect_to @tracker, notice: 'Ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @tracker }
      else
        format.html { render :edit }
        format.json { render json: @tracker.errors, status: :unprocessable_entity }
      end
    end
    completed
  end

def completed
  @com=Tracker.where("id=?",params[:id]).pluck("finished").last
  if @com != ""
    @eta=Tracker.where("id=?",params[:id]).pluck("eta").last
    @a=Date.parse(@eta)
    @b=Date.parse(@com)
        @c=(@a-@b).to_i
    if @c>0
      @complt="< ETA"
    elsif @c==0
      @complt="On Time"
    elsif @c<0
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
    redirect_to '/home'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tracker
      @tracker = Tracker.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tracker_params
      params.require(:tracker).permit(:ticket_id, :comp, :staging, :created, :eta, :finished, :tow, :owner, :noc, :disc, :uid)
    end

end
