from cloudinary.uploader import upload
from cloudinary.utils import cloudinary_url
import time

def upload_file_to_cloud(filebytes, filetype=None):
	try:
		start = time.time()
		# Initialize Variables
		objectURI = ""
		if(filetype != None):
			uploaded_object = upload(filebytes,
									 notification_url="http://localhost",
									 api_key="597356837268799",
									 resource_type=str(filetype),
									 api_secret="MgLEKQS1aHJs6TVkGNrv-mfneY0",
									 cloud_name="krustel-inc"
									 )
			objectURI = uploaded_object['secure_url']
		else:
			uploaded_object = upload(filebytes,
									 notification_url="http://localhost",
									 api_key="597356837268799",
									 api_secret="MgLEKQS1aHJs6TVkGNrv-mfneY0",
									 cloud_name="krustel-inc"
									 )
			objectURI = uploaded_object['secure_url']

		end = time.time()
		print(f"TOOK {int(end-start)} seconds to finish")
		return({
			"STATUS": "OK",
			"URI": str(objectURI),
		})
	except Exception as e:
		print("EERRRRRRR", e)
		return({
			"STATUS": "ERR",
			"ERRCODE": str(e)
		})
