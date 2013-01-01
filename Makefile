BUCKET=www-s3-staging.missionanalyticsgroup.com
#BUCKET=www.missionanalyticsgroup.com
REGION=us-west-1

watch:
	coffee --watch --compile --output web/js coffee/*.coffee

compile: web/site/rotimg/images.json
	coffee         --compile --output web/js coffee/*.coffee

server: compile
	: serving from http://localhost:4444
	cd web; python -m SimpleHTTPServer 4444

config:
	:
	: Go key Access Key ID and Secret Access Key go to
	:    https://portal.aws.amazon.com/gp/aws/securityCredentials
	:
	s3cmd --config=s3.config --configure

deploy: compile
	s3cmd --config=s3.config '--add-header=Cache-Control:public max-age=60' --acl-public --exclude=\*~ sync web/ s3://$(BUCKET)
	: view website at http://s3-$(REGION).amazonaws.com/$(BUCKET)/index.html

web/site/rotimg/images.json: web/site/rotimg/*.jpg
	echo "[" > $@
	for jpg in web/site/rotimg/*.jpg; do echo " \"`basename $$jpg`\"," >> $@; done
	echo 'null]' >> $@

dependencies:
	sudo apt-get install s3cmd coffeescript python


