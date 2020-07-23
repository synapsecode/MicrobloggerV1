from MicroBloggerCore import app, db
from MicroBloggerCore.models import Users, MicroBlogPosts, BlogPosts, TimelinePosts, ShareablePosts, PollPosts, ReshareWithComment, SimpleReshares, Comment
db.drop_all()
db.create_all()
#Create Users
myuser = Users(username="synapsecode", email="zydbhf@gg.com", password="1qzz2wsx")
u1 = Users(username="manashejmadi", email="zydbhf@ff.com", password="1qzz2wsx")
u2 = Users(username="xae12", email="zydbhf@gg.com", password="1qzz2wsx")
u3 = Users(username="krustel", email="zydbhf@gg.com", password="1qzz2wsx")
u4 = Users(username="google", email="zydbhf@gg.com", password="1qzz2wsx")
u5 = Users(username="microsoft", email="zydbhf@gg.com", password="1qzz2wsx")
db.session.add(myuser)
db.session.add(u1)
db.session.add(u2)
db.session.add(u3)
db.session.add(u4)
db.session.add(u5)
db.session.commit()
#FOllowing and Follower Feature
myuser.followed.append(u1)
myuser.followed.append(u2) 
myuser.followed.append(u3) 
myuser.followed.append(u5) 
u1.followed.append(myuser) 
u1.followed.append(u4)     
u1.followed.append(u5) 
u4.followed.append(myuser)
print(myuser.followed.all())
print(myuser.followers.all())
#TODO: save changes

#Add microBlogs
m1 = MicroBlogPosts(author=myuser, content="What a beautiful weather!", category="Fact")
m2 = MicroBlogPosts(author=myuser, content="Today is such a pleasant day!", category="Opinion")
m3 = MicroBlogPosts(author=u2, content="I feel like playing football today!", category="Opinion")
m4 = MicroBlogPosts(author=u5, content="Today we are releasing build 21150 of Windows 10", category="Fact")
db.session.add(m1)
db.session.add(m2)
db.session.add(m3)
db.session.add(m4)
db.session.commit()

#Add Comments to it
c1 = Comment(author=u1, content="I have to agree! Its so bright and sunny!", category="Opinion", microblog_parent=m1)
c2 = Comment(author=u2, content="Nahh! Its too sunny for my liking!", category="Opinion", microblog_parent=m1)
c3 = Comment(author=u5, content="Make the day better by installing our latest build!", category="Opinion", microblog_parent=m1)
c4 = Comment(author=myuser, content="Please make sure the build is stable", category="Opinion", microblog_parent=m4)
db.session.add(c1)
db.session.add(c2)
db.session.add(c3)
db.session.add(c4)
db.session.commit()

print(m1.comments)