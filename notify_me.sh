#!/usr/bin/env bash 

if curl -# -f https://purl.vanderbilt.edu/purls.css > /dev/null ; then
	echo "Everything seems to be working..."
else
	curl http://textbelt.com/text -d number=6153801013 -d "message=It fuckin broke again.."
fi
