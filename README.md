# The Microblogger Initiative (v1)
Microblogger is an Indian Microblogging service and a platform to share your opinions with the entire world! It aims to be a completely open source social media site hosted on
Github. It aims to be a successful Indian Social Media and Microblogging platform like Twitter. 

[Click here to see the buildlog of Microblogger V1](https://tulip-quality-7a5.notion.site/Microblogger-Builds-0b6f44eece5b419ca57f8a431e03ad2c)

## Instructions
1. Run the server
    ```bash
    cd MicroBloggerCore
    virtualenv venv
    source venv/bin/activate
    pip install -r requirements.txt
    python main.py
    (Open new window) ngrok http localhost:3000
    ```
2. Paste the ngrok link in serverURL variable in ```microblogger/lib/Backend/datastore.dart```
3. cd into the microblogge and use `flutter run` to run the mobile application

## Features
1. Microblogs
2. Full Length Blog Articles
3. Polls
4. Carousels
5. Timelines
6. Links
7. User Accounts (Follow, Unfollow etc)
8. User Tagging
9. Hashtags (Basic)
10. Full length Videos
11. Youtube Snippets

## TechStack
1. Flutter (Frontend & Mobile Application)
2. Python & Flask (Backend)
3. Cloudinary (File Hosting)
4. Flask-SQLAlchemy (Database)
