from MicroBloggerCore import app, db
from MicroBloggerCore.models import MicroBlogPost, BlogPost, Hashtags
from helperfunctions import parse_hashtags

ac = app.app_context()

def make():
	with ac:
		db.create_all()
		db.session.commit()


def new_hashtag(ht):
	
	if(ht not in [x.hashtag for x in Hashtags.query.all()]):
		print('making hashtag entry')
		H = Hashtags(hashtag=ht)
		db.session.add(H)
		db.session.commit()
		return H
	else:
		HX = Hashtags.query.filter_by(hashtag=ht).first()
		print('retrieved hashtag', HX)
		return HX



server = "https://6baa6c0cd4c1.ngrok.io"
def migrate_posts_to_use_hashtags():
	from MicroBloggerCore.models import (User, MicroBlogPost, BlogPost, TimelinePost, ShareablePost, PollPost, ReshareWithComment, SimpleReshare, Comment, BookmarkedPosts, ResharedPosts, ReportedBugs, CarouselPost, Hashtags)
	print("Migrating")
	for x in [MicroBlogPost, BlogPost, ShareablePost, PollPost, ReshareWithComment, Comment, CarouselPost]:
		for m in x.query.all():
			user = m.author
			print("Updating", m, "User", user)
			m.content = m.content
			parse_hashtags(m, m.content)
		
	for t in TimelinePost.query.all():
		c = ""
		for x in t.events:
			c += x['description'] + " "
		print(f"Updating {t}")
		parse_hashtags(t, m.content)

def delete_unused_hashtags():
	from MicroBloggerCore.models import Hashtags
	for H in Hashtags.query.all():
		if(not H.microblogs and not H.blogs and not H.timelines and not H.shareables and not H.polls and not H.rwc and not H.comments and not H.carousels ):
			print(f"Removing {H}")
			db.session.delete(H)
		db.session.commit()


migrate_posts_to_use_hashtags()
# migrate_posts_to_use_hashtags()






def hashtest():
	
	with ac:
		#Adding to Microblog
		MB = MicroBlogPost.query.first()
		h1 = new_hashtag('devinitelyhealthy')
		h1.microblogs.append(MB)
		db.session.commit()

		#Adding to Blog
		B = BlogPost.query.first()
		h1 = new_hashtag('devinitelyhealthy')
		h1.blogs.append(B)
		db.session.commit()

		B2 = BlogPost.query.first()
		h2 = new_hashtag('codingdays')
		h2.blogs.append(B2)
		db.session.commit()

		B3 = BlogPost.query.all()[-1]
		h3 = new_hashtag('worlcode')
		h3.blogs.append(B3)
		db.session.commit()


		MB2 = MicroBlogPost.query.all()[-1]
		h3 = new_hashtag('worlcode')
		h3.microblogs.append(MB2)
		db.session.commit()

		print("All Hashtags")
		print(Hashtags.query.all())

		print("CodingDaysHashtag (MB | B)")
		print(h1.microblogs)
		print(h1.blogs) 

