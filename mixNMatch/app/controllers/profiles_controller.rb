require 'aws-sdk'
require 'csv'

BUCKET_NAME = "mixnmatch-profiles"
REGION = "us-west-2a"
CRED_PATH = "../../../credentials.csv"

class ProfilesController < ApplicationController

  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  helper_method :uploadToBucket
  def uploadToBucket(picture)
    if picture != nil
      puts(picture)
      file = Rails.root.join('public', 'uploads', picture.filename)
      CSV.read(CRED_PATH)
      creds = CSV.read(CRED_PATH)
      aws_id = creds[1][2]
      aws_secret = creds[1][3]
      Aws.config.update({
        credentials: Aws::Credentials.new(aws_id, aws_secret)
      })
      s3 = Aws::S3::Resource.new(region: REGION)
      bucket = s3.bucket(BUCKET_NAME)
      if bucket.exists?
        key = "profile_"+@current_user.id.to_s
        # Check if file is already in the bucket
        if bucket.object(key).exists?
          puts "#{key} already exists in the bucket, overwriting..."
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
    @profiles = Profile.all
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
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
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(profile_params)
    @current_user = current_user
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
      params.require(:profile).permit(:user_id, :first, :last, :pictureID, :description, :song, :preference, :gender, :value, :priority)
    end
end
