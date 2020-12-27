from MicroBloggerCore import app, db

db.create_all()
db.session.commit()