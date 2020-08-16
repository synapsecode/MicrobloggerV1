from flask import render_template, url_for, flash, redirect, request, jsonify
from MicroBloggerCore import app, db
from MicroBloggerCore.models import (User, MicroBlogPost, BlogPost, TimelinePost, ShareablePost,
 PollPost, ReshareWithComment, SimpleReshare, Comment, BookmarkedPosts, ResharedPosts, ReportedBugs, CarouselPost)
from post_templates import *
import requests
from MicroBloggerCore.fileuploader import upload_file_to_cloud
import io

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
		addPoint('LOGIN', user_record)
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
	addPoint('REGISTER', new_user)
	return jsonify({
		'code': 'S1',
		'user': userTemplate(user_record)
	})

@app.route('/reportbug', methods=['POST'])
def report_bug():
	data = request.get_json()
	username = data['username']
	desc = data['description']
	rep = ReportedBugs(username=username, desc=desc)
	db.session.add(rep)
	db.session.commit()
	print("New Bug Registered: ", rep)
	return jsonify({
		'message': 'The Bug Has been registered! Thank You'
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
	if(my_user_record.username != user_record.username):
		addPoint('V_PROFILE', my_user_record)
	if(user_record):
		return jsonify({	
			'code': 'S1',
			'posts': getUserData(username, my_user_record),
			'user': userTemplate(user_record),
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
	addPoint('FOLLOW', myuser)
	addPoint('FOLLOWED', following_user)
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
	addPoint('UNFOLLOW', myuser)
	addPoint('UNFOLLOWED', following_user)
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
	website = data['website'] if('website' in data) else None
	user = User.query.filter_by(username=username).first()
	user.bio = bio if bio else user.bio
	user.name = name if name else user.name
	user.email = email if email else user.email
	user.location = location if location else user.location
	user.website = website if website else user.website

	db.session.commit()
	addPoint('EDITPROFILE', user)
	return jsonify({
		'profile': userTemplate(user)
	})
	
@app.route('/updatedisplaypicture/<username>', methods=['POST'])
def updatedisplaypicture(username):
	username = username
	dpObj = request.files['picture']
	print(dpObj)
	user = User.query.filter_by(username=username).first()
	dpBytes = io.BytesIO(dpObj.read())
	uploaded_img = upload_file_to_cloud(dpBytes)
	if(uploaded_img['STATUS'] == 'OK'):
		user.icon = uploaded_img['URI']
	db.session.commit()
	addPoint('EDITPROFILE', user)
	return jsonify({
		'status': 'OK',
		'link': str(user.icon)
	})

@app.route('/updatebackground/<username>', methods=['POST'])
def updatebackground(username):
	username = username
	bgObj = request.files['picture']
	print(bgObj)
	user = User.query.filter_by(username=username).first()
	bgBytes = io.BytesIO(bgObj.read())
	uploaded_img = upload_file_to_cloud(bgBytes)
	if(uploaded_img['STATUS'] == 'OK'):
		user.background = uploaded_img['URI']
	db.session.commit()
	addPoint('EDITPROFILE', user)
	return jsonify({
		'status': 'OK',
		'link': str(user.icon)
	})

@app.route('/uploadcover', methods=['POST'])
def uploadcover():
	coverImg = request.files['picture']
	cBytes = io.BytesIO(coverImg.read())
	uploaded_img = upload_file_to_cloud(cBytes)
	if(uploaded_img['STATUS'] == 'OK'):
		return jsonify({
			'link': str(uploaded_img['URI'])
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
			[feed.append(carousel(myuser, x)) for x in CarouselPost.query.filter_by(author_id=ux.id).all()]
		
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
	addPoint('MICROBLOG', user)
	return jsonify({
		'message': 'created microblog',
	})

@app.route('/createblog', methods=['POST'])
def create_blog():
	data = request.get_json()
	username = data['username']
	content = data['content']
	blog_name = data['blog_name']
	cover = data['cover']

	user = User.query.filter_by(username=username).first()
	xb = BlogPost(author=user, blog_name=blog_name, content=content, background=cover)

	db.session.add(xb)	
	db.session.commit()
	addPoint('BLOG', user)
	return jsonify({
		'message': 'created blog',
	})

@app.route('/createcarousel', methods=['POST'])
def create_carousel():
	data = request.get_json()
	username = data['username']
	content = data['content']
	images = data['images']
	user = User.query.filter_by(username=username).first()
	cx = CarouselPost(author=user, content=content)
	db.session.add(cx)
	db.session.commit()
	#Adding Images
	cx.images = []
	db.session.commit()
	cx.images = [*[i for i in images]]
	db.session.commit()
	addPoint('CAROUSEL', user)
	return jsonify({
		'message': 'created carousel',
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
	addPoint('SHAREABLE', user)
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
	addPoint('POLL', user)
	return jsonify({
		'message': 'created poll',
	})

@app.route('/createtimeline', methods=['POST'])
def create_timeline():
	data = request.get_json()
	username = data['username']
	timeline_name = data['timeline_name']
	events = data['events']
	cover = data['cover']

	user = User.query.filter_by(username=username).first()
	t = TimelinePost(author=user, timeline_name=timeline_name, events=events, background=cover)

	db.session.add(t)
	db.session.commit()
	addPoint('TIMELINE', user)
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
				elif(post.post_type == 'carousel'):
					bookmarked.append(carousel(user, post))

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
	elif(post_type == 'carousel'):
		p = carousel(user, post)
	addPoint('OPENP', user)
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
	addPoint('OPENB', user)
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
	addPoint('OPENT', user)
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
	addPoint('LIKE', user)
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
	addPoint('UNLIKE', user)
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
	addPoint('BOOKMARK', user)
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
	addPoint('UNBOOKMARK', user)
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
	addPoint('RESHARE', user)
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
	addPoint('UNRESHARE', user)	
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
	elif(post_type == 'carousel'):
		post = CarouselPost.query.filter_by(post_id=post_id).first()
		c = Comment(author=user, content=content, category=category, carousel_parent=post)

	db.session.add(c)
	db.session.commit()
	print(f"{user} commented on post: {post} => {c}")
	addPoint('COMMENT', user)
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
		addPoint('DELETECOMMENT', user)
	else:
		return jsonify({
			'message':'Cannot delete comment as you do not have the rights to do so' 
		})
	print(f"{user} deleted comment:  {comment}")
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
			#Delete Comments of Post
			for c in post.comments:
				db.session.delete(c)
			db.session.commit()
		db.session.delete(post)
		db.session.commit()
		addPoint('DELETEPOST', user)
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

	addPoint('VOTE', user)

	return jsonify({
		'myvoted': user.voted_polls,
		'options': p.options
	})

	#Vote

#-------------------------------------------------POSTACTIONS-----------------------------------------------

#-----------------------------------------------EDIT POSTS------------------------------------------------------
@app.route('/editmicroblog', methods=['POST'])
def editmicroblog(username):
	data = request.get_json()
	username = data['username']
	post_id = data['post_id']
	pass

@app.route('/editrwc', methods=['POST'])
def edit_rwc(username):
	data = request.get_json()
	username = data['username']
	post_id = data['post_id']
	pass

@app.route('/editblog', methods=['POST'])
def editblog(username):
	data = request.get_json()
	username = data['username']
	post_id = data['post_id']
	pass

@app.route('/edittimeline', methods=['POST'])
def edit_timeline(username):
	data = request.get_json()
	username = data['username']
	post_id = data['post_id']
	pass

@app.route('/editshareable', methods=['POST'])
def editshareable(username):
	data = request.get_json()
	username = data['username']
	post_id = data['post_id']
	pass

#-----------------------------------------------EDIT POSTS------------------------------------------------------
#--------------------------------------------------EXPLORE--------------------------------------------------

@app.route('/exploremicroblogs/<username>')
def exploremicroblogs(username):
	user = User.query.filter_by(username=username).first()
	addPoint('EXPLORE', user)
	posts = []
	[posts.append(microblog(user, x)) for x in MicroBlogPost.query.all()]
	[posts.append(reshareWithComment(user, x)) for x in ReshareWithComment.query.all()]
	return jsonify({
		'length': len(posts),
		'posts': posts
	})

@app.route('/exploreblogsandcarousels/<username>')
def exploreblogsandcarousels(username):
	user = User.query.filter_by(username=username).first()
	addPoint('EXPLORE', user)
	posts = []
	[posts.append(blog_skin(user, x)) for x in BlogPost.query.all()]
	[posts.append(carousel(user, x)) for x in CarouselPost.query.all()]
	return jsonify({
		'length': len(posts),
		'posts': posts
	})

@app.route('/exploretimelines/<username>')
def exploretimelines(username):
	user = User.query.filter_by(username=username).first()
	addPoint('EXPLORE', user)
	posts = []
	[posts.append(timeline_skin(user, x)) for x in TimelinePost.query.all()]
	return jsonify({
		'length': len(posts),
		'posts': posts
	})

@app.route('/exploreshareablesandpolls/<username>')
def exploreshareablesandpolls(username):
	user = User.query.filter_by(username=username).first()
	addPoint('EXPLORE', user)
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
	microblogsandcomments = []
	blogstimelinesandcarousels = []
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
	[microblogsandcomments.append(microblog(user, x)) for x in MicroBlogPost.query.filter_by(author=user).order_by(MicroBlogPost.id.desc())]
	[microblogsandcomments.append(comment(user, x)) for x in Comment.query.filter_by(author=user).order_by(Comment.id.desc())]
	[blogstimelinesandcarousels.append(blog_skin(user, x)) for x in BlogPost.query.filter_by(author=user).order_by(BlogPost.id.desc())]
	[blogstimelinesandcarousels.append(carousel(user, x)) for x in CarouselPost.query.filter_by(author=user).order_by(CarouselPost.id.desc())]
	[blogstimelinesandcarousels.append(timeline_skin(user, x)) for x in TimelinePost.query.filter_by(author=user).order_by(TimelinePost.id.desc())]
	[pollsandshareables.append(shareable(user, x)) for x in ShareablePost.query.filter_by(author=user).order_by(ShareablePost.id.desc())]
	[pollsandshareables.append(poll(currentuser, x)) for x in PollPost.query.filter_by(author=user).order_by(PollPost.id.desc())]

	n = (len(microblogsandcomments)+len(blogstimelinesandcarousels)+len(reshared)+len(pollsandshareables))
	r = len(reshared)
	l = 0
	c = 0
	f = len(user.followed.all())
	nf = len(user.followers.all())
	for p in [*microblogsandcomments, *reshared, *blogstimelinesandcarousels, *pollsandshareables]:
		if('isLiked' in p):
			if(p['isLiked']):
				l+=1
		if('comments' in p):
			c = p['comments']
	calculate_base_points(n, l, c, r, f, nf, user)

	return {
		'mymicroblogsandcomments': microblogsandcomments,
		'myreshares': reshared,
		'myblogstimelinesandcarousels': blogstimelinesandcarousels,
		'mypollsandshareables': pollsandshareables,
	}

def getPost(post_type, post_id):
	post = None
	if(post_type == 'microblog'):
		post = MicroBlogPost.query.filter_by(post_id=post_id).first()
	elif(post_type == 'blog'):
		post = BlogPost.query.filter_by(post_id=post_id).first()
	elif(post_type == 'carousel'):
		post = CarouselPost.query.filter_by(post_id=post_id).first()
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

# def delete_all_comments_in_post(post_id):
# 	post = None

def calculate_base_points(n, l, c, r, f, nf, user):
	if(n!=0 and nf!=0 and f!=0):
		basescore = ( l*((1/n) + (1/nf)) + c*((1/n) + (1/nf)) + r*((1/n) + (1/nf)) + (nf/f))
		user.basepoints = f"{basescore}"
		db.session.commit()
		print(n, l, c, r, f, nf, user, basescore, user.secondarypoints)
		user.reputation = f"{float(user.basepoints) + float(user.secondarypoints)}"
		db.session.commit()
	else:
		user.basepoints = '0.0'
		user.reputation = user.secondarypoints
		db.session.commit()

def addPoint(cmd, user):
	point = 0
	if(cmd == 'LIKE' or cmd == 'BOOKMARK'):
		point = 0.05
	elif(cmd == 'VOTE' or cmd == 'V_NEWS' or cmd == 'V_PROFILE' or cmd=='OPENT' or cmd=='OPENP' or cmd=='EXPLORE' or cmd=='SEARCHUSER'):
		point = 0.05
	elif(cmd == 'SR' or cmd == 'V_SHAREABLE' or cmd=='OPENB'):
		point = 0.1
	elif(cmd == 'COMMENT'):
		point = 0.15
	elif(cmd == 'SHAREABLE' or cmd=='PERMINUTEUSAGEPOINT'):
		point = 0.18
	elif(cmd == 'POLL'):
		point = 0.2
	elif(cmd == 'MICROBLOG'):
		point = 0.55
	elif(cmd == 'RWC'):
		point = 0.75
	elif(cmd == 'DAILY_LOGIN' or cmd=='TIMELINE' or cmd=='FOLLOW' or cmd == 'FOLLOWED'):
		point = 0.5
	elif(cmd == 'BLOG'):
		point = 1
	elif(cmd == 'CAROUSEL'):
		point = 1.5
	elif(cmd == 'LOGOUT'):
		point = -0.06
	elif(cmd == 'LOGIN'):
		point = +0.2
	elif(cmd == 'REGISTER'):
		point = 2
	elif(cmd == 'UNRESHARE'):
		point = -0.8
	elif(cmd == 'DELETEPOST' or cmd=='DELETECOMMENT'):
		point = -1
	elif(cmd == 'UNFOLLOW'):
		point = -1.3
	elif(cmd == 'UNFOLLOWED'):
		point = -1.3
	elif(cmd == 'EDITPROFILE'):
		point = +0.25
	elif(cmd == 'UNLIKE' or cmd == 'UNBOOKMARK'):
		point = -0.08
	
	user.secondarypoints = f"{float(user.secondarypoints) + float(point)}"
	user.reputation = f"{float(user.basepoints) + float(user.secondarypoints)}"
	db.session.commit()
