from flask import render_template, url_for, flash, redirect, request, jsonify
from MicroBloggerCore import app, db
from MicroBloggerCore.models import Users

@app.route("/")
def homepage():
	return "Welcome to the microblogger API"

@app.route("/login", methods=['POST'])
def loginpage():
	data = request.get_json()
	username = data['username']
	password = data['password']
	user_record = Users.query.filter_by(username=username, password=password).first()
	if(user_record):
		return jsonify({
			'code': 'S1',
			'user': {
				'name': str(user_record.name),
				'email': str(user_record.email),
				'username': str(user_record.username),
				'user_id': str(user_record.user_id),
				'icon': str(user_record.icon),
				'background': str(user_record.background),
				'reputation': str(user_record.reputation),
				'followers' : str(len(user_record.followers)), #send only number of followers
				'following' : str(len(user_record.following)),
				'account_age' : str(user_record.account_age),
				'bio' : str(user_record.bio),
				'location' : str(user_record.location),
				'my_microblogs' : str(user_record.my_microblogs),
				'my_blogs' : str(user_record.my_blogs),
				'my_timelines' : str(user_record.my_timelines),
				'my_shareables' : str(user_record.my_shareables),
				'my_reshareWithComments' : str(user_record.my_reshareWithComments),
				'my_simpleReshares' : str(user_record.my_simpleReshares),
				'my_polls' : str(user_record.my_polls),
			}
		})
	else:
		return jsonify({
			'code': 'C1'
		})

@app.route("/register", methods=['POST'])
def registerpage():
	data = request.get_json()
	username = data['username']
	password = data['password']
	email = data['email']
	new_user = Users(username=username, email=email, password=password)
	db.session.add(new_user)
	db.session.commit()
	user_record = Users.query.filter_by(username=username, password=password).first()
	print(user_record)
	return jsonify({
			'code': 'S1',
			'user': {
				'name': str(user_record.name),
				'email': str(user_record.email),
				'username': str(user_record.username),
				'user_id': str(user_record.user_id),
				'icon': str(user_record.icon),
				'background': str(user_record.background),
				'reputation': str(user_record.reputation),
				'followers' : str(len(user_record.followers)), #send only number of followers
				'following' : str(len(user_record.following)),
				'account_age' : str(user_record.account_age),
				'bio' : str(user_record.bio),
				'location' : str(user_record.location),
				'my_microblogs' : str(user_record.my_microblogs),
				'my_blogs' : str(user_record.my_blogs),
				'my_timelines' : str(user_record.my_timelines),
				'my_shareables' : str(user_record.my_shareables),
				'my_reshareWithComments' : str(user_record.my_reshareWithComments),
				'my_simpleReshares' : str(user_record.my_simpleReshares),
				'my_polls' : str(user_record.my_polls),
			}
		})

@app.route("/getprofile/<username>")
def get_specific_profile(username):
	user_record = Users.query.filter_by(username=username).first()
	if(user_record):
		return jsonify({
			'code': 'S1',
			'user': {
				'name': str(user_record.name),
				'email': str(user_record.email),
				'username': str(user_record.username),
				'user_id': str(user_record.user_id),
				'icon': str(user_record.icon),
				'background': str(user_record.background),
				'reputation': str(user_record.reputation),
				'followers' : str(len(user_record.followers)), #send only number of followers
				'following' : str(len(user_record.following)),
				'account_age' : str(user_record.account_age),
				'bio' : str(user_record.bio),
				'location' : str(user_record.location),
				'my_microblogs' : str(user_record.my_microblogs),
				'my_blogs' : str(user_record.my_blogs),
				'my_timelines' : str(user_record.my_timelines),
				'my_shareables' : str(user_record.my_shareables),
				'my_reshareWithComments' : str(user_record.my_reshareWithComments),
				'my_simpleReshares' : str(user_record.my_simpleReshares),
				'my_polls' : str(user_record.my_polls),
			}
		})
	else:
		return jsonify({
			'code': 'C1'
		})
	return f"Getting Profile of {username}"