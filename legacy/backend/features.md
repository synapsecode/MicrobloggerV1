- Live Locatioon
- TextOnly Posts (microblogs)
- MediaPosts (Videos and Images Carousel)
- CombinationPosts (blog, timelines)
- SharingPosts (LinkPreview(Shareable), YoutubeElement)
- SpotifyElement
- VideoCalling(BareBones)
- Stories with Resharing(Single-Level)
- Resharing
- AudioRooms(Spaces)
- SingleChats & GroupChats
- Hashtags and Flairs(Fact,Opinion,Joke,NoFlair)

structure

- GenericPost
    - id: PrimaryKey
    - created_on: DateTime
    - authors: [Users<O-M>]
    - likes: <>
    - comments: [GenericPost<O-M>]
    - reshares: <>
    - dataModel
        - Microblog
            - media: [{type, cloud_link}]
            - content: String
        - Blog
            - title: String
            - cover: String<cloudlink>
            - content: [ {type, content: String(text|cloudlink)} ]
        <!-- - YoutubeElement
            - content: String
            - source: String(ytvideolink)
        - SpotifyElement
            - content: String
            - source: String(spotifylink) -->
        - Poll
            - content: String
            - options: []
- Story
    - id: PrimaryKey
    - created_on: DateTime
    - author: User
    - restories: [],
    - slot: [LocationWrapper(GenericPost)
    - content: {}

Targets
- ios
- android
- web (beta)

Tech
- Backend: ExpressJS & Typescript
- Database: CockroachDB & Sequelize
- Frontend: Flutter 3