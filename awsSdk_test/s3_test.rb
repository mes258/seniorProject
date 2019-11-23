require 'aws-sdk'
require 'csv'

BUCKET_NAME = "mixnmatch-profiles"
REGION = "us-west-2"
CRED_PATH = "../credentials.csv"

USAGE = <<DOC

Usage: hello-s3 bucket_name [operation] [file_name]

Where:

  operation   is the operation to perform on the bucket:
              upload  - uploads a file to the bucket
              list    - (default) lists up to 50 bucket items

  file_name   is the name of the file to upload,
              required when operation is 'upload'

DOC

if ARGV.length > 0
  operation = ARGV[0]
else
  puts USAGE
  exit 1
end

creds = CSV.read(CRED_PATH)
aws_id = creds[1][2]
aws_secret = creds[1][3]
Aws.config.update({
  credentials: Aws::Credentials.new(aws_id, aws_secret)
})

# The file name to use with 'upload'
file = nil
file = ARGV[1] if (ARGV.length > 1)

# Get an Amazon S3 resource
s3 = Aws::S3::Resource.new(region: REGION)

# Get the bucket by name
bucket = s3.bucket(BUCKET_NAME)





case operation
when 'upload'
  if file == nil
    puts "You must enter the name of the file to upload to S3!"
    exit
  end

  if bucket.exists?
    name = "keanu"

    # Check if file is already in the bucket
    if bucket.object(name).exists?
      puts "#{name} already exists in the bucket, overwriting..."
    end
      obj = s3.bucket(BUCKET_NAME).object(name)
      obj.upload_file(file, acl: 'public-read')
      puts "Uploaded #{name} to S3 under #{obj.public_url}"
  else
    puts "Unable to find #{BUCKET_NAME}"
  end

when 'list'
  if bucket.exists?
    # Enumerate the bucket contents and object etags
    puts "Contents of '%s':" % BUCKET_NAME
    puts '  Name => GUID'

    bucket.objects.limit(50).each do |obj|
      puts "  #{obj.key} => #{obj.etag}"
    end
  else
    NO_SUCH_BUCKET % BUCKET_NAME
  end

else
  puts "Unknown operation: '%s'!" % operation
  puts USAGE
end
