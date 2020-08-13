# from MicroBloggerCore import app, db
# from MicroBloggerCore.models import (User, MicroBlogPost, BlogPost, TimelinePost, ShareablePost, PollPost,Comment,
#  SimpleReshare, ReshareWithComment, LikedPosts, BookmarkedPosts)
# from post_templates import microblog, blog, timeline, poll, shareable, reshareWithComment, simpleReshare
# import random

# print("Creating Database")
# db.drop_all()
# db.create_all()

# print("Creating Users (25)")
# u1 = User(username="synapsecode", email="synapsex@gmail.com", password="qwerty")
# u2 = User(username="manashejmadi", email="manashejmadi@gmail.com", password="1qaz2wsx")
# u3 = User(username="3blue1brown", email="3b1b@gmail.com", password="12345")
# u4 = User(username="electroboom", email="mehdiboom@gmail.com", password="kaboom123")
# u5 = User(username="geekdom101", email="geekdombigd@gmail.com", password="kamehameha")
# u6 = User(username="totallynotmark", email="totallynotmark@gmail.com", password="dbsdbzgt")
# u7 = User(username="arvinash", email="arvinash@gmail.com", password="quantum123")
# u8 = User(username="unacademy", email="unacademy@gmail.com", password="jee123")
# u9 = User(username="ISC", email="indianschoolcertificate@gmail.com", password="isc123")
# u10 = User(username="synapsecode", email="synapsex@gmail.com", password="qwerty")
# u11 = User(username="slipknot", email="slipknot@gmail.com", password="slipknot123")
# u12 = User(username="systemofadown", email="systemofadown@gmail.com", password="byop")
# u13 = User(username="teamfourstar", email="tfs@gmail.com", password="senzubean")
# u14 = User(username="nikolatesla", email="nikolatesla@gmail.com", password="tesla123")
# u15 = User(username="aib", email="allindiabakchod@gmail.com", password="aib123")
# u16 = User(username="alberteinstein", email="alberteinstein@gmail.com", password="relativepassword")
# u17 = User(username="richardfeynman", email="richardfeynman@gmail.com", password="okayfeynman")
# u18 = User(username="edison", email="thomasedison@gmail.com", password="thomas123")
# u19 = User(username="flutter", email="googleflutter@gmail.com", password="flutter")
# u20 = User(username="elonmusk", email="elonmusk@gmail.com", password="spacex")
# u21 = User(username="coreytaylor", email="taylorcorey@gmail.com", password="slipknot123")
# u22 = User(username="nilered", email="nilered@gmail.com", password="chemistry")
# u23 = User(username="assassinscreed", email="acreed@gmail.com", password="ac4")
# u24 = User(username="sciencephiletheai", email="sciencephile@gmail.com", password="punymortals")
# u25 = User(username="kurzgesagt", email="kurzgesagt@gmail.com", password="inanutshell")
# addUsers()
# users = [u1, u2, u3, u4, u5, u6, u7, u8, u9, u10, u11, u12, u13, u14, u15, u16, u17, u18, u19, u20, u21, u22, u23, u24, u25]
# ul = list(range(1, users.length+1))

# print("Adding Arbitrary Follow Relations")
# #Users following -> object
# for user in users:
# 	for _ in range(1, random.choice(ul)+1):
# 		rx = random.choice(user)
# 		if(rx != user and (rx not in set(user.followed))):
# 			user.followed.append(rx)
# 			print(f"{rx} started following {user}")
# db.session.commit()

# #Create MicroBlogs
# addMicroBlogs()
# #Create Blogs
# addBlogs()
# #Create Timelines
# addTimelines()
# #Create Shareables
# addShareables()
# #Create PollPosts
# addPolls()
# #Add Comments
# addComments()
# #ReshareWithComment
# addRWC()
# #SimpleReshare
# addSimpleReshare()
# #LikePosts
# db.session.commit()
# #Bookmark Posts
# db.session.commit()

print("Creating Users")
myuser = User(username="synapsecode", email="zydbhf@gg.com", password="1qzz2wsx")
manas = User(username="manashejmadi", email="zydbhf@ff.com", password="1qzz2wsx")
u2 = User(username="xae12", email="zydbhf@gg.com", password="1qzz2wsx")
james = User(username="jameswatt", email="zydbhf@gg.com", password="1qzz2wsx")
richard = User(username="richardfeynman", email="zydbhf@gg.com", password="1qzz2wsx")
albert = User(username="alberteinstein", email="zydbhf@gg.com", password="1qzz2wsx")
alfred = User(username="alfrednobel", email="zydbhf@gg.com", password="1qzz2wsx")
tesla = User(username="nikolatesla", email="zydbhf@gg.com", password="1qzz2wsx")
db.session.add(myuser)
db.session.add(manas)
db.session.add(u2)
db.session.add(james)
db.session.add(richard)
db.session.add(albert)
db.session.add(alfred)
db.session.add(tesla)
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
print(f"{myuser} Following: {str(myuser.my_following)}",end="\n\n")
print(f"{myuser} Followers: {str(myuser.my_followers)}",end="\n\n")
print(f"{tesla} Following: {str(tesla.my_following)}",end="\n\n")
print(f"{tesla} Followers: {str(tesla.my_followers)}",end="\n\n")
print(f"{richard} Following: {str(richard.my_following)}",end="\n\n")
print(f"{richard} Followers: {str(richard.my_followers)}",end="\n\n")
print(f"{manas} Following: {str(manas.my_following)}",end="\n\n")
print(f"{manas} Followers: {str(manas.my_followers)}",end="\n\n")
print(f"{james} Following: {str(james.my_following)}",end="\n\n")
print(f"{james} Followers: {str(james.my_followers)}",end="\n\n")
print(f"{u2} Following: {str(u2.my_following)}",end="\n\n")
print(f"{u2} Followers: {str(u2.my_followers)}",end="\n\n")

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
db.session.add(m1)
db.session.add(m2)
db.session.add(m3)
db.session.add(m4)
db.session.add(m5)
db.session.add(m6)
db.session.add(m7)
db.session.add(m8)
db.session.add(m9)
db.session.add(m10)
db.session.add(m11)
db.session.add(m12)
db.session.commit()

print("Creating Blogs")
b1 = BlogPost(author=myuser, blog_name="Salvatore", content="Salvatore was a young man....", background="https://cdn.vox-cdn.com/thumbor/eHhAQHDvAi3sjMeylWgzqnqJP2w=/0x0:1800x1200/1200x0/filters:focal(0x0:1800x1200):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/13272825/The_Verge_Hysteresis_Wallpaper_Small.0.jpg")
b2 = BlogPost(author=myuser, blog_name="Dolphins", content="Dont trap the dolphins....", background="https://cdn.vox-cdn.com/thumbor/eHhAQHDvAi3sjMeylWgzqnqJP2w=/0x0:1800x1200/1200x0/filters:focal(0x0:1800x1200):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/13272825/The_Verge_Hysteresis_Wallpaper_Small.0.jpg")
b3 = BlogPost(author=albert, blog_name="The Theory of Relativity", content="Here ill be explaining the....", background="https://cdn.vox-cdn.com/thumbor/eHhAQHDvAi3sjMeylWgzqnqJP2w=/0x0:1800x1200/1200x0/filters:focal(0x0:1800x1200):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/13272825/The_Verge_Hysteresis_Wallpaper_Small.0.jpg")
b4 = BlogPost(author=richard, blog_name="Quantum Mechanics Explained", content="If you understand quantum mechanics, you dont understand it....", background="https://cdn.vox-cdn.com/thumbor/eHhAQHDvAi3sjMeylWgzqnqJP2w=/0x0:1800x1200/1200x0/filters:focal(0x0:1800x1200):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/13272825/The_Verge_Hysteresis_Wallpaper_Small.0.jpg")
b5 = BlogPost(author=tesla, blog_name="How Edison tried to defame me", content="He publically executed animals....", background="https://cdn.vox-cdn.com/thumbor/eHhAQHDvAi3sjMeylWgzqnqJP2w=/0x0:1800x1200/1200x0/filters:focal(0x0:1800x1200):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/13272825/The_Verge_Hysteresis_Wallpaper_Small.0.jpg")
db.session.add(b1)
db.session.add(b2)
db.session.add(b3)
db.session.add(b4)
db.session.add(b5)
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
db.session.add(p1)
db.session.add(p2)
db.session.add(p3)
db.session.commit()

print("Creating Timeline Posts")
t1 = TimelinePost(author=myuser, background="https://i1.wp.com/regionweek.com/wp-content/uploads/2020/03/World-Map-2.jpg?fit=1920%2C1200&ssl=1", timeline_name="Nationalism in India", events=[
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
db.session.add(c1)
db.session.add(c2)
db.session.add(c3)
db.session.add(c4)
db.session.add(c5)
db.session.add(c6)
db.session.add(c7)
db.session.commit()

print("Adding simple Reshares")
sr1 = SimpleReshare(author=myuser, host=m12)
sr2 = SimpleReshare(author=myuser, host=m4)
sr3 = SimpleReshare(author=myuser, host=m6)
sr4 = SimpleReshare(author=manas, host=m1)
sr5 = SimpleReshare(author=manas, host=m2)
sr6 = SimpleReshare(author=alfred, host=b4)
db.session.add(sr1)
db.session.add(sr2)
db.session.add(sr3)
db.session.add(sr4)
db.session.add(sr5)
db.session.add(sr6)
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
db.session.add(rwc1)
db.session.add(rwc2)
db.session.add(rwc3)
db.session.add(rwc4)

print("Linking ReshareWithComments")
m7.reshare(user=myuser, post=rwc1)
b3.reshare(user=myuser, post=rwc2)
s2.reshare(user=manas, post=rwc3)
t1.reshare(user=manas, post=rwc4)

print("Liking Posts")
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
b4.like(manas)

print("Unliking Posts")
rwc1.unlike(manas)


print("Displaying likes for Timeline 1")
print(str(t1.likes))
print("\n\n")

print(f"synapsecode's Liked Posts: {str(myuser.liked_posts)}")
print("\n\n")

print("bookmarking")
u2.add_bookmark(m12,'microblog')
myuser.add_bookmark(m2,'microblog')  
albert.add_bookmark(b2,'blog') 
manas.add_bookmark(s2,'shareable') 
myuser.add_bookmark(t1,'timeline') 
myuser.add_bookmark(b3,'blog') 
richard.add_bookmark(rwc3,'ResharedWithComment') 
manas.add_bookmark(rwc3,'ResharedWithComment')  


print(f"synapsecode's Bookmarked Posts: {str(myuser.bookmarked_posts)}")
print("\n\n")
print(f"manas' Bookmarked Posts: {str(manas.bookmarked_posts)}")
print("\n\n")

print("Removing Post Bookmark from manas..")
manas.remove_bookmark(rwc3)

print(f"manas' Bookmarked Posts: {str(manas.bookmarked_posts)}")
print("\n\n")

# v = VotedPolls(user=myuser, poll=p1, vote=1)
# db.session.add(v)
# db.session.commit()


# def addUsers():
# 	db.session.add(u1)
# 	db.session.add(u2)
# 	db.session.add(u3)
# 	db.session.add(u4)
# 	db.session.add(u5)
# 	db.session.add(u6)
# 	db.session.add(u7)
# 	db.session.add(u8)
# 	db.session.add(u9)
# 	db.session.add(u10)
# 	db.session.add(u11)
# 	db.session.add(u12)
# 	db.session.add(u13)
# 	db.session.add(u14)
# 	db.session.add(u15)
# 	db.session.add(u16)
# 	db.session.add(u17)
# 	db.session.add(u18)
# 	db.session.add(u19)
# 	db.session.add(u20)
# 	db.session.add(u21)
# 	db.session.add(u22)
# 	db.session.add(u23)
# 	db.session.add(u24)
# 	db.session.add(u25)
# 	db.session.commit()

# def addMicroblog():
# 	...

# def addBlog():
# 	...

# def addTimeline():
# 	...

# def addShareable():
# 	...

# def addPoll():
# 	...

# def addRWC():
# 	...

# def addComments():
# 	...

# def addSimpleReshare():
# 	...