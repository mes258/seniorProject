require 'aws-sdk'
require 'csv'

BUCKET_NAME = "mixnmatch-profiles"
REGION = "us-west-2a"
CRED_PATH = "../../../credentials.csv"

module ProfilesHelper

	def setCredentials():
    CSV.read(CRED_PATH)
    creds = CSV.read(CRED_PATH)
    aws_id = creds[1][2]
    aws_secret = creds[1][3]
    Aws.config.update({
      credentials: Aws::Credentials.new(aws_id, aws_secret)
    })
  end

  def uploadToBucket(path, id):
    setCredentials()
    s3 = Aws::S3::Resource.new(region: REGION)
    bucket = s3.bucket(BUCKET_NAME)
    if bucket.exists?
      key = "profile_#{id}"
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

  def getURL(key):
    return "https://mixnmatch-profiles.s3-us-west-2.amazonaws.com/#{key}"
  end


end
