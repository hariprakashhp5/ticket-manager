class DashboardController < ApplicationController


	def index
		require_dev_or_admin
		@users=User.all
		@trackers=Tracker.all.order(created_at: :desc)
		 @pen= Tracker.where("finished=?", "")
		@stats=@trackers.pluck("comp")
		 @p_count=Tracker.where("uid=? and finished=?", user,"").count
		respond_to do |format|
      format.html
      format.csv { send_data @trackers.to_csv}
      format.xls# { send_data @trackers.to_csv(col_sep: "\t")}
    end
	end

	def dashb_dynamic
		require_dev_or_admin
		@users=User.all
		@trackers=Tracker.all.order(created_at: :desc)
		 @pen= Tracker.where("finished=?", "")
		@stats=@trackers.pluck("comp")
		 @p_count=Tracker.where("uid=? and finished=?", user,"").count
		 render :partial => "/dashboard/dashb.html.erb"
	end


	def qc_remarks
	  @qc_remark=Tracker.where("id=?",params[:id]).pluck("qc_remarks").first
	  puts "abc===#{@qc_remark}"

	end

	def inbound
		@trackers=Tracker.where("comp=?","< ETA")
	end

	def neutral
		@trackers=Tracker.where("comp=?","On Time")
	end

	def outbound
		@trackers=Tracker.where("comp=?","> ETA")
	end

	def qcin
		require_qc_or_admin_or_dev
		@trackers=Tracker.where("status=?", "1")
	end

	def qc_dynamic
		require_qc_or_admin_or_dev
		@trackers=Tracker.where("status=?", "1")
		render :partial => "/dashboard/qc.html.erb"
	end

	def assign
		#params[:tid], params[:uid]
		puts params[:tid]
		@tracker = Tracker.new("ticket_id"=>params[:tid].first, "uid"=>params[:uid],"finished"=>"")

    respond_to do |format|
      if @tracker.save
      	BgWorker.perform_async(@tracker.id)
        format.html { redirect_to '/dashboard', notice: 'Ticket was assigned successfully.' }
        format.json { render :index, status: :created, location: @dashboard }
      else
        format.html { render :new }
        format.json { render json: @tracker.errors, status: :unprocessable_entity }
      end
    end
	end
end
