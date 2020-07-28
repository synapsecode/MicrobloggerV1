from flask import render_template, url_for, flash, redirect, request, jsonify
from MicroBloggerCore import app, db
from MicroBloggerCore.models import (User, MicroBlogPost, BlogPost, TimelinePost, ShareablePost,
 PollPost, ReshareWithComment, SimpleReshare, Comment, BookmarkedPosts, ResharedPosts)
from post_templates import microblog, blog, timeline, poll, shareable, reshareWithComment, simpleReshare, userTemplate, comment

#TODO: Unify functions and make it efficient

@app.route("/")
def homepage():
	return "Welcome to the microblogger API"

@app.route("/login", methods=['POST'])
def loginpage():
	data = request.get_json()
	username = data['username']
	password = data['password']
	user_record = User.query.filter_by(username=username, password=password).first()
	if(user_record):
		return jsonify({
			'code': 'S1',
			'user': userTemplate(user_record)
		})
	else:
		return jsonify({
			'code': 'E1',
			'message': 'Incorrect username or password'
		})

@app.route("/register", methods=['POST'])
def registerpage():
	data = request.get_json()
	username = data['username']
	password = data['password']
	email = data['email']
	new_user = User(username=username, email=email, password=password)
	db.session.add(new_user)
	db.session.commit()
	user_record = User.query.filter_by(username=username, password=password).first()
	print(user_record)
	return jsonify({
		'code': 'S1',
		'user': userTemplate(user_record)
	})

@app.route("/all_users")
def allusers():
	users = User.query.all()
	return jsonify(
		{
			'code': 'S1',
			'users': [userTemplate(u) for u in users]
		}
	)

@app.route("/profile/<username>")
def getprofile(username):
	user_record = User.query.filter_by(username=username).first()
	if(user_record):
		return jsonify({
			'code': 'S1',
			'user': userTemplate(user_record),
			'posts': getUserData(username)
		})
	else:
		return jsonify({
			'code': 'E2',
			'message': 'Profile does not exist!'
		})

@app.route('/feed', methods=['POST'])
def feed():
	#TODO: Make it more efficient!! URGENT!!!!
	data = request.get_json()
	username = data['username']
	print(f"username: {username}")
	user = User.query.filter_by(username=username).first()
	if(user):
		feed = []
		following = user.my_following
		for u in [user.username, *following]:
			user = User.query.filter_by(username=u).first()
			[feed.append(microblog(user, x)) for x in MicroBlogPost.query.filter_by(author_id=user.id).all()]
			[feed.append(blog(user, x)) for x in BlogPost.query.filter_by(author_id=user.id).all()]
			[feed.append(shareable(user, x)) for x in ShareablePost.query.filter_by(author_id=user.id).all()]
			[feed.append(poll(user, x)) for x in PollPost.query.filter_by(author_id=user.id).all()]
			[feed.append(timeline(user, x)) for x in TimelinePost.query.filter_by(author_id=user.id).all()]
			[feed.append(reshareWithComment(user, x)) for x in ReshareWithComment.query.filter_by(author_id=user.id).all()]
			[feed.append(simpleReshare(user, x)) for x in SimpleReshare.query.filter_by(author_id=user.id).all()]
		
		return jsonify({
			'code': 'S1',
			'feedlength': len(feed),
			'feed': feed
		})
	else:
		return jsonify({
			'code': 'E1',
			'message': 'Invalid user submission'
		})
	
#----------------------------------------------POST COMPOSER-----------------------------------------------
@app.route('/createmicroblog', methods=['POST'])
def create_microblog():
	data = request.get_json()
	username = data['username']
	content = data['content']
	category = data['category']
	user = User.query.filter_by(username=username).first()
	mxb = MicroBlogPost(author=user, category=category, content=content)
	db.session.add(mxb)
	db.session.commit()
	return jsonify({
		'microblog': microblog(user, mxb)
	})

@app.route('/createblog', methods=['POST'])
def create_blog():
	data = request.get_json()
	username = data['username']
	content = data['content']
	blog_name = data['blog_name']

	user = User.query.filter_by(username=username).first()
	xb = BlogPost(author=user, blog_name=blog_name, content=content, background="https://cdn.vox-cdn.com/thumbor/eHhAQHDvAi3sjMeylWgzqnqJP2w=/0x0:1800x1200/1200x0/filters:focal(0x0:1800x1200):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/13272825/The_Verge_Hysteresis_Wallpaper_Small.0.jpg")

	db.session.add(xb)
	db.session.commit()
	return jsonify({
		'blog': blog(user, xb)
	})

@app.route('/createshareable', methods=['POST'])
def create_shareable():
	data = request.get_json()
	username = data['username']
	content = data['content']
	name = data['name']
	link = data['link']

	user = User.query.filter_by(username=username).first()
	sb = ShareablePost(author=user, name=name, content=content, link=link)
	db.session.add(sb)
	db.session.commit()
	return jsonify({
		'shareable': shareable(user, sb)
	})

@app.route('/createpoll', methods=['POST'])
def create_poll():
	data = request.get_json()
	username = data['username']
	content = data['content']
	options = data['options']

	user = User.query.filter_by(username=username).first()
	p = PollPost(author=user, content=content, options=options)
	db.session.add(p)
	db.session.commit()
	return jsonify({
		'poll': poll(user, p)
	})

@app.route('/createtimeline', methods=['POST'])
def create_timeline():
	data = request.get_json()
	username = data['username']
	content = data['content']
	timeline_name = data['timeline_name']
	events = data['events']

	user = User.query.filter_by(username=username).first()
	t = TimelinePost(author=user, timeline_name=timeline_name, events=events, background="https://i1.wp.com/regionweek.com/wp-content/uploads/2020/03/World-Map-2.jpg?fit=1920%2C1200&ssl=1")

	db.session.add(t)
	db.session.commit()
	return jsonify({
		'timeline': timeline(user, t)
	})
#----------------------------------------------POST COMPOSER-----------------------------------------------


#------------------------------------------------------GETTERS---------------------------------------------
@app.route('/my_bookmarked', methods=['POST'])
def get_my_blogs_and_timelines():
	data = request.get_json()
	username = data['username']
	b_ids = [x.post_id for x in user.bookmarked_posts]
	bookmarked = []
	for id in b_ids:
		record = BookmarkedPosts.query.filter_by(post_id=id, user=user).first()
		if(record):
			post = getPost(record.post_type, id)
			if(post): 
				if(post.post_type == 'microblog'):
					bookmarked.append(microblog(user, post))
				elif(post.post_type == 'blog'):
					bookmarked.append(blog(user, post))
				elif(post.post_type == 'shareable'):
					bookmarked.append(shareable(user, post))
				elif(post.post_type == 'timeline'):
					bookmarked.append(timeline(user, post))
				elif(post.post_type == 'ResharedWithComment'):
					bookmarked.append(reshareWithComment(user, post))

#------------------------------------------------------GETTERS---------------------------------------------

#-------------------------------------------------POSTACTIONS-----------------------------------------------
@app.route('/likepost', methods=['POST'])
def likemicrobloggerpost():
	data = request.get_json()
	username = data['username']
	post_type = data['post_type']
	post_id = data['post_id']
	user = User.query.filter_by(username=username).first()
	post = getPost(post_type, post_id)
	post.like(user)
	return jsonify({
		'message':'Liked Post' 
	})

@app.route('/unlikepost', methods=['POST'])
def unlikemicrobloggerpost():
	data = request.get_json()
	username = data['username']
	post_type = data['post_type']
	post_id = data['post_id']
	user = User.query.filter_by(username=username).first()
	post = getPost(post_type, post_id)
	post.unlike(user)
	return jsonify({
		'message':'Unliked Post' 
	})

@app.route('/bookmarkpost', methods=['POST'])
def bookmarkpost():
	data = request.get_json()
	username = data['username']
	post_type = data['post_type']
	post_id = data['post_id']
	user = User.query.filter_by(username=username).first()
	post = getPost(post_type, post_id)
	user.add_bookmark(post, post_type)
	return jsonify({
		'message':'Bookmarked Post' 
	})

@app.route('/unbookmarkpost', methods=['POST'])
def unbookmarkpost():
	data = request.get_json()
	username = data['username']
	post_type = data['post_type']
	post_id = data['post_id']
	user = User.query.filter_by(username=username).first()
	post = getPost(post_type, post_id)
	user.remove_bookmark(post)
	return jsonify({
		'message':'UnBookmarked Post' 
	})

@app.route('/reshare', methods=['POST'])
def resharepost():
	data = request.get_json()
	username = data['username']
	host_type = data['host_type']
	host_id = data['host_id']
	content = data['content']
	category = data['category']
	reshare_type = data['reshare_type']
	
	post = getPost(host_type, host_id)
	user = User.query.filter_by(username=username).first()

	if(reshare_type == 'ResharedWithComment'):
		rwc = ReshareWithComment(author=user, host=post, content=content, category=category)
		db.session.add(rwc)
		post.reshare(user=user, post=rwc)
	else:
		sr = SimpleReshare(author=user, host=post)
		db.session.add(sr1)
		post.reshare(user=user, post=sr1)
	return jsonify({
		'message':'Reshared Post' 
	})

@app.route('/unreshare', methods=['POST'])
def unresharepost():
	data = request.get_json()
	username = data['username']
	host_type = data['host_type']
	host_id = data['host_id']
	reshare_type = data['reshare_type'] 

	if(reshare_type == 'ResharedWithComment'):
		rwc = ReshareWithComment.query.filter_by(author=user, host_id=host_id).first()
		post.unreshare(user=user, post=rwc)
	else:
		sr = SimpleReshare.query.filter_by(author=user, host_id=host_id).first()
		post.unreshare(user=user, post=sr1)
	
	return jsonify({
		'message':'Unreshared Post' 
	})

@app.route('/comment', methods=['POST'])
def addcomment():
	data = request.get_json()
	username = data['username']
	post_type = data['post_type']
	post_id = data['post_id']
	content = data['content']
	category = data['category']

	user = User.query.filter_by(username=username).first()
	post = None
	c=None
	if(post_type == 'microblog'):
		post = MicroBlogPost.query.filter_by(post_id=post_id).first()
		c = Comment(author=user, content=content, category=category, microblog_parent=post)
	elif(post_type == 'blog'):
		post = BlogPost.query.filter_by(post_id=post_id).first()
		c = Comment(author=user, content=content, category=category, blog_parent=post)
	elif(post_type == 'timeline'):
		post = TimelinePost.query.filter_by(post_id=post_id).first()
		c = Comment(author=user, content=content, category=category, timeline_parent=post)
	elif(post_type == 'ResharedWithComment'):
		post = ReshareWithComment.query.filter_by(post_id=post_id).first()
		c = Comment(author=user, content=content, category=category, rwc_parent=post)
	
	db.session.add(c1)
	db.session.commit()

@app.route('/deletepost', methods=['POST'])
def deletepost():
	data = request.get_json()
	username = data['username']
	post_type = data['post_type']
	post_id = data['post_id']

	user = User.query.filter_by(username=username).first()
	post = getPost(post_type, post_id)

	if(post.author_id == user.id):
		db.session.delete(post)
		db.session.commit()
	else:
		return jsonify({
			'message':'Cannot delete post as you do not have the rights to do so' 
		})

	return jsonify({
		'message':'Deleted Post!' 
	})

#-------------------------------------------------POSTACTIONS-----------------------------------------------

#--------------------------------------------------EXPLORE--------------------------------------------------

@app.route('/exploremicroblogs')
def exploremicroblogs():
	posts = []
	[posts.append(microblog(x.author, x)) for x in MicroBlogPost.query.all()]
	return jsonify({
		'length': len(posts),
		'posts': posts
	})

@app.route('/exploreblogs')
def exploreblogs():
	posts = []
	[posts.append(blog(x.author, x)) for x in BlogPost.query.all()]
	return jsonify({
		'length': len(posts),
		'posts': posts
	})

@app.route('/exploretimelines')
def exploretimelines():
	posts = []
	[posts.append(timeline(x.author, x)) for x in TimelinePost.query.all()]
	return jsonify({
		'length': len(posts),
		'posts': posts
	})

@app.route('/exploreshareablesandpolls')
def exploreshareablesandpolls():
	posts = []
	[posts.append(shareable(x.author, x)) for x in ShareablePost.query.all()]
	[posts.append(poll(x.author, x)) for x in PollPost.query.all()]
	return jsonify({
		'length': len(posts),
		'posts': posts
	})
#--------------------------------------------------EXPLORE--------------------------------------------------


def getUserData(username):
	user = User.query.filter_by(username=username).first()
	#Get Reshares
	r_ids = [x.reshared_post_id for x in user.reshared_posts]
	reshared = []
	mbandcomments = []
	blogandtimelines = []
	pollsandshareables = []
	for id in r_ids:
		record = ResharedPosts.query.filter_by(reshared_post_id=id).first()
		if(record):
			post = getPost(record.reshare_type, id)
			if(post):
				if(post.post_type == 'SimpleReshare'):
					reshared.append(simpleReshare(user, post))
				elif(post.post_type == 'ReshareWithComment'):
					reshared.append(reshareWithComment(user, post))

	#Get posts
	[mbandcomments.append(microblog(user, x)) for x in user.my_microblogs]
	[mbandcomments.append(comment(user, x)) for x in Comment.query.filter_by(author=user).all()]
	[blogandtimelines.append(blog(user, x)) for x in user.my_blogs]
	[blogandtimelines.append(timeline(user, x)) for x in user.my_timelines]
	[pollsandshareables.append(shareable(user, x)) for x in user.my_shareables]
	[pollsandshareables.append(poll(user, x)) for x in user.my_polls]

	return {
		'mymicroblogsandcomments': mbandcomments,
		'myreshares': reshared,
		'myblogsandtimeline': blogandtimelines,
		'mypollsandshareables': pollsandshareables
	}



def getPost(post_type, post_id):
	post = None
	if(post_type == 'microblog'):
		post = MicroBlogPost.query.filter_by(post_id=post_id).first()
	elif(post_type == 'blog'):
		post = BlogPost.query.filter_by(post_id=post_id).first()
	elif(post_type == 'shareable'):
		post = ShareablePost.query.filter_by(post_id=post_id).first()
	elif(post_type == 'poll'):
		post = PollPost.query.filter_by(post_id=post_id).first()
	elif(post_type == 'timeline'):
		post = TimelinePost.query.filter_by(post_id=post_id).first()
	elif(post_type == 'SimpleReshare'):
		post = SimpleReshare.query.filter_by(post_id=post_id).first()
	elif(post_type == 'ReshareWithComment'):
		post = ReshareWithComment.query.filter_by(post_id=post_id).first()
	elif(post_type == 'comment'):
		post = Comment.query.filter_by(post_type=post_id).first()
	return post

"""
Add getters for my posst!
'my_microblogs' : [microblog(x) for x in user_record.my_microblogs],
'my_blogs' : str(user_record.my_blogs),
'my_timelines' : str(user_record.my_timelines),
'my_shareables' : str(user_record.my_shareables),
'my_reshareWithComments' : str(user_record.my_reshareWithComments),
'my_simpleReshares' : str(user_record.my_simpleReshares),
'my_polls' : str(user_record.my_polls),
'liked_posts': str(user_record.liked_posts), get when post is loaded to indicate sign

'bookmarked_posts': [x.post_id for x in user_record.bookmarked_posts]
'reshared_posts': str(user_record.reshared_posts), get when post is loaded to indicate sign
"""

# @app.route('/addvote', methods=['POST'])
#TODO: IMPLEMEMENT THE SUBMIT VOTE FEATURE
# def addvote():
# 	data = request.get_json()
# 	username = data['username']
# 	p_id = data['poll_id']
# 	selectedvote = int(data['selectedvote'])
	
# 	user = User.query.filter_by(username=username).first()
# 	p = PollPost.query.filter_by(post_id=p_id).first()

# 	x = [y for y in p.options]
# 	p.options = []
# 	db.session.commit()
# 	x[selectedvote]['count']+=1
# 	p.options = x
# 	db.session.commit()

# 	v = VotedPolls(user=user, poll=p, vote=selectedvote)
# 	db.session.add(v)
# 	db.session.commit()

# 	return jsonify({
# 		'message': 'submitted vote',
# 		'votedFor': p.options[selectedvote],
# 		'poll': poll(user, p)
# 	})