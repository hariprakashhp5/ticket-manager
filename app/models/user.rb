class User < ActiveRecord::Base
	has_secure_password


	EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i
	validates_presence_of :name

	validates :password, :presence=>true

	validates :email, :presence => true, :length=> {:maximum=> 25},
			   			:uniqueness=>true, :format => {:with=>EMAIL_REGEX}

	def editor? 
		self.role == '0' 
	end

	def admin?
		self.role == '1'
	end

	def qc?
		self.role == '2'
	end

	def dev?
		self.role == '-1'
	end
end
