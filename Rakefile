task :zip do
  puts "Zipping lambda function..."
  `zip -r lambda.zip . --exclude .git/\\*`
end

task :up do
  puts "Updating lambda on AWS..."
  `aws lambda update-function-code --function-name support-algolia --zip-file fileb://$PWD/lambda.zip`
end

task :bundle_deployment do
  puts "Bundling deployment dependencies..."
  `bundle install --deployment`
end

task :bundle_no_deployment do
  puts "Removing bundle deployment lock..."
  # This task removes the bundle lock from deploying
  `bundle install --no-deployment`
end

task sync: %i(
  bundle_deployment
  zip
  up
  bundle_no_deployment
) do
  puts "Sync complete!"
end
