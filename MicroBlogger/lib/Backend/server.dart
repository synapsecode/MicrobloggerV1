import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'datastore.dart';

login(username, password) async {
  final response = await http.post(
    '$serverURL/login',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String, String>{'username': username, 'password': password}),
  );
  if (response.statusCode == 200) {
    Map obj = json.decode(response.body);
    //print(obj);
    if (obj['code'] == 'S1')
      return obj;
    else
      return {'code': 'INCP'};
  }
  return {'code': 'ERR'};
}

register(username, password, email) async {
  final response = await http.post(
    '$serverURL/register',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
      'email': email
    }),
  );
  if (response.statusCode == 200) {
    Map obj = json.decode(response.body);
    if (obj['code'] == 'S1') return obj;
  }
  return {'code': 'ERR'};
}

getAllUsers() async {
  http.Response response = await http.get("$serverURL/all_users");
  if (response.statusCode == 200) {
    var obj = jsonDecode(response.body);
    print("Number of MicroBlogger Users: ${obj['length']}");
    return obj['users'];
  }
  return {'code': 'ERR'};
}

getProfile(username) async {
  print("Getting Profile");
  String cus;
  if (currentUser.isEmpty)
    cus = username;
  else
    cus = currentUser['user']['username'];
  http.Response response = await http.get("$serverURL/profile/$cus/$username");
  if (response.statusCode == 200) {
    var obj = jsonDecode(response.body);
    print("Got Profile");
    return obj;
  }
  return {'code': 'ERR'};
}

loadMyProfile(username) async {
  http.Response response =
      await http.get("$serverURL/getprofiledetails/$username");
  if (response.statusCode == 200) {
    Map obj = jsonDecode(response.body);
    return obj;
  }
}

updateProfile(name, location, bio, email) async {
  final response = await http.post(
    '$serverURL/editprofile',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'email': email,
      'location': location,
      'bio': bio,
      'name': name
    }),
  );
  if (response.statusCode == 200) {
    Map obj = json.decode(response.body);
    print("Saving User Object");
    await saveUserLoginInfo(currentUser['user']['username']);
  }
}

followProfile(username) async {
  final response = await http.post(
    '$serverURL/follow_profile',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'following_username': username
    }),
  );
  Map x = json.decode(response.body);
  print("Current User is Following $username: ${x['isFollowing']}");
}

unfollowProfile(username) async {
  final response = await http.post(
    '$serverURL/unfollow_profile',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'following_username': username
    }),
  );
  Map x = json.decode(response.body);
  print("Current User is Following $username: ${x['isFollowing']}");
}
//-----------------------------------------USER ACTIONS-----------------------------------------------

//---------------------------------------------GETTERS------------------------------------------------

getFeed() async {
  String username = currentUser['user']['username'];
  List feed = [];
  print("Initiated Feed Fetching routine");
  final response = await http.post(
    '$serverURL/feed',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'username': username}),
  );
  if (response.statusCode == 200) {
    Map obj = json.decode(response.body);
    //print((obj).containsKey('user'));
    if (obj['code'] == 'S1') {
      obj['feed'].forEach((e) {
        feed.add(e);
      });
      feed.shuffle();
      print("The Feed has a length of : ${feed.length}");
      return feed;
    } else {
      print("Probably Invalid User Submission or some error has occured");
      return [];
    }
  } else {
    print("Some server side error has occured");
    return [];
  }
}

getBookmarks() async {
  final response = await http.post(
    '$serverURL/my_bookmarked',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
    }),
  );
  Map x = json.decode(response.body);
  print("Number of bookmarked posts by user: ${x['length']}");
  return x['bookmarked_posts'];
}

getCommentsFromPost(post) async {
  final response = await http.post(
    '$serverURL/getpostcomments',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': post['author']['username'],
      'post_type': post['type'],
      'post_id': post['id']
    }),
  );
  if (response.statusCode == 200) {
    Map x = json.decode(response.body);
    return x['comments'];
  }
  return [];
}

getBlogData(post) async {
  final response = await http.post(
    '$serverURL/getblogbody',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': post['author']['username'],
      'post_type': post['type'],
      'post_id': post['id']
    }),
  );
  if (response.statusCode == 200) {
    Map x = json.decode(response.body);
    return x['blog'];
  }
}

getTimelineData(post) async {
  final response = await http.post(
    '$serverURL/gettimelinebody',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': post['author']['username'],
      'post_id': post['id']
    }),
  );
  if (response.statusCode == 200) {
    Map x = json.decode(response.body);
    return x['timeline'];
  }
}
//---------------------------------------------GETTERS------------------------------------------------

//------------------------------------------COMPOSERS----------------------------------------------

createMicroblog(content, category) async {
  final response = await http.post(
    '$serverURL/createmicroblog',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'content': content,
      'category': category
    }),
  );
  print("Microblog Created ${json.decode(response.body)}");
}

createBlog(content, blogName) async {
  final response = await http.post(
    '$serverURL/createblog',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'content': content,
      'blog_name': blogName
    }),
  );
  print("Blog Created ${json.decode(response.body)}");
}

createShareable(content, name, link) async {
  final response = await http.post(
    '$serverURL/createshareable',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'content': content,
      'name': name,
      'link': link
    }),
  );
  print("Shareable Created ${json.decode(response.body)}");
}

createpoll(content, options) async {
  final response = await http.post(
    '$serverURL/createpoll',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'username': currentUser['user']['username'],
      'content': content,
      'options': options
    }),
  );
  print("Poll Created ${json.decode(response.body)}");
}

createTimeline(timelineName, events) async {
  final response = await http.post(
    '$serverURL/createtimeline',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'username': currentUser['user']['username'],
      'timeline_name': timelineName,
      'events': events
    }),
  );
  print("Timeline Created ${json.decode(response.body)}");
}
//------------------------------------------COMPOSERS----------------------------------------------

//------------------------------------------POST ACTIONS-------------------------------------------

likePost(post_id, post_type) async {
  final response = await http.post(
    '$serverURL/likepost',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'post_id': post_id,
      'post_type': post_type
    }),
  );
  print(json.decode(response.body));
}

unlikePost(post_id, post_type) async {
  final response = await http.post(
    '$serverURL/unlikepost',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'post_id': post_id,
      'post_type': post_type
    }),
  );
  print(json.decode(response.body));
}

resharePost(host_id, host_type, reshareType,
    {content = "", category = ""}) async {
  final response = await http.post(
    '$serverURL/reshare',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'host_id': host_id,
      'host_type': host_type,
      'reshare_type': reshareType,
      'content': content,
      'category': category
    }),
  );
  print(json.decode(response.body));
}

unresharePost(host_id, host_type) async {
  final response = await http.post(
    '$serverURL/unreshare',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'host_id': host_id,
      'host_type': host_type,
    }),
  );
  print(json.decode(response.body));
}

bookmarkPost(post_id, post_type) async {
  final response = await http.post(
    '$serverURL/bookmarkpost',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'post_id': post_id,
      'post_type': post_type,
    }),
  );
  print(json.decode(response.body));
}

unbookmarkPost(post_id, post_type) async {
  final response = await http.post(
    '$serverURL/unbookmarkpost',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'post_id': post_id,
      'post_type': post_type,
    }),
  );
  print(json.decode(response.body));
}

addCommentToPost(post_id, post_type, content, category) async {
  final response = await http.post(
    '$serverURL/comment',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'post_id': post_id,
      'post_type': post_type,
      'content': content,
      'category': category
    }),
  );
  print(json.decode(response.body));
}

deleteCommentFromPost(comment_id) async {
  final response = await http.post(
    '$serverURL/deletecomment',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'comment_id': comment_id,
    }),
  );
  print(json.decode(response.body));
}

deletePost(post_id, post_type) async {
  final response = await http.post(
    '$serverURL/deletepost',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'post_id': post_id,
      'post_type': post_type,
    }),
  );
  print(json.decode(response.body));
}

submitVote(poll_id, selected) async {
  final response = await http.post(
    '$serverURL/submitvote',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'poll_id': poll_id,
      'selected': selected,
    }),
  );
  print(json.decode(response.body));
}

//------------------------------------------POST ACTIONS-------------------------------------------

//-----------------------------------------EXPLORE-------------------------------------------------
exploreMicroblogs() async {
  http.Response response = await http
      .get("$serverURL/exploremicroblogs/${currentUser['user']['username']}");
  if (response.statusCode == 200) {
    var obj = jsonDecode(response.body);
    print("Number of MicroBlogs to Explore: ${obj['length']}");
    return obj['posts'];
  }
}

exploreBlogs() async {
  http.Response response = await http
      .get("$serverURL/exploreblogs/${currentUser['user']['username']}");
  if (response.statusCode == 200) {
    var obj = jsonDecode(response.body);
    print("Number of Blogs to Explore: ${obj['length']}");
    return obj['posts'];
  }
}

exploreTimelines() async {
  http.Response response = await http
      .get("$serverURL/exploretimelines/${currentUser['user']['username']}");
  if (response.statusCode == 200) {
    var obj = jsonDecode(response.body);
    print("Number of Timelines to Explore: ${obj['length']}");
    return obj['posts'];
  }
}

exploreShareablesandPolls() async {
  http.Response response = await http.get(
      "$serverURL/exploreshareablesandpolls/${currentUser['user']['username']}");
  if (response.statusCode == 200) {
    var obj = jsonDecode(response.body);
    print("Number of Timelines to Explore: ${obj['length']}");
    return obj['posts'];
  }
}
//-----------------------------------------EXPLORE-------------------------------------------------

getNewsFeed() async {
  http.Response response = await http.get("$serverURL/get_news_feed");
  if (response.statusCode == 200) {
    var obj = jsonDecode(response.body);
    print("Number of News Articles: ${obj['articles'].length}");
    return obj['articles'];
  }
}
//----------------------------------------------------------------------------------------------------
