class Data {
  var currentUser = {
    'username': 'synapsecode',
    'dpURL':
        'https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
    'bgURL':
        'https://cdn.vox-cdn.com/thumbor/eHhAQHDvAi3sjMeylWgzqnqJP2w=/0x0:1800x1200/1200x0/filters:focal(0x0:1800x1200):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/13272825/The_Verge_Hysteresis_Wallpaper_Small.0.jpg',
    'name': 'Manas Hejmadi',
    'email': 'manashejmadi@gmail.com'
  };
  var posts = [
    {
      'id': "P-fgrufiE3n",
      'postType': 'microblog',
      'postSubType': 'Fact',
      'time': '22h',
      'authorName': 'Arthur Kinsley',
      'authordpURL':
          'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      'authorUsername': 'arthurxd',
      'content':
          "is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
      'likes': 334,
      'comments': 0,
      'reshares': 12,
      'commentPointers': []
    },
    {
      'id': "fC-ffxxd44h",
      'parentID': 'P-fgrufiE3n',
      'postType': 'comment',
      'postSubType': 'Fact',
      'time': '22h',
      'authorName': 'Harry Kinsley',
      'authordpURL':
          'https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
      'authorUsername': 'harryk',
      'content':
          "is simply dummy text of the printing  It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, PageMaker including versions of Lorem Ipsum.",
      'likes': 2,
    },
    {
      'id': "fC-ffxxd44h",
      'postType': 'blog',
      'time': '22h',
      'authorName': 'Ryan Sebastian',
      'authordpURL':
          'https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
      'authorUsername': 'ryanseb',
      'content': "BLOGPOST CONTENT",
      'postName': 'Biggest Changes in MacOS',
      'likes': 200,
      'comments': 33,
      'reshares': 200,
      'backgroundPic':
          'https://get.wallhere.com/photo/Mac-Sierra-Apple-Inc-1404843.jpg'
    },
    {
      'id': "fC-ffxxd44h",
      'postType': 'timelines',
      'time': '24h',
      'authorName': 'Zack Wylde',
      'authordpURL':
          'https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
      'authorUsername': 'zacccw',
      'postName': 'The Covid-19 situation in India',
      'content': {},
      'likes': 34,
      'comments': 55,
      'reshares': 12,
      'backgroundPic':
          'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
    },
    {
      'id': "fC-ffxxd44h",
      'postType': 'poll',
      'time': '2h',
      'authorName': 'Manas Hejmadi',
      'authordpURL':
          'https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
      'authorUsername': 'synapsecode',
      'pollDesc': 'Who is your favourite Dragon Ball Character?',
      'options': [
        {'name': "Goku", 'likes': 0},
        {'name': "Piccolo", 'likes': 0},
        {'name': "Vegeta", 'likes': 0},
        {'name': "Master Roshi", 'likes': 0},
      ],
      'likes': 3,
      'reshares': 12
    },
    {
      'id': "fC-ffxxd44h",
      'postType': 'shareable',
      'time': '33m',
      'authorName': 'Artemis',
      'authordpURL':
          'https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
      'authorUsername': 'artemisx',
      'pollDesc':
          'Hey Guys! Check out my new application called Krustel Classroom! Its releasing exclusively on Android. Check it out using the link provided below!',
      'link': "https://www.google.com",
      'likes': 3,
      'reshares': 12
    },
  ];

  //creators
  Object createMicroBlogPost(author, postInfo) {
    return {
      'id': "fC-ffxxd44h",
      'postType': 'microblog',
      'postSubType': postInfo['postSubType'],
      'time': 'now',
      'authorName': author['name'],
      'authordpUrl': author['dpURL'],
      'authorUsername': author['username'],
      'content': postInfo['content'],
      'likes': 0,
      'comments': 0,
      'reshares': 0,
      'commentPointers': []
    };
  }

  Object createComment(author, postInfo) {
    return {
      'id': "fC-ffxxd44h",
      'parentID': 'P-fgrufiE3n',
      'postType': 'comment',
      'postSubType': postInfo['postSubType'],
      'time': 'now',
      'authorName': author['name'],
      'authordpURL': author['dpURL'],
      'authorUsername': author['username'],
      'content': postInfo['content'],
      'likes': 0,
    };
  }

  Object createBlogPost(author, postInfo) {
    return {
      'id': "fC-ffxxd44h",
      'postType': 'now',
      'time': '22h',
      'authorName': author['name'],
      'authordpURL': author['dpURL'],
      'authorUsername': author['username'],
      'content': postInfo['content'],
      'likes': 0,
      'comments': 0,
      'reshares': 0,
      'postName': 'Biggest Changes in MacOS',
    };
  }

  Object createPollPost(author, postInfo) {
    List<Map> pollItems;
    postInfo['options'].forEach((e) {
      pollItems.add({'name': e['name'], 'likes': e['likes']});
    });
    return {
      'id': "fC-ffxxd44h",
      'postType': 'poll',
      'time': 'now',
      'authorName': author['name'],
      'authordpURL': author['dpURL'],
      'authorUsername': author['username'],
      'pollDesc': postInfo['PollDesc'],
      'content': pollItems,
      'likes': 3,
      'reshares': 12
    };
  }

  Object createShareablePost(author, postInfo) {
    return {
      'id': "fC-ffxxd44h",
      'postType': 'shareable',
      'time': 'now',
      'authorName': author['name'],
      'authordpURL': author['dpURL'],
      'authorUsername': author['username'],
      'content': postInfo['content'],
      'likes': 0,
      'comments': 0,
      'reshares': 0
    };
  }
}

//https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500
//https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80
//https://www.technative.io/wp-content/uploads/2019/07/AdobeStock_235519566-e1564739130389.jpg
