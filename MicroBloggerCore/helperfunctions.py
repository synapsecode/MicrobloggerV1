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

def caluclate_post_age_delta(created):
	now = str(datetime.today().strftime("%b %d, %Y %H:%M:%S"))
	FMT = "%b %d, %Y %H:%M:%S"
	tdelta = datetime.strptime(now, FMT) - datetime.strptime(str(created), FMT)
	return tdelta


def get_unavailable_post(post_type):
	return {
		'type': post_type,
		'id': '000000000000',
		'author': {
			'name': "Unavailable Post",
			'username': "unavailable",
			'icon': "https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png"
		},
		'likes': 0,
		'reshares': 0,
		'comments': 0,
		'content': "This post has been deleted or is unavailable at the moment.",
		'category': "Uncategorized",
		'age': '0x00',
		'isLiked': False,
		'isReshared': False,
		'isBookmarked': False,

		'link': 'https://www.google.com/4uhr',
		'name':'Unavailable',

		'background': 'https://www.insidetheiot.com/wp-content/uploads/2019/05/Update-rollback.jpg',
		'blog_name': 'Unavailable Blog',

		'timeline_name': 'Unavailable Timeline',
		'events': [],

	}


def extract_hashtags(content):
	import re
	content = content.strip()
	tags = re.findall(r'#[\w]*', content)
	return tags

def parse_hashtags(obj, body):
	used_tags = extract_hashtags(body)
	existing_tags = [x.hashtag for x in obj.hashtags]

	used_tags = [t[1:] for t in used_tags]

	A = set(existing_tags)
	B = set(used_tags)
	
	tag_delta = A - B #Tags that have breen removed
	tags = A.union(B) - A - A.intersection(B) #New Tags

	#Removing the Hash Symbol
	tags = list(tags)
	tag_delta = list(tag_delta)

	#Removing Tags
	print("Post Type:", obj.post_type)
	print("Existing Hashtags:", A)
	print("Current Hashtags:", B)
	if(len(tag_delta) > 0):
		print("Removing:", tag_delta)
		obj.removehashtag(tag_delta)
	
	#Adding Tags
	if(len(tags) > 0):
		print("Adding:", tags)
		obj.addhashtag(tags)