from MicroBloggerCore import app, db
from MicroBloggerCore.models import User, MicroBlogPost, BlogPost, TimelinePost, ShareablePost, PollPost,Comment, SimpleReshare, ReshareWithComment, LikedPosts

print("Creating Database")
db.drop_all()
db.create_all()

print("Creating Users")
myuser = User(username="synapsecode", email="zydbhf@gg.com", password="1qzz2wsx")
manas = User(username="manashejmadi", email="zydbhf@ff.com", password="1qzz2wsx")
u2 = User(username="xae12", email="zydbhf@gg.com", password="1qzz2wsx")
james = User(username="jameswatt", email="zydbhf@gg.com", password="1qzz2wsx")
richard = User(username="richardfeynman", email="zydbhf@gg.com", password="1qzz2wsx")
albert = User(username="alberteinstein", email="zydbhf@gg.com", password="1qzz2wsx")
alfred = User(username="alfrednobel", email="zydbhf@gg.com", password="1qzz2wsx")
tesla = User(username="nikolatesla", email="zydbhf@gg.com", password="1qzz2wsx")
db.session.bulk_save_objects([myuser, manas, u2, james, richard, albert, alfred, tesla])
db.session.commit()

print("Following and Unfollowing Users")
#Users following me
myuser.followed.append(albert)
myuser.followed.append(tesla)
myuser.followed.append(richard)
myuser.followed.append(manas)
#Users following tesla
tesla.followed.append(manas)
tesla.followed.append(albert)
tesla.followed.append(myuser)
tesla.followed.append(james)
#Users following richard
richard.followed.append(myuser)
richard.followed.append(manas)
richard.followed.append(tesla)
richard.followed.append(albert)
#Users following alfred
alfred.followed.append(james)
#Users following James
james.followed.append(alfred)
#Users following XAE12
u2.followed.append(manas)
#Users following manas
manas.followed.append(u2)
manas.followed.append(myuser)

db.session.commit()

print("Displaying Profile Data")
print("")
print(f"{myuser} Following: {str(myuser.followed.all())}",end="\n\n")
print(f"{myuser} Followers: {str(myuser.followers.all())}",end="\n\n")
print(f"{tesla} Following: {str(tesla.followed.all())}",end="\n\n")
print(f"{tesla} Followers: {str(tesla.followers.all())}",end="\n\n")
print(f"{richard} Following: {str(richard.followed.all())}",end="\n\n")
print(f"{richard} Followers: {str(richard.followers.all())}",end="\n\n")
print(f"{manas} Following: {str(manas.followed.all())}",end="\n\n")
print(f"{manas} Followers: {str(manas.followers.all())}",end="\n\n")
print(f"{james} Following: {str(james.followed.all())}",end="\n\n")
print(f"{james} Followers: {str(james.followers.all())}",end="\n\n")
print(f"{u2} Following: {str(u2.followed.all())}",end="\n\n")
print(f"{u2} Followers: {str(u2.followers.all())}",end="\n\n")

print("Creating MicroBlogs")
m1 = MicroBlogPost(author=myuser, content="What a beautiful weather!", category="Fact")
m2 = MicroBlogPost(author=myuser, content="Today is such a pleasant day!", category="Opinion")
m3 = MicroBlogPost(author=myuser, content="Einstein and Tesla were absolute geniuses", category="Fact")
m4 = MicroBlogPost(author=manas, content="Oh my god I do not have enough time at all!", category="Fact")
m5 = MicroBlogPost(author=tesla, content="Edison was a giant pile of crap!", category="Opinion")
m6 = MicroBlogPost(author=albert, content="Everything is relative!", category="Fact")
m7 = MicroBlogPost(author=albert, content="Nuclear energy wil never be feasible", category="Fact")
m8 = MicroBlogPost(author=albert, content="Everything is relative!", category="Fact")
m9 = MicroBlogPost(author=james, content="Full Steam Ahead! xD", category="Opinion")
m10 = MicroBlogPost(author=alfred, content="Get a chance to win the noble prize rn!", category="Fact")
m11 = MicroBlogPost(author=richard, content="Go Learn the feynman diagrams!", category="Opinion")
m12 = MicroBlogPost(author=u2, content="I'm elon musk's cyborg son", category="Opinion")
db.session.bulk_save_objects([m1, m2, m3, m4, m5, m5, m7, m8, m9, m10, m11, m12])
db.session.commit()

print("Creating Blogs")
b1 = BlogPost(author=myuser, blog_name="Salvatore", content="Salvatore was a young man....", background="img.png")
b2 = BlogPost(author=myuser, blog_name="Dolphins", content="Dont trap the dolphins....", background="img.png")
b3 = BlogPost(author=albert, blog_name="The Theory of Relativity", content="Here ill be explaining the....", background="img.png")
b4 = BlogPost(author=richard, blog_name="Quantum Mechanics Explained", content="If you understand quantum mechanics, you dont understand it....", background="img.png")
b5 = BlogPost(author=tesla, blog_name="How Edison tried to defame me", content="He publically executed animals....", background="img.png")
db.session.bulk_save_objects([b1, b2, b3, b4, b5])
db.session.commit()

print("Creating Polls")
p1 = PollPost(author=myuser, content="Who is your favourite Dragon Ball Z Character?", options=['Goku', 'Raditz', 'Vegeta', 'Gohan'])
p2 = PollPost(author=albert, content="When did i publish the theory of relativity", options=['1900', '1905', '1915'])
p3 = PollPost(author=manas, content="Which is the best programming language", options=['Python', 'JavaScript', 'Flutter'])
db.session.bulk_save_objects([p1, p2, p3])
db.session.commit()

print("Creating Shareables")
s1 = ShareablePost(author=myuser, name="Youtube", link="www.youtube.com", content="Check out my new Youtube video!")
s2 = ShareablePost(author=myuser, name="Play Store", link="www.gplaystore.com", content="Check out my new App!")
db.session.bulk_save_objects([s1, s2])
db.session.commit()

print("Creating Timeline Posts")
t1 = TimelinePost(author=myuser, background="img.png", timeline_name="Nationalism in India", events=[
	{
		'event_name': 'The Rise of BJPs Power',
		'description':
			'BJP Won by a huge landslide margin in 2014',
		'timestamp': '2014'
	},
	{
		'event_name': 'Issue with Dissent',
		'description':
			'BJP has a clear problem with dissent!',
		'timestamp': '2019'
	},
])
db.session.add(t1)
db.session.commit()


print("Adding Comments")
c1 = Comment(author=manas, content="Nice Microblog you got there!", category="Fact", microblog_parent=m1)
c2 = Comment(author=manas, content="Keep it up mate!", category="Fact", microblog_parent=m1)
c3 = Comment(author=u2, content="Noice", category="Opinion", microblog_parent=m1)
c4 = Comment(author=myuser, content="Your mom got some robot pussy bitch", category="Fact", microblog_parent=m12)
c5 = Comment(author=myuser, content="Great Going!", category="Fact", microblog_parent=m12)
c5 = Comment(author=albert, content="Great Going!", category="Fact", blog_parent=b1)
c6 = Comment(author=albert, content="What is this please explain!", category="Fact", blog_parent=b4)
c7 = Comment(author=manas, content="Go to Pakistan", category="Opinion", timeline_parent=t1)
db.session.bulk_save_objects([c1, c2, c3, c4, c5, c6, c7])
db.session.commit()

print("Adding simple Reshares")
sr1 = SimpleReshare(author=myuser, host=m12)
sr2 = SimpleReshare(author=myuser, host=m4)
sr3 = SimpleReshare(author=myuser, host=m6)
sr4 = SimpleReshare(author=manas, host=m1)
sr5 = SimpleReshare(author=manas, host=m2)
sr6 = SimpleReshare(author=alfred, host=b4)
db.session.bulk_save_objects([sr1, sr2, sr3, sr4, sr5, sr6])
db.session.commit()

print("Linking Simple Reshares")
m12.reshare(user=myuser, post=sr1)
m4.reshare(user=myuser, post=sr2)
m6.reshare(user=myuser, post=sr3)
m1.reshare(user=manas, post=sr4)
m2.reshare(user=manas, post=sr5)
b4.reshare(user=alfred, post=sr6)

print("Adding Reshare With Comment")
rwc1 = ReshareWithComment(author=myuser, host=m7, content="That did not age well lmao.", category="Fact")
rwc2 = ReshareWithComment(author=myuser, host=b3, content="Excellent Blog Check it out please!", category="Fact")
rwc3 = ReshareWithComment(author=manas, host=s2, content="Check it out! Its really promising", category="Fact")
rwc4 = ReshareWithComment(author=manas, host=t1, content="This perfectly explains the surge in nationalism in india! Check it out1", category="Fact")

print("Linking ReshareWithComments")
m7.reshare(user=myuser, post=rwc1)
b3.reshare(user=myuser, post=rwc2)
s2.reshare(user=manas, post=rwc3)
t1.reshare(user=manas, post=rwc4)

print("Liking and Unliking Posts")
m1.like(manas)
m6.like(manas)
m7.like(alfred)
m11.like(manas)
m5.like(myuser)
m6.like(myuser)
m7.like(richard)
m8.like(myuser)
m12.like(albert)
m1.like(richard)
b1.like(myuser)
b4.like(myuser)
b3.like(manas)
b5.like(james)
p1.like(manas)
p3.like(myuser)
c3.like(myuser)
c7.like(myuser)
c6.like(manas)
t1.like(myuser)
t1.like(manas)
t1.like(u2)
rwc3.like(myuser)
rwc4.like(myuser)
rwc1.like(manas)
rwc3.like(richard)
rwc1.like(james)
rwc4.like(albert)