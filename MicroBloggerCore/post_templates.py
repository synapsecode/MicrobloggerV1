#TODO Post Age helper function caluclator
from MicroBloggerCore.models import db, MicroBlogPost, BlogPost, ShareablePost, PollPost, TimelinePost, ReshareWithComment, CarouselPost
from helperfunctions import calculate_post_age

def userTemplate(user_record):
	return {
		'user_id': user_record.user_id,
		'name': (user_record.name) if (user_record.name != None) else "Default User",
		'username': user_record.username,
		'email': user_record.email,
		'icon': user_record.icon,
		'background': user_record.background,
		'reputation': user_record.reputation[0 : user_record.reputation.index(".")+2],
		'followers' : len(user_record.my_followers),
		'following' : len(user_record.my_following),
		'created_on' : user_record.created_on,
		'bio' : (user_record.bio) if (user_record.bio != "") else "Hey! I use MicroBlogger",
		'location' : (user_record.location),
		'website': (user_record.website)
	}

def carousel(user, post):
	return {
		'type': 'carousel',
		'id': post.post_id,
		'author': {
			'name': (post.author.name) if (post.author.name != None) else "Default User",
			'username': post.author.username,
			'icon': post.author.icon
		},
		'likes': len(post.likes),
		'reshares': len(post.reshares),
		'comments': len(post.comments),
		'content': post.content,
		'images': post.images,
		'age': calculate_post_age(post.created_on),
		'isLiked': True if (post.post_id in [x.post_id for x in user.liked_posts] ) else False,
		'isReshared': True if (post.post_id in [x.og_post_id for x in user.reshared_posts] ) else False,
		'isBookmarked': True if (post.post_id in [x.post_id for x in user.bookmarked_posts] ) else False,
		# 'isEdited': post.isEdited
	}

def comment(user, c):
	postID = None
	postType = None
	if(c.microblog_pid):
		postID = MicroBlogPost.query.filter_by(id=c.microblog_pid).first().post_id
		postType = 'microblog'
	elif(c.blog_pid):
		postID = BlogPost.query.filter_by(id=c.blog_pid).first().post_id
		postType = 'blog'
	elif(c.timeline_pid):
		postID = TimelinePost.query.filter_by(id=c.timeline_pid).first().post_id
		postType = 'timeline'
	elif(c.rwc_pid):
		postID = ReshareWithComment.query.filter_by(id=c.rwc_pid).first().post_id
		postType = 'ResharedWithComment'
	return {
		'cid': c.comment_id,
		'parent_post_type':postType,
		'parent_post_id':postID,
		'author': {
			'name': (c.author.name) if (c.author.name != None) else "Default User",
			'username': c.author.username,
			'icon': c.author.icon
		},
		'type': 'comment',
		'content': c.content,
		'category': c.category,
		'likes': len(c.likes),
		'age': calculate_post_age(c.created_on),
		'isLiked': True if (c.comment_id in [x.post_id for x in user.liked_posts] ) else False,
		# 'isEdited': post.isEdited
	}

def microblog(user, post):
	return {
		'type':'microblog',
		'id': post.post_id,
		'author': {
			'name': (post.author.name) if (post.author.name != None) else "Default User",
			'username': post.author.username,
			'icon': post.author.icon
		},
		'likes': len(post.likes),
		'reshares': len(post.reshares),
		'comments': len(post.comments),
		'content': post.content,
		'category': post.category,
		'age': calculate_post_age(post.created_on),
		'isLiked': True if (post.post_id in [x.post_id for x in user.liked_posts] ) else False,
		'isReshared': True if (post.post_id in [x.og_post_id for x in user.reshared_posts] ) else False,
		'isBookmarked': True if (post.post_id in [x.post_id for x in user.bookmarked_posts] ) else False,
		# 'isEdited': post.isEdited
	}

def blog(user, post):
	return {
		'type':'blog',
		'id': post.post_id,
		'background': post.background,
		'blog_name': post.blog_name,
		'author': {
			'name': (post.author.name) if (post.author.name != None) else "Default User",
			'username': post.author.username,
			'icon': post.author.icon
		},
		'likes': len(post.likes),
		'reshares': len(post.reshares),
		'comments': len(post.comments),
		'content': post.content,
		'age': calculate_post_age(post.created_on),
		'isLiked': True if (post.post_id in [x.post_id for x in user.liked_posts] ) else False,
		'isReshared': True if (post.post_id in [x.og_post_id for x in user.reshared_posts] ) else False,
		'isBookmarked': True if (post.post_id in [x.post_id for x in user.bookmarked_posts] ) else False,
		# 'isEdited': post.isEdited
	}

def poll(user, post):
	selected = -1
	#print(user.username, user.voted_polls)
	for i in user.voted_polls:
		# print(post.post_id, i['poll_id'])
		if(i['poll_id'] == post.post_id):
			selected = i['selected']
			break
	return {
		'type':'poll',
		'id': post.post_id,
		'author': {
			'name': (post.author.name) if (post.author.name != None) else "Default User",
			'username': post.author.username,
			'icon': post.author.icon
		},
		'content': post.content,
		'options': post.options,
		'age': calculate_post_age(post.created_on),
		'isLiked': True if (post.post_id in [x.post_id for x in user.liked_posts] ) else False,
		'likes': len(post.likes),
		'votedFor': selected
		# 'votedFor': selectedOption
	}

def shareable(user, post):
	return {
		'type':'shareable',
		'id': post.post_id,
		'author': {
			'name': (post.author.name) if (post.author.name != None) else "Default User",
			'username': post.author.username,
			'icon': post.author.icon
		},
		'content': post.content,
		'likes': len(post.likes),
		'reshares': len(post.reshares),
		'age': calculate_post_age(post.created_on),
		'name': post.name,
		'link': post.link,
		'isLiked': True if (post.post_id in [x.post_id for x in user.liked_posts] ) else False,
		'isReshared': True if (post.post_id in [x.og_post_id for x in user.reshared_posts] ) else False,
		'isBookmarked': True if (post.post_id in [x.post_id for x in user.bookmarked_posts] ) else False,
		# 'isEdited': post.isEdited
	}

def timeline(user, post):
	return {
		'type':'timeline',
		'id': post.post_id,
		'background': post.background,
		'timeline_name': post.timeline_name,
		'author': {
			'name': (post.author.name) if (post.author.name != None) else "Default User",
			'username': post.author.username,
			'icon': post.author.icon
		},
		'likes': len(post.likes),
		'reshares': len(post.reshares),
		'age': calculate_post_age(post.created_on),
		'comments': len(post.comments),
		'events': post.events,
		'isLiked': True if (post.post_id in [x.post_id for x in user.liked_posts] ) else False,
		'isReshared': True if (post.post_id in [x.og_post_id for x in user.reshared_posts] ) else False,
		'isBookmarked': True if (post.post_id in [x.post_id for x in user.bookmarked_posts] ) else False,
		# 'isEdited': post.isEdited
	}

def simpleReshare(user, post):
	child = {}
	if(post.host_type == 'microblog'):
		child = microblog(user, MicroBlogPost.query.filter_by(post_id=post.host_id).first())
	elif(post.host_type == 'blog'):
		child = blog(user, BlogPost.query.filter_by(post_id=post.host_id).first())
	if(post.host_type == 'shareable'):
		child = shareable(user, ShareablePost.query.filter_by(post_id=post.host_id).first())
	if(post.host_type == 'timeline'):
		child = timeline(user, TimelinePost.query.filter_by(post_id=post.host_id).first())
	if(post.host_type == 'carousel'):
		child = carousel(user, CarouselPost.query.filter_by(post_id=post.host_id).first())

	return {
		'type':'SimpleReshare',
		'id': post.post_id,
		'author': {
			'name': (post.author.name) if (post.author.name != None) else "Default User",
			'username': post.author.username,
			'icon': post.author.icon
		},
		'child': child
	}
	
def reshareWithComment(user, post):
	child = {}
	if(post.host_type == 'microblog'):
		child = microblog(user, MicroBlogPost.query.filter_by(post_id=post.host_id).first())
	elif(post.host_type == 'blog'):
		child = blog_skin(user, BlogPost.query.filter_by(post_id=post.host_id).first())
	if(post.host_type == 'shareable'):
		child = shareable(user, ShareablePost.query.filter_by(post_id=post.host_id).first())
	if(post.host_type == 'timeline'):
		child = timeline_skin(user, TimelinePost.query.filter_by(post_id=post.host_id).first())
	if(post.host_type == 'carousel'):
		child = carousel(user, CarouselPost.query.filter_by(post_id=post.host_id).first())
	return {
		'type':'ResharedWithComment',
		'id': post.post_id,
		'author': {
			'name': (post.author.name) if (post.author.name != None) else "Default User",
			'username': post.author.username,
			'icon': post.author.icon
		},
		'likes': len(post.likes),
		'content': post.content,
		'category': post.category,
		'comments': len(post.comments),
		'age': calculate_post_age(post.created_on),
		'child': child,
		'isLiked': True if (post.post_id in [x.post_id for x in user.liked_posts] ) else False,
		'isBookmarked': True if (post.post_id in [x.post_id for x in user.bookmarked_posts] ) else False,
		# 'isEdited': post.isEdited
	}

def newsArticle(headline, url, background, source="internet"):
	return {
		'type': 'newsArticle',
		'link': url,
		'background':background,
		'source': source
	}



#PIECE FUNCTIONS

def timeline_skin(user, post):
	return {
		'type':'timeline',
		'id': post.post_id,
		'background': post.background,
		'timeline_name': post.timeline_name,
		'author': {
			'name': (post.author.name) if (post.author.name != None) else "Default User",
			'username': post.author.username,
			'icon': post.author.icon
		},
	}

def timeline_body(user, post):
	return {
		'type':'timeline',
		'id': post.post_id,
		'timeline_name': post.timeline_name,
		'background': post.background,
		'author': {
			'name': (post.author.name) if (post.author.name != None) else "Default User",
			'username': post.author.username,
			'icon': post.author.icon
		},
		'likes': len(post.likes),
		'reshares': len(post.reshares),
		'age': calculate_post_age(post.created_on),
		'comments': len(post.comments),
		'events': post.events,
		'isLiked': True if (post.post_id in [x.post_id for x in user.liked_posts] ) else False,
		'isReshared': True if (post.post_id in [x.og_post_id for x in user.reshared_posts] ) else False,
		'isBookmarked': True if (post.post_id in [x.post_id for x in user.bookmarked_posts] ) else False,
		# 'isEdited': post.isEdited
	}

def blog_skin(user, post):
	return {
		'type':'blog',
		'id': post.post_id,
		'background': post.background,
		'blog_name': post.blog_name,
		'age': calculate_post_age(post.created_on),
		'author': {
			'name': (post.author.name) if (post.author.name != None) else "Default User",
			'username': post.author.username,
			'icon': post.author.icon
		},
	}

def blog_body(user, post):
	return {
		'type':'blog',
		'id': post.post_id,
		'blog_name': post.blog_name,
		'background': post.background,
		'author': {
			'name': (post.author.name) if (post.author.name != None) else "Default User",
			'username': post.author.username,
			'icon': post.author.icon
		},
		'comments': len(post.comments),
		'likes': len(post.likes),
		'reshares': len(post.reshares),
		'content': post.content,
		'age': calculate_post_age(post.created_on),
		'isLiked': True if (post.post_id in [x.post_id for x in user.liked_posts] ) else False,
		'isReshared': True if (post.post_id in [x.og_post_id for x in user.reshared_posts] ) else False,
		'isBookmarked': True if (post.post_id in [x.post_id for x in user.bookmarked_posts] ) else False,
		# 'isEdited': post.isEdited
	}

def get_comments_from_post(user, post):
	return [comment(user, c) for c in post.comments]

#'commenfts': [comment(user, c) for c in post.comments],