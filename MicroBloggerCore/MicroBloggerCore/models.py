from MicroBloggerCore import db
from datetime import date
import uuid
from sqlalchemy.ext.hybrid import hybrid_property

followers = db.Table('followers',
    db.Column('follower_id', db.Integer, db.ForeignKey('users.id')),
    db.Column('followed_id', db.Integer, db.ForeignKey('users.id'))
)

class Users(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	user_id = db.Column(db.String)
	username = db.Column(db.String)
	password = db.Column(db.String)
	name = db.Column(db.String)
	email = db.Column(db.String)
	icon = db.Column(db.String)
	background = db.Column(db.String)
	reputation = db.Column(db.String)
	followed = db.relationship(
		'Users', secondary=followers,
		primaryjoin=(followers.c.follower_id == id),
		secondaryjoin=(followers.c.followed_id == id),
		backref=db.backref('followers', lazy='dynamic'), lazy='dynamic')
	created_on = db.Column(db.String)
	bio = db.Column(db.String)
	# liked_posts = db.Column(db.PickleType) -> [Microblog, Blog, Shareable, Timeline]
	# bookmarked_posts = db.Column(db.PickleType) -> [Micro,blog, Blog, Shareable, Timeline]
	location = db.Column(db.String)
	my_microblogs = db.relationship('MicroBlogPosts', backref='author')
	my_blogs = db.relationship('BlogPosts', backref='author')
	my_timelines = db.relationship('TimelinePosts', backref='author')
	my_shareables = db.relationship('ShareablePosts', backref='author')
	my_reshareWithComments = db.relationship('ReshareWithComment', backref='author')
	my_simpleReshares = db.relationship('SimpleReshares', backref='author')
	my_polls = db.relationship('PollPosts', backref='author')
	my_comments = db.relationship('Comment', backref='author')

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
		self.created_on = str(date.today().strftime("%B %d, %Y"))
		self.bio = ''
		self.location = 'Unspecified Location'
		#TODO: Make some nice relations for user and posts

	def follow(self, user):
		if not self.is_following(user):
			self.followed.append(user)

	def unfollow(self, user):
		if self.is_following(user):
			self.followed.remove(user)

	def is_following(self, user):
		return self.followed.filter(
		followers.c.followed_id == user.id).count() > 0

	def __repr__(self):
		return f"MicroBlogUser({self.username})"

class MicroBlogPosts(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	post_type = db.Column(db.String)
	post_id = db.Column(db.String)
	author_id = db.Column(db.Integer, db.ForeignKey('users.id'))
	comments = db.relationship('Comment', backref='microblog_parent')
	#likes = USER
	#reshares = SIMPLERESHARE OR RESHAREWITHCOMEMNT
	content = db.Column(db.String)
	created_on = db.Column(db.String)
	category = db.Column(db.String)

	def __init__(self, content, category, author):
		#TODO: link author
		self.post_type = 'microblog'
		self.post_id = str(uuid.uuid4())
		self.content = content
		self.category = category
		self.author = author
		self.created_on = str(date.today().strftime("%B %d, %Y %H:%M:%S"))

	def __repr__(self):
		return f"MicroBlogPost({self.post_id})"

	
class BlogPosts(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	post_type = db.Column(db.String)
	post_id = db.Column(db.String)
	background = db.Column(db.String) #TODO: Picture hosting service needed
	blog_name = db.Column(db.String)
	author_id = db.Column(db.Integer, db.ForeignKey('users.id'))
	#likes = USERS
	#reshares = SIMPLERESHARE OR RESHAREWITHCOMEMNT
	comments = db.relationship('Comment', backref='blog_parent')
	content = db.Column(db.String)
	created_on = db.Column(db.String)

	def __init__(self, author, blog_name, content, background):
		#TODO: link author
		self.post_type = 'blog'
		self.post_id = str(uuid.uuid4())
		self.blog_name = blog_name
		self.content = content
		self.background = background
		self.author = author
		self.created_on = str(date.today().strftime("%B %d, %Y %H:%M:%S"))

	def __repr__(self):
		return f"BlogPost({self.blog_name})"

class PollPosts(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	post_type = db.Column(db.String)
	post_id = db.Column(db.String)
	author_id = db.Column(db.Integer, db.ForeignKey('users.id'))
	#likes = USERS
	content = db.Column(db.String)
	options = db.Column(db.PickleType)
	created_on = db.Column(db.String)
	"""
	'options': [
        {'name': 'Goku', 'count': 0},
        {'name': 'Vegeta', 'count': 0},
        {'name': 'Gohan', 'count': 0},
        {'name': 'Piccolo', 'count': 0},
        {'name': 'Trunks', 'count': 0},
      ],
	"""

	def __init__(self, author, content, options):
		#TODO: link author
		self.post_type = 'poll'
		self.post_id = str(uuid.uuid4())
		self.content = content
		self.background = background
		self.author = author
		self.created_on = str(date.today().strftime("%B %d, %Y %H:%M:%S"))

	def __repr__(self):
		return f"PollPost({self.post_id})"

class ShareablePosts(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	post_type = db.Column(db.String)
	post_id = db.Column(db.String)
	author_id = db.Column(db.Integer, db.ForeignKey('users.id'))
	#likes = USERS
	#reshares = SIMPLERESHARE OR RESHAREWITHCOMEMNT
	content = db.Column(db.String)
	link = db.Column(db.String)
	name = db.Column(db.String)
	created_on = db.Column(db.String)

	def __init__(self, name, content, link, author):
		#TODO: link author
		self.post_type = 'shareable'
		self.post_id = str(uuid.uuid4())
		self.name = name
		self.content = content
		self.link = link
		self.author = author
		self.created_on = str(date.today().strftime("%B %d, %Y %H:%M:%S"))

	def __repr__(self):
		return f"ShareablePost({self.name})"

class TimelinePosts(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	post_type = db.Column(db.String)
	post_id = db.Column(db.String)
	background = db.Column(db.String)
	timeline_name = db.Column(db.String)
	author_id = db.Column(db.Integer, db.ForeignKey('users.id'))
	#likes = USERS
	#reshares = SIMPLERESHARE OR RESHAREWITHCOMEMNT
	
	content = db.Column(db.String)
	events = db.Column(db.PickleType)
	created_on = db.Column(db.String)
	comments = db.relationship('Comment', backref='timeline_parent')

	"""
	'events': [
        {
          'event_name': 'The Situation Abroad',
          'description':
              'A Very Dire Situation',
          'timestamp': 'late 2019'
        },
        {
          'event_name': 'First Signs',
          'description':
              'The first signs are here!',
          'timestamp': 'February 2020'
        },
	]
	"""

	def __init__(self, timeline_name, events, background, author):
		#TODO: link author
		self.post_type = 'timeline'
		self.post_id = str(uuid.uuid4())
		self.timeline_name = timeline_name
		self.events = events
		self.background = background
		self.author = author
		self.created_on = str(date.today().strftime("%B %d, %Y %H:%M:%S"))

	def __repr__(self):
		return f"TimelinePost({self.name})"

class SimpleReshares(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	post_type = db.Column(db.String)
	post_id = db.Column(db.String)
	#host -> [Microblog, Blog, Shareable, Timeline]
	author_id = db.Column(db.Integer, db.ForeignKey('users.id'))
	#likes = USERS
	#reshares = SIMPLERESHARE OR RESHAREWITHCOMEMNT

	def __init__(self, author):
		#TODO: link host
		self.author = author
		self.post_type = 'SimpleReshare'
		self.post_id = str(uuid.uuid4())

	def __repr__(self):
		return f"SimpleReshare({self.name})"

class ReshareWithComment(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	post_type = db.Column(db.String)
	post_id = db.Column(db.String)
	#host-> [Microblog, Blog, Shareable, Timeline]
	author_id = db.Column(db.Integer, db.ForeignKey('users.id'))
	comments = db.relationship('Comment', backref='rwc_parent')
	#likes = USERS
	content = db.Column(db.String)
	created_on = db.Column(db.String)
	category = db.Column(db.String)

	def __init__(self, content, category, author):
		#TODO: link author
		#TODO: link host
		self.post_type = 'ReshareWithComment'
		self.post_id = str(uuid.uuid4())
		self.content = content
		self.category = category
		self.author = author
		self.created_on = str(date.today().strftime("%B %d, %Y %H:%M:%S"))

	def __repr__(self):
		return f"ReshareWithComment({self.post_id})"

class Comment(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	post_type = db.Column(db.String)
	comment_id = db.Column(db.String)
	author_id = db.Column(db.Integer, db.ForeignKey('users.id'))
	content = db.Column(db.String)
	created_on = db.Column(db.String)
	category = db.Column(db.String)
	#likes = USERS
	microblog_pid =  db.Column(db.Integer, db.ForeignKey('micro_blog_posts.id'))
	blog_pid =  db.Column(db.Integer, db.ForeignKey('blog_posts.id'))
	timeline_pid = db.Column(db.Integer, db.ForeignKey('timeline_posts.id'))
	rwc_pid = db.Column(db.Integer, db.ForeignKey('reshare_with_comment.id'))

	@hybrid_property
	def parent_id(self):
		return self.microblog_pid or self.blog_pid or self.timeline_pid or self.rwc_pid

	# parent_id = db.Column(db.Integer, foreign_keys="[micro_blog_posts.id, blog_posts.id, timeline_posts.id, reshare_with_comment.id]")

	def __init__(self, author, content, category, microblog_parent=None, blog_parent=None, timeline_parent=None, rwc_parent=None):
		#TODO: link author
		#TODO: link parentpost
		self.post_type = 'comment'
		self.comment_id = str(uuid.uuid4())
		self.content = content
		self.category = category
		if(microblog_parent != None):
			self.microblog_parent = microblog_parent
		if(blog_parent != None):
			self.blog_parent = blog_parent
		if(timeline_parent != None):
			self.timeline_parent = timeline_parent
		if(rwc_parent != None):
			self.rwc_parent = rwc_parent
		self.author = author
		self.created_on = str(date.today().strftime("%B %d, %Y %H:%M:%S"))

	def __repr__(self):
		return f"Comment({self.comment_id})"

