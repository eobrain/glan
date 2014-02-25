###
# This file is part of the Glan system http://glawn.org
#
# Copyright (c) 2012,2013 Eamonn O'Brien-Strain All rights
# reserved. This program and the accompanying materials are made
# available under the terms of the Eclipse Public License v1.0 which
# accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#    Eamonn O'Brien-Strain  e@obrain.com - initial author
###


BUCKET=glawn.org
REGION=us-west-1

watch:
	coffee --watch --compile --output web/js coffee/*.coffee

compile: coffee/*.coffee
	coffee         --compile --output web/js coffee/*.coffee

test-watch:
	coffee --watch --compile --output web/test/spec test-coffee/*.coffee

test-compile: test-coffee/*.coffee
	coffee         --compile --output web/test/spec test-coffee/*.coffee

server: compile
	: serving from http://localhost:4444
	cd web; python -m SimpleHTTPServer 4444

config:
	:
	: Go key Access Key ID and Secret Access Key go to
	:    https://portal.aws.amazon.com/gp/aws/securityCredentials
	:
	s3cmd --config=s3.config --configure

config-hp:
	hpcloud account:setup

deploy: compile
	s3cmd --config=s3.config '--add-header=Cache-Control:public max-age=60' --acl-public --exclude=\*~ sync web/ s3://$(BUCKET)
#	: view website at http://s3-$(REGION).amazonaws.com/$(BUCKET)/index.htm
	: view website at http://$(BUCKET).s3-website-$(REGION).amazonaws.com

pull-from-site:
	s3cmd --dry-run --config=s3.config sync s3://$(BUCKET) web/ 

web/site/rotimg/images.json: web/site/rotimg/*.jpg
	echo "[" > $@
	for jpg in web/site/rotimg/*.jpg; do echo " \"`basename $$jpg`\"," >> $@; done
	echo 'null]' >> $@

dependencies:
	sudo apt-get install s3cmd coffeescript python

dependencies-hp:
	sudo apt-get install ruby1.9.1 ruby1.9.1-dev 
	curl -sL https://docs.hpcloud.com/file/hpfog-0.0.18.gem >/tmp/hpfog.gem
	sudo gem install /tmp/hpfog.gem
	curl -sL https://docs.hpcloud.com/file/hpcloud-1.4.0.gem >/tmp/hpcloud-1.4.0.gem
	sudo gem install /tmp/hpcloud-1.4.0.gem
	hpcloud info

test: test-compile
	java -jar test-lib/JSCover-all.jar -ws --branch --document-root=web --report-dir=test-out
