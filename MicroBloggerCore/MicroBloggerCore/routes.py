from flask import render_template, url_for, flash, redirect, request, jsonify
from MicroBloggerCore import app, db
from MicroBloggerCore.models import (User, MicroBlogPost, BlogPost, TimelinePost, ShareablePost, PollPost, ReshareWithComment, SimpleReshare)
from post_templates import microblog, blog, timeline, poll, shareable, reshareWithComment, simpleReshare, userTemplate

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
			'user': userTemplate(user_record)
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