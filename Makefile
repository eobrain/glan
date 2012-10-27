watch:
	coffee --watch --compile --output web/js coffee/*.coffee

compile:
	coffee         --compile --output web/js coffee/*.coffee

server: compile
	: serving from http://localhost:4444
	cd web; python -m SimpleHTTPServer 4444

deploy: compile
	s3cmd --config=s3.config '--add-header=Cache-Control:public max-age=60' --acl-public --exclude=\*~ sync web s3://www-s3-staging.missionanalyticsgroup.com

dependencies:
	sudo apt-get install s3cmd coffeescript python
	:
	: Go key Access Key ID and Secret Access Key go to
	:    https://portal.aws.amazon.com/gp/aws/securityCredentials
	:
	s3cmd --config=s3.config --configure



#
# "max-age=7200, must-revalidate"
