watch:
	coffee --watch --compile --output web/js coffee/*.coffee


server:
	: serving from http://localhost:4444
	cd web; python -m SimpleHTTPServer 4444