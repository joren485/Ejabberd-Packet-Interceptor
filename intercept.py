import sys
import base64

body64 = sys.argv[1]
body = base64.b64decode(body64)

if body == "test string":
	m = "test string 2"
else:	
	m = "Other message"

m64 = base64.b64encode(m)


## use stdout instead of print, because print has a \n at the end.
sys.stdout.write(m64)
