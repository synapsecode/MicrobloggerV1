from flask import render_template, url_for, flash, redirect, request, jsonify
from MicroBloggerCore import app, db
from MicroBloggerCore.models import (User, MicroBlogPost, BlogPost, TimelinePost, ShareablePost,
 PollPost, ReshareWithComment, SimpleReshare, Comment, BookmarkedPosts, ResharedPosts)
from post_templates import *
import requests

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


@app.route("/get_news_feed")
def getnews():
	#TODO: Can add a new way to get news
	nx = requests.get('https://newsapi.org/v2/top-headlines?country=in&apiKey=590b8ff1c78d4c0e8088535f3cf54122')
	j = nx.json()
	articles = []
	for e in j['articles']:
		articles.append({
			'source': e['source']['name'],
        	'headline': e['title'],
			"link": e['url'],
			"background": e['urlToImage']
		})
	print(len(articles))
	return jsonify({
		'articles': articles
		})

@app.route("/all_users")
def allusers():
	users = User.query.all()
	return jsonify(
		{
			'length': len(users),
			'code': 'S1',
			'users': [{
				'username': u.username,
				'icon': u.icon
			} for u in users]
		}
	)

@app.route("/profile/<myusername>/<username>")
def getprofile(myusername, username):
	my_user_record = User.query.filter_by(username=myusername).first()
	user_record = User.query.filter_by(username=username).first()
	isFollowing = False
	print(f"{my_user_record} accessed {user_record}")
	if(my_user_record and user_record):
		for i in user_record.my_followers:
			if(i == my_user_record.username):
				isFollowing = True
	if(user_record):
		return jsonify({	
			'code': 'S1',
			'user': userTemplate(user_record),
			'posts': getUserData(username, my_user_record),
			'isFollowing': isFollowing
		})
	else:
		return jsonify({
			'code': 'E2',
			'message': 'Profile does not exist!'
		})

@app.route("/getprofiledetails/<username>")
def getprofiledetails(username):
	user_record = User.query.filter_by(username=username).first()
	if(user_record):
		return jsonify({	
			'user': userTemplate(user_record),
		})

#Follow
@app.route('/follow_profile', methods=['POST'])
def follow_profile():
	data = request.get_json()
	username = data['username']
	following_username = data['following_username']
	myuser = User.query.filter_by(username=username).first()
	following_user = User.query.filter_by(username=following_username).first()
	myuser.followed.append(following_user)
	db.session.commit()
	return jsonify({
		'message' : 'Started Following!'
	})

#Unfollow
@app.route('/unfollow_profile', methods=['POST'])
def unfollow_profile():
	data = request.get_json()
	username = data['username']
	following_username = data['following_username']
	myuser = User.query.filter_by(username=username).first()
	following_user = User.query.filter_by(username=following_username).first()
	myuser.followed.remove(following_user)
	db.session.commit()
	return jsonify({
		'message' : 'Stopped Following!'
	})

@app.route('/editprofile', methods=['POST'])
def editprofile():
	data = request.get_json()
	username = data['username']
	#background -> image
	#icon -> image
	email = data['email'] if('email' in data) else None
	location = data['location'] if('location' in data)else None
	bio = data['bio'] if('bio' in data) else None
	name = data['name'] if('name' in data) else None
	#website = data['website'] if('website' in data) else None

	user = User.query.filter_by(username=username).first()
	user.bio = bio if bio else user.bio
	user.name = name if name else user.name
	user.email = email if email else user.email
	user.location = location if location else user.location
	#user.website = website if website else user.website

	db.session.commit()

	return jsonify({
		'profile': userTemplate(user)
	})
	
@app.route('/feed', methods=['POST'])
def feed():
	#TODO: Make it more efficient!! URGENT!!!!
	data = request.get_json()
	username = data['username']
	print(f"username: {username}")
	myuser = User.query.filter_by(username=username).first()
	if(myuser):
		feed = []
		following = myuser.my_following
		for u in [myuser.username, *following]:
			ux = User.query.filter_by(username=u).first()
			[feed.append(microblog(myuser, x)) for x in MicroBlogPost.query.filter_by(author_id=ux.id).all()]
			[feed.append(blog_skin(myuser, x)) for x in BlogPost.query.filter_by(author_id=ux.id).all()]
			[feed.append(shareable(myuser, x)) for x in ShareablePost.query.filter_by(author_id=ux.id).all()]
			[feed.append(poll(myuser, x)) for x in PollPost.query.filter_by(author_id=ux.id).all()]
			[feed.append(timeline_skin(myuser, x)) for x in TimelinePost.query.filter_by(author_id=ux.id).all()]
			[feed.append(reshareWithComment(myuser, x)) for x in ReshareWithComment.query.filter_by(author_id=ux.id).all()]
			[feed.append(simpleReshare(myuser, x)) for x in SimpleReshare.query.filter_by(author_id=ux.id).all()]
		
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
		'message': 'created microblog',
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
		'message': 'created blog',
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
		'message': 'created shareable',
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
		'message': 'created poll',
	})

@app.route('/createtimeline', methods=['POST'])
def create_timeline():
	data = request.get_json()
	username = data['username']
	timeline_name = data['timeline_name']
	events = data['events']

	user = User.query.filter_by(username=username).first()
	t = TimelinePost(author=user, timeline_name=timeline_name, events=events, background="https://i1.wp.com/regionweek.com/wp-content/uploads/2020/03/World-Map-2.jpg?fit=1920%2C1200&ssl=1")

	db.session.add(t)
	db.session.commit()
	return jsonify({
		'message': 'created timeline',
	})
#----------------------------------------------POST COMPOSER-----------------------------------------------


#------------------------------------------------------GETTERS---------------------------------------------
@app.route('/my_bookmarked', methods=['POST'])
def get_my_blogs_and_timelines():
	data = request.get_json()
	username = data['username']
	user = User.query.filter_by(username=username).first()
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
					bookmarked.append(blog_skin(user, post))
				elif(post.post_type == 'shareable'):
					bookmarked.append(shareable(user, post))
				elif(post.post_type == 'timeline'):
					bookmarked.append(timeline_skin(user, post))
				elif(post.post_type == 'ResharedWithComment'):
					bookmarked.append(reshareWithComment(user, post))

	return jsonify({
		'length': len(bookmarked),
		'bookmarked_posts': bookmarked
	})

@app.route('/getpostcomments', methods=['POST'])
def getpostcomments():
	data = request.get_json()
	username = data['username']
	post_id = data['post_id']
	post_type = data['post_type']
	user = User.query.filter_by(username=username).first()
	post = getPost(post_type, post_id)
	return jsonify({
			'comments': get_comments_from_post(user, post)
		})

@app.route('/getspecificpost', methods=['POST'])
def getspecificmicroblog():
	data = request.get_json()
	username = data['username']
	post_id = data['post_id']
	post_type = data['post_type']
	user = User.query.filter_by(username=username).first()
	post = getPost(post_type, post_id)
	p = None
	print(post_type, post_id, post)
	if(post_type == 'microblog'):
		p = microblog(user, post)
	elif(post_type == 'blog'):
		p = blog(user, post)
	elif(post_type == 'timeline'):
		p = timeline(user, post)
	elif(post_type == 'ResharedWithComment'):
		p = reshareWithComment(user, post)
	return jsonify({
			'post': p
		})

@app.route('/getblogbody', methods=['POST'])
def getblogbody():
	data = request.get_json()
	username = data['username']
	post_id = data['post_id']
	user = User.query.filter_by(username=username).first()
	post = getPost('blog', post_id)
	return jsonify({
		'blog': blog_body(user, post)
	})

@app.route('/gettimelinebody', methods=['POST'])
def gettimelinebody():
	data = request.get_json()
	username = data['username']
	post_id = data['post_id']
	user = User.query.filter_by(username=username).first()
	post = getPost('timeline', post_id)
	return jsonify({
		'timeline': timeline_body(user, post)
	})
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
	print(f"{user} liked post: {post}")
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
	print(f"{user} unliked post: {post}")
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
		print(f"{user} reshared post: {post} => {rwc}")
	else:
		sr = SimpleReshare(author=user, host=post)
		db.session.add(sr)
		post.reshare(user=user, post=sr)
		print(f"{user} reshared post: {post} => {sr}")
	return jsonify({
		'message':'Reshared Post' 
	})

@app.route('/unreshare', methods=['POST'])
def unresharepost():
	data = request.get_json()
	username = data['username']
	host_type = data['host_type']
	host_id = data['host_id']
	user = User.query.filter_by(username=username).first()
	post = getPost(host_type, host_id)
	allreshares = [*ReshareWithComment.query.all(), *SimpleReshare.query.all()]
	for i in allreshares:
		if(host_id == i.host_id):
			if(i.post_type == "ResharedWithComment"):
				rwc = ReshareWithComment.query.filter_by(author=user, host_id=host_id).first()
				post.unreshare(user=user, post=rwc)
				for c in rwc.comments:
					db.session.delete(c)
				db.session.commit()
				db.session.delete(rwc)
				db.session.commit()
				print(f"{user} unreshared post: {post} => {rwc}")
			elif(i.post_type == "SimpleReshare"):
				sr = SimpleReshare.query.filter_by(author=user, host_id=host_id).first()
				post.unreshare(user=user, post=sr)
				db.session.delete(sr)
				db.session.commit()
				print(f"{user} unreshared post: {post} => {sr}")
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
	
	db.session.add(c)
	db.session.commit()
	print(f"{user} commented on post: {post} => {c}")
	return jsonify({
		'message': 'comment added',
	})

@app.route('/deletecomment', methods=['POST'])
def deletecomment():
	data = request.get_json()
	username = data['username']
	c_id = data['comment_id']

	user = User.query.filter_by(username=username).first()
	comment = getPost('comment', c_id)

	if(comment.author_id == user.id):
		db.session.delete(comment)
		db.session.commit()
	else:
		return jsonify({
			'message':'Cannot delete comment as you do not have the rights to do so' 
		})
	print(f"{user} deleted commented on post: {post} => {comment}")
	return jsonify({
		'message':'Deleted Comment!' 
	})

@app.route('/deletepost', methods=['POST'])
def deletepost():
	data = request.get_json()
	username = data['username']
	post_type = data['post_type']
	post_id = data['post_id']

	user = User.query.filter_by(username=username).first()
	post = getPost(post_type, post_id)

	if(post.author.id == user.id):
		if(post_type != "poll" and post_type != "shareable"):
			for c in post.comments:
				db.session.delete(c)
			db.session.commit()
		db.session.delete(post)
		db.session.commit()
	else:
		return jsonify({
			'message':'Cannot delete post as you do not have the rights to do so' 
		})
	print(f"{user} deleted post: {post}")
	return jsonify({
		'message':'Deleted Post!' 
	})

@app.route('/submitvote', methods=['POST'])
def submit_vote():
	data = request.get_json()
	username = data['username']
	poll_id = data['poll_id']
	selected = int(data['selected'])

	user = User.query.filter_by(username=username).first()

	#Add to Voted
	vx = [x for x in user.voted_polls]
	user.voted_polls = []
	db.session.commit()
	user.voted_polls = [{
		'poll_id': poll_id,
		'selected': selected
	}, *vx]
	db.session.commit()

	#Increment vote count
	p = PollPost.query.filter_by(post_id=poll_id).first()

	px = [x for x in p.options]
	p.options = []
	db.session.commit()
	px[selected]['count']+=1
	p.options = [x for x in px]
	db.session.commit()

	return jsonify({
		'myvoted': user.voted_polls,
		'options': p.options
	})

	#Vote

#-------------------------------------------------POSTACTIONS-----------------------------------------------

#--------------------------------------------------EXPLORE--------------------------------------------------

@app.route('/exploremicroblogs/<username>')
def exploremicroblogs(username):
	posts = []
	[posts.append(microblog(x.author, x)) for x in MicroBlogPost.query.all()]
	[posts.append(reshareWithComment(x.author, x)) for x in ReshareWithComment.query.all()]
	return jsonify({
		'length': len(posts),
		'posts': posts
	})

@app.route('/exploreblogs/<username>')
def exploreblogs(username):
	user = User.query.filter_by(username=username).first()
	posts = []
	[posts.append(blog_skin(user, x)) for x in BlogPost.query.all()]
	return jsonify({
		'length': len(posts),
		'posts': posts
	})

@app.route('/exploretimelines/<username>')
def exploretimelines(username):
	user = User.query.filter_by(username=username).first()
	posts = []
	[posts.append(timeline_skin(user, x)) for x in TimelinePost.query.all()]
	return jsonify({
		'length': len(posts),
		'posts': posts
	})

@app.route('/exploreshareablesandpolls/<username>')
def exploreshareablesandpolls(username):
	user = User.query.filter_by(username=username).first()
	posts = []
	[posts.append(shareable(user, x)) for x in ShareablePost.query.all()]
	[posts.append(poll(user, x)) for x in PollPost.query.all()]
	return jsonify({
		'length': len(posts),
		'posts': posts
	})
#--------------------------------------------------EXPLORE--------------------------------------------------

def getUserData(username, currentuser):
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
				elif(post.post_type == 'ResharedWithComment'):
					reshared.append(reshareWithComment(user, post))

	#Get posts
	[mbandcomments.append(microblog(user, x)) for x in user.my_microblogs]
	[mbandcomments.append(comment(user, x)) for x in Comment.query.filter_by(author=user).all()]
	[blogandtimelines.append(blog_skin(user, x)) for x in user.my_blogs]
	[blogandtimelines.append(timeline_skin(user, x)) for x in user.my_timelines]
	[pollsandshareables.append(shareable(user, x)) for x in user.my_shareables]
	[pollsandshareables.append(poll(currentuser, x)) for x in user.my_polls]

	return {
		'mymicroblogsandcomments': mbandcomments,
		'myreshares': reshared,
		'myblogsandtimelines': blogandtimelines,
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
	elif(post_type == 'ResharedWithComment'):
		post = ReshareWithComment.query.filter_by(post_id=post_id).first()
	elif(post_type == 'comment'):
		post = Comment.query.filter_by(comment_id=post_id).first()
	return post

def delete_all_comments_in_post(post_id):
	post = None