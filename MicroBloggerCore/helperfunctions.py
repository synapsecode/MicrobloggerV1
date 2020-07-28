from datetime import datetime
import math

def calculate_post_age(created):
	now = str(datetime.today().strftime("%b %d, %Y %H:%M:%S"))
	FMT = "%b %d, %Y %H:%M:%S"
	tdelta = datetime.strptime(now, FMT) - datetime.strptime(str(created), FMT)
	age = ""
	if(tdelta.days <= 0):
		if(tdelta.seconds < 60) : age = "now"
		elif(tdelta.seconds >= 60 and tdelta.seconds < 3600): age = f"{int(math.floor(tdelta.seconds/60))}m"
		elif(tdelta.seconds >= 3600 and tdelta.seconds <= 86400): age = f"{int(math.floor(tdelta.seconds/3600))}h"
	elif(tdelta.days > 0 and tdelta.days <= 7): age = f"{tdelta.days}d"
	elif(tdelta.days >= 8 and tdelta.days <=365):
		x = created.split(" ")[:3]
		age = f"{x[0]} {x[1][:2]}"
	elif(tdelta.days > 365):
		x = created.split(" ")[:3]
		age = f"{x[0]} {x[2]}"
	return age

