from MicroBloggerCore import db
from datetime import datetime, date
import uuid
from sqlalchemy.ext.hybrid import hybrid_property
from helperfunctions import calculate_post_age

followers = db.Table('followers',
    db.Column('follower_id', db.Integer, db.ForeignKey('user.id')),
    db.Column('followed_id', db.Integer, db.ForeignKey('user.id'))
)

class User(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	user_id = db.Column(db.String)
	username = db.Column(db.String)
	password = db.Column(db.String)
	name = db.Column(db.String)
	email = db.Column(db.String)
	website = db.Column(db.String)
	icon = db.Column(db.String)
	background = db.Column(db.String)
	reputation = db.Column(db.String)
	basepoints = db.Column(db.String)
	secondarypoints = db.Column(db.String)
	#This controlls the follow logic
	followed = db.relationship(
		'User', secondary=followers,
		primaryjoin=(followers.c.follower_id == id),
		secondaryjoin=(followers.c.followed_id == id),
		backref=db.backref('followers', lazy='dynamic'), lazy='dynamic')
	created_on = db.Column(db.String)
	bio = db.Column(db.String)
	location = db.Column(db.String)
	my_microblogs = db.relationship('MicroBlogPost', backref='author')
	my_blogs = db.relationship('BlogPost', backref='author')
	my_timelines = db.relationship('TimelinePost', backref='author')
	my_shareables = db.relationship('ShareablePost', backref='author')
	my_reshareWithComments = db.relationship('ReshareWithComment', backref='author')
	my_simpleReshares = db.relationship('SimpleReshare', backref='author')
	my_polls = db.relationship('PollPost', backref='author')
	my_comments = db.relationship('Comment', backref='author')
	liked_posts = db.relationship('LikedPosts', backref='user')
	reshared_posts = db.relationship('ResharedPosts', backref='user')
	bookmarked_posts = db.relationship('BookmarkedPosts', backref='user')
	voted_polls = db.Column(db.PickleType(comparator=lambda *a: False))

	#Constructor
	def __init__(self, username, email, password):
		self.username = username
		self.password = password
		self.user_id = str(uuid.uuid4())
		self.email = email
		self.icon = 'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
		self.background = 'https://cdn.vox-cdn.com/thumbor/eHhAQHDvAi3sjMeylWgzqnqJP2w=/0x0:1800x1200/1200x0/filters:focal(0x0:1800x1200):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/13272825/The_Verge_Hysteresis_Wallpaper_Small.0.jpg'
		self.reputation = '0'
		self.followers = []
		self.following = []
		self.created_on = str(datetime.today().strftime("%b %d, %Y %H:%M:%S"))
		self.bio = ''
		self.location = 'Unspecified Location'
		self.voted_polls = []
		self.website = ''
		self.basepoints = '0'
		self.secondarypoints = '0'

	@hybrid_property
	def my_following(self):
		return [x.username for x in self.followed.all()]

	@hybrid_property
	def my_followers(self):
		return [x.username for x in self.followers.all()]

	#--------------------------------Follow other users logic-----------------------
	def follow(self, user):
		if not self.is_following(user):
			self.followed.append(user)
			
	def unfollow(self, user):
		if self.is_following(user):
			self.followed.remove(user)

	def is_following(self, user):
		return self.followed.filter(
		followers.c.followed_id == user.id).count() > 0
	#--------------------------------Follow other users logic-----------------------

	def add_bookmark(self, post, posttype):
		obj = BookmarkedPosts(user=self, post=post, post_type=posttype)
		db.session.add(obj)
		db.session.commit()

	def remove_bookmark(self, post):
		obj = BookmarkedPosts.query.filter_by(user=self, post_id=post.post_id).first()
		if(obj): 
			db.session.delete(obj)
			db.session.commit()

	def __repr__(self):
		return f"MicroBloggerUser({self.username})"


class MicroBlogPost(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	post_type = db.Column(db.String)
	post_id = db.Column(db.String)
	author_id = db.Column(db.Integer, db.ForeignKey('user.id'))
	comments = db.relationship('Comment', backref='microblog_parent')
	content = db.Column(db.String)
	created_on = db.Column(db.String)
	category = db.Column(db.String)

	#Constructor
	def __init__(self, content, category, author):
		self.post_type = 'microblog'
		self.post_id = str(uuid.uuid4())
		self.content = content
		self.category = category
		self.author = author
		self.created_on = str(datetime.today().strftime("%b %d, %Y %H:%M:%S"))

	@hybrid_property
	def likes(self):
		lx = LikedPosts.query.filter_by(post_id=self.post_id).all()
		return [x for x in lx]

	@hybrid_property
	def reshares(self):
		rx = ResharedPosts.query.filter_by(og_post_id=self.post_id).all()
		return [x for x in rx]

	def like(self, user):
		obj = LikedPosts(user=user, post=self)
		db.session.add(obj)
		db.session.commit()

	def unlike(self, user):
		obj = LikedPosts.query.filter_by(user=user, post_id=self.post_id).first()
		if(obj): 
			db.session.delete(obj)
			db.session.commit()

	def reshare(self, user, post):
		obj = ResharedPosts(user=user, host=self, post=post)
		db.session.add(obj)
		db.session.commit()

	def unreshare(self, user, post):
		obj = ResharedPosts.query.filter_by(user=user, og_post_id=self.post_id, reshared_post_id=post.post_id).first()
		if(obj): 
			db.session.delete(obj)
			db.session.commit()
	
	def __repr__(self):
		return f"MicroBlogPost({self.post_id})"
	
class BlogPost(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	post_type = db.Column(db.String)
	post_id = db.Column(db.String)
	background = db.Column(db.String)
	blog_name = db.Column(db.String)
	author_id = db.Column(db.Integer, db.ForeignKey('user.id'))
	comments = db.relationship('Comment', backref='blog_parent')
	content = db.Column(db.String)
	created_on = db.Column(db.String)

	#Constructor
	def __init__(self, author, blog_name, content, background):
		self.post_type = 'blog'
		self.post_id = str(uuid.uuid4())
		self.blog_name = blog_name
		self.content = content
		self.background = background
		self.author = author
		self.created_on = str(datetime.today().strftime("%b %d, %Y %H:%M:%S"))

	@hybrid_property
	def likes(self):
		lx = LikedPosts.query.filter_by(post_id=self.post_id).all()
		return [x for x in lx]

	@hybrid_property
	def reshares(self):
		rx = ResharedPosts.query.filter_by(og_post_id=self.post_id).all()
		return [x for x in rx]

	def like(self, user):
		obj = LikedPosts(user=user, post=self)
		db.session.add(obj)
		db.session.commit()

	def unlike(self, user):
		obj = LikedPosts.query.filter_by(user=user, post_id=self.post_id).first()
		if(obj): 
			db.session.delete(obj)
			db.session.commit()

	def reshare(self, user, post):
		obj = ResharedPosts(user=user, host=self, post=post)
		db.session.add(obj)
		db.session.commit()

	def unreshare(self, user, post):
		obj = ResharedPosts.query.filter_by(user=user, og_post_id=self.post_id, reshared_post_id=post.post_id).first()
		if(obj): 
			db.session.delete(obj)
			db.session.commit()

	def __repr__(self):
		return f"BlogPost({self.blog_name})"

class PollPost(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	post_type = db.Column(db.String)
	post_id = db.Column(db.String)
	author_id = db.Column(db.Integer, db.ForeignKey('user.id'))
	content = db.Column(db.String)
	options = db.Column(db.PickleType(comparator=lambda *a: False))
	created_on = db.Column(db.String)

	#Constructor
	def __init__(self, author, content, options):
		self.post_type = 'poll'
		self.post_id = str(uuid.uuid4())
		self.content = content
		self.author = author
		self.options = [{'name': e, 'count': 0} for e in options]
		self.created_on = str(datetime.today().strftime("%b %d, %Y %H:%M:%S"))

	@hybrid_property
	def likes(self):
		lx = LikedPosts.query.filter_by(post_id=self.post_id).all()
		return [x for x in lx]

	def like(self, user):
		obj = LikedPosts(user=user, post=self)
		db.session.add(obj)
		db.session.commit()

	def unlike(self, user):
		obj = LikedPosts.query.filter_by(user=user, post_id=self.post_id).first()
		if(obj): 
			db.session.delete(obj)
			db.session.commit()

	def __repr__(self):
		return f"PollPost({self.post_id})"


class ShareablePost(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	post_type = db.Column(db.String)
	post_id = db.Column(db.String)
	author_id = db.Column(db.Integer, db.ForeignKey('user.id'))
	content = db.Column(db.String)
	link = db.Column(db.String)
	name = db.Column(db.String)
	created_on = db.Column(db.String)

	def __init__(self, name, content, link, author):
		self.post_type = 'shareable'
		self.post_id = str(uuid.uuid4())
		self.name = name
		self.content = content
		self.link = link
		self.author = author
		self.created_on = str(datetime.today().strftime("%b %d, %Y %H:%M:%S"))

	@hybrid_property
	def likes(self):
		lx = LikedPosts.query.filter_by(post_id=self.post_id).all()
		return [x for x in lx]

	@hybrid_property
	def reshares(self):
		rx = ResharedPosts.query.filter_by(og_post_id=self.post_id).all()
		return [x for x in rx]

	def like(self, user):
		obj = LikedPosts(user=user, post=self)
		db.session.add(obj)
		db.session.commit()

	def unlike(self, user):
		obj = LikedPosts.query.filter_by(user=user, post_id=self.post_id).first()
		if(obj): 
			db.session.delete(obj)
			db.session.commit()

	def reshare(self, user, post):
		obj = ResharedPosts(user=user, host=self, post=post)
		db.session.add(obj)
		db.session.commit()

	def unreshare(self, user, post):
		obj = ResharedPosts.query.filter_by(user=user, og_post_id=self.post_id, reshared_post_id=post.post_id).first()
		if(obj): 
			db.session.delete(obj)
			db.session.commit()

	def __repr__(self):
		return f"ShareablePost({self.name})"

class TimelinePost(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	post_type = db.Column(db.String)
	post_id = db.Column(db.String)
	background = db.Column(db.String)
	timeline_name = db.Column(db.String)
	author_id = db.Column(db.Integer, db.ForeignKey('user.id'))
	content = db.Column(db.String)
	events = db.Column(db.PickleType)
	created_on = db.Column(db.String)
	comments = db.relationship('Comment', backref='timeline_parent')

	"""
	SCHEMA(events): [
        {
          'event_name': 'The Situation Abroad',
          'description':
              'A Very Dire Situation',
          'timestamp': 'late 2019'
        },
	]
	"""

	def __init__(self, timeline_name, events, background, author):
		self.post_type = 'timeline'
		self.post_id = str(uuid.uuid4())
		self.timeline_name = timeline_name
		self.events = events
		self.background = background
		self.author = author
		self.created_on = str(datetime.today().strftime("%b %d, %Y %H:%M:%S"))

	@hybrid_property
	def likes(self):
		lx = LikedPosts.query.filter_by(post_id=self.post_id).all()
		return [x for x in lx]

	@hybrid_property
	def reshares(self):
		rx = ResharedPosts.query.filter_by(og_post_id=self.post_id).all()
		return [x for x in rx]

	def like(self, user):
		obj = LikedPosts(user=user, post=self)
		db.session.add(obj)
		db.session.commit()

	def unlike(self, user):
		obj = LikedPosts.query.filter_by(user=user, post_id=self.post_id).first()
		if(obj): 
			db.session.delete(obj)
			db.session.commit()

	def reshare(self, user, post):
		obj = ResharedPosts(user=user, host=self, post=post)
		db.session.add(obj)
		db.session.commit()

	def unreshare(self, user, post):
		obj = ResharedPosts.query.filter_by(user=user, og_post_id=self.post_id, reshared_post_id=post.post_id).first()
		if(obj): 
			db.session.delete(obj)
			db.session.commit()

	def __repr__(self):
		return f"TimelinePost({self.timeline_name})"

class Comment(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	post_type = db.Column(db.String)
	comment_id = db.Column(db.String)
	author_id = db.Column(db.Integer, db.ForeignKey('user.id'))
	content = db.Column(db.String)
	created_on = db.Column(db.String)
	category = db.Column(db.String)
	microblog_pid =  db.Column(db.Integer, db.ForeignKey('micro_blog_post.id'))
	blog_pid =  db.Column(db.Integer, db.ForeignKey('blog_post.id'))
	timeline_pid = db.Column(db.Integer, db.ForeignKey('timeline_post.id'))
	rwc_pid = db.Column(db.Integer, db.ForeignKey('reshare_with_comment.id'))

	def __init__(self, author, content, category, microblog_parent=None, blog_parent=None, timeline_parent=None, rwc_parent=None):
		self.post_type = 'comment'
		self.comment_id = str(uuid.uuid4())
		self.content = content
		self.category = category

		if(microblog_parent != None) : self.microblog_parent = microblog_parent
		if(blog_parent != None) : self.blog_parent = blog_parent
		if(timeline_parent != None) : self.timeline_parent = timeline_parent
		if(rwc_parent != None) : self.rwc_parent = rwc_parent

		self.author = author
		self.created_on = str(datetime.today().strftime("%b %d, %Y %H:%M:%S"))

	@hybrid_property
	def likes(self):
		lx = LikedPosts.query.filter_by(post_id=self.comment_id).all()
		return [x for x in lx]

	def like(self, user):
		obj = LikedPosts(user=user, post=self)
		db.session.add(obj)
		db.session.commit()

	def unlike(self, user):
		obj = LikedPosts.query.filter_by(user=user, post_id=self.post_id).first()
		if(obj): 
			db.session.delete(obj)
			db.session.commit()

	def __repr__(self):
	 return f"Comment({self.comment_id})"

class SimpleReshare(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	post_type = db.Column(db.String)
	post_id = db.Column(db.String)
	host_id = db.Column(db.String)
	host_type = db.Column(db.String)
	author_id = db.Column(db.Integer, db.ForeignKey('user.id'))

	def __init__(self, author, host):
		self.author = author
		self.post_type = 'SimpleReshare'
		self.post_id = str(uuid.uuid4())
		self.host_id = host.post_id
		self.host_type = host.post_type
		
	def __repr__(self):
		return f"SimpleReshare({self.post_id} -> {self.host_id})"

class ReshareWithComment(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	post_type = db.Column(db.String)
	post_id = db.Column(db.String)
	host_id = db.Column(db.String)
	author_id = db.Column(db.Integer, db.ForeignKey('user.id'))
	comments = db.relationship('Comment', backref='rwc_parent')
	content = db.Column(db.String)
	created_on = db.Column(db.String)
	category = db.Column(db.String)
	host_type = db.Column(db.String)

	def __init__(self, content, category, author, host):
		self.post_type = 'ResharedWithComment'
		self.post_id = str(uuid.uuid4())
		self.content = content
		self.category = category
		self.author = author
		self.host_id = host.post_id
		self.created_on = str(datetime.today().strftime("%b %d, %Y %H:%M:%S"))
		self.host_type = host.post_type

	@hybrid_property
	def likes(self):
		lx = LikedPosts.query.filter_by(post_id=self.post_id).all()
		return [x for x in lx]

	def like(self, user):
		obj = LikedPosts(user=user, post=self)
		db.session.add(obj)
		db.session.commit()

	def unlike(self, user):
		obj = LikedPosts.query.filter_by(user=user, post_id=self.post_id).first()
		if(obj): 
			db.session.delete(obj)
			db.session.commit()
		
	def __repr__(self):
		return f"ResharedWithComment({self.post_id} -> {self.host_id})"

class LikedPosts(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
	post_id = db.Column(db.String)

	def __init__(self, user, post):
		self.user = user
		if(post.post_type == 'comment'):
			self.post_id = post.comment_id
		else:
			self.post_id = post.post_id

	
	def __repr__(self):
		return f"LikedPosts(user: {self.user_id} -> post: {self.post_id})"

class ResharedPosts(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	og_post_id = db.Column(db.String)
	og_post_type = db.Column(db.String)
	reshared_post_id = db.Column(db.String)
	reshare_type = db.Column(db.String)
	user_id = db.Column(db.Integer, db.ForeignKey('user.id'))

	def __init__(self, user, host, post):
		self.og_post_id = host.post_id
		self.og_post_type = host.post_type
		self.user = user
		self.reshared_post_id = post.post_id
		self.reshare_type = post.post_type


	def __repr__(self):
		return f"ResharedPosts<{self.reshare_type}>(post: {self.og_post_id} -> host: {self.reshared_post_id})"

class BookmarkedPosts(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	post_id = db.Column(db.String)
	user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
	post_type = db.Column(db.Integer)

	def __init__(self, user, post, post_type):
		self.post_id = post.post_id
		self.user = user
		self.post_type = post_type

	def __repr__(self):
		user = User.query.filter_by(id=self.user_id).first()
		return f"BookmarkedPosts(post: {self.post_id} -> user: {user.username})"

class ReportedBugs(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	username = db.Column(db.String)
	description = db.Column(db.String)
	created_on = db.Column(db.String)

	def __init__(self, username, desc):
		self.username = username
		self.description = desc
		self.created_on = str(datetime.today().strftime("%b %d, %Y %H:%M:%S"))

	def __repr__(self):
	 return f"ReportedBug({self.username}, {self.description}, {self.created_on})"

# class VotedPolls(db.Model):
# 	id = db.Column(db.Integer, primary_key=True)
# 	user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
# 	selected_option = db.Column(db.Integer)
# 	poll_id = db.Column(db.String)

# 	def __init__(self, user, poll, vote):
# 		self.user = user
# 		self.selected_option = vote
# 		self.poll_id = poll.id

# 	def __repr__(self):
# 		user = User.query.filter_by(id=self.user_id).first()
# 		return f"Poll<{self}> -> {user}"