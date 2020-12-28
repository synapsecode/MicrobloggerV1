from MicroBloggerCore import app, db
from MicroBloggerCore.models import MicroBlogPost, BlogPost, Hashtags

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

