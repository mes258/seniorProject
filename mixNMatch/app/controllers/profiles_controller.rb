require 'aws-sdk'

BUCKET_NAME = "mixnmatch-profiles"
REGION = "us-west-2"
CRED_PATH = "../credentials.csv"

class ProfilesController < ApplicationController

  before_action :set_profile, only: [:show, :edit, :update, :destroy]

	def getCreds
    puts("set credentials")
    aws_id = Rails.application.secrets.AWS_ID
    aws_secret = Rails.application.secrets.AWS_SECRET
    if aws_id == nil
      puts("No ID")
    else
      puts(aws_id)
    end
    Aws.config.update({
      credentials: Aws::Credentials.new(aws_id, aws_secret)
    })
  end

	def deleteFromBucket(key)
		if key != nil
      getCreds
			s3 = Aws::S3::Resource.new(region: REGION)
			bucket = s3.bucket(BUCKET_NAME)
			if bucket.exists?
				# Check if file is already in the bucket
				if bucket.object(key).exists?
          obj = s3.bucket(BUCKET_NAME).object(key)
  				obj.delete()
					puts "#{key} deleted, overwriting..."
				end
			else
				puts "Unable to find #{BUCKET_NAME}"
			end
		end
		return "default"
	end

  def uploadToBucket(picture)
    if picture != nil
      file = Rails.root.join('public', 'uploads', picture)
      puts "#{picture}"
      getCreds
      s3 = Aws::S3::Resource.new(region: REGION)
      bucket = s3.bucket(BUCKET_NAME)
      if bucket.exists?
        key = "profile_"+current_user.id.to_s
        # Check if file is already in the bucket
        if bucket.object(key).exists?
          obj = s3.bucket(BUCKET_NAME).object(key)
          obj.delete()
					puts "#{key} deleted, overwriting..."
          # Sorry this is jank, we just need this to ensure that updating works
          while (bucket.object(key).exists?)
            sleep(1)
          end
        end
        obj = s3.bucket(BUCKET_NAME).object(key)
        obj.upload_file(file, acl: 'public-read')
        puts "Uploaded #{key} to S3 under #{obj.public_url}"
        return key
      else
        puts "Unable to find #{BUCKET_NAME}"
      end
    end
    return "default"
  end


  # GET /profiles
  # GET /profiles.json
  def index
    #
    #   IF YOU CHANGE THIS CODE YOU ALSO NEED TO CHANGE IT IN MATCHES_CONTROLLER
    #                    (sorry for bad code duplication)
    #
    if(current_user.profile != nil)
        all_profiles = Profile.where("active = ? AND id != ?", true, current_user.profile.id)
    else
        all_profiles = Profile.all
    end

    # choose a random profile to be matched
    if all_profiles.empty?
      @target_profile = Profile.new()
    else
      @target_profile = all_profiles[srand % all_profiles.length]
    end

    # get all compatible profiles
    @profiles = all_profiles.select{ |p| @target_profile.compatible p}.shuffle
    if(@profiles.length > 15)
      @profiles = @profiles[0...15]
    end
    @current_user = current_user
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @profile = current_user.profile
  end

  # GET /profiles/new
  def new
    if current_user.blank?
      redirect_to ""
    end
    @profile = Profile.new
    @current_user = current_user
  end

  # GET /profiles/1/edit
  def edit
    @profile = current_user.profile
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(profile_params)
    @current_user = current_user

    @profile.pictureID = uploadToBucket params[:profile][:picture]

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update

    @profile.pictureID = uploadToBucket params[:profile][:picture]

    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy

    @profile.pictureID = deleteFromBucket @profile.pictureID
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: 'Profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:user_id, :first, :last, :pictureID, :picture, :description, :song, :preference, :gender, :value, :priority, :age, :contact_info, :active)
    end
end
