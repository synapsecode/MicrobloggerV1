import 'dart:convert';
import 'dart:io';
import 'package:MicroBlogger/Components/Global/globalcomponents.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'datastore.dart';
import 'package:http_parser/http_parser.dart';
import '../Backend/datastore.dart';

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

reportBug(username, desc) async {
  final response = await http.post(
    '$serverURL/reportbug',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body:
        jsonEncode(<String, String>{'username': username, 'description': desc}),
  );
  print(jsonDecode(response.body));
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

updateProfile(name, location, bio, email, website) async {
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
      'name': name,
      'website': website,
    }),
  );
  if (response.statusCode == 200) {
    Map obj = json.decode(response.body);
    print("Saving User Object");
    await saveUserLoginInfo(currentUser['user']['username']);
  }
}

addDisplayPicture(dpFile) async {
  var url = Uri.parse(
      "$serverURL/updatedisplaypicture/${currentUser['user']['username']}");
  var request = http.MultipartRequest('POST', url);
  print("APTH: " + dpFile.path);
  request.files.add(await http.MultipartFile.fromPath('picture', dpFile.path));
  var response = await request.send();
  if (response.statusCode == 200) {
    print(response);
    await saveUserLoginInfo(currentUser['user']['username']);
  }
}

addCoverPicture(cFile) async {
  var url = Uri.parse("$serverURL/uploadcover");
  var request = http.MultipartRequest('POST', url);
  print("APTH: " + cFile.path);
  request.files.add(await http.MultipartFile.fromPath('picture', cFile.path));
  var response = await request.send();
  if (response.statusCode == 200) {
    var rx = await http.Response.fromStream(response);
    return jsonDecode(rx.body)['link'] ?? null;
  }
}

addBackground(bgFile) async {
  var url = Uri.parse(
      "$serverURL/updatebackground/${currentUser['user']['username']}");
  var request = http.MultipartRequest('POST', url);
  print("APTH: " + bgFile.path);
  request.files.add(await http.MultipartFile.fromPath('picture', bgFile.path));
  var response = await request.send();
  if (response.statusCode == 200) {
    print(response);
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
    print("COMMMMMMMMMMMM :::: $x");
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

getSpecificPost(post_id, post_type) async {
  final response = await http.post(
    '$serverURL/getspecificpost',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'post_type': post_type,
      'post_id': post_id
    }),
  );
  if (response.statusCode == 200) {
    Map x = json.decode(response.body);
    return x['post'];
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
  print("${json.decode(response.body)}");
}

createBlog(content, blogName, {cover}) async {
  final response = await http.post(
    '$serverURL/createblog',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'content': content,
      'blog_name': blogName,
      'cover': (cover != "")
          ? cover
          : 'https://cdn.vox-cdn.com/thumbor/eHhAQHDvAi3sjMeylWgzqnqJP2w=/0x0:1800x1200/1200x0/filters:focal(0x0:1800x1200):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/13272825/The_Verge_Hysteresis_Wallpaper_Small.0.jpg'
    }),
  );
  print("${json.decode(response.body)}");
}

createCarousel(content, images) async {
  final response = await http.post(
    '$serverURL/createcarousel',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'username': currentUser['user']['username'],
      'content': content,
      'images': images
    }),
  );
  print("${json.decode(response.body)}");
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
  print("${json.decode(response.body)}");
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
  print("${json.decode(response.body)}");
}

createTimeline(timelineName, events, {cover}) async {
  final response = await http.post(
    '$serverURL/createtimeline',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'username': currentUser['user']['username'],
      'timeline_name': timelineName,
      'events': events,
      'cover': (cover != "")
          ? cover
          : 'https://res.cloudinary.com/krustel-inc/image/upload/v1597308143/daqawgcdcvuqorju2lug.jpg'
    }),
  );
  print("${json.decode(response.body)}");
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
  print("VAL: ${post_id} ${post_type}");
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

//-----------------------------------------EDIT POSTS------------------------------------------------
editMicroblog(post_id, content, category) async {
  final response = await http.post(
    '$serverURL/editmicroblog',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'post_id': post_id,
      'content': content,
      'category': category
    }),
  );
  if (response.statusCode == 200)
    print(json.decode(response.body)['message']);
  else
    print("Server Error");
}

editBlog(post_id, content, blog_name, cover) async {
  final response = await http.post(
    '$serverURL/editblog',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'username': currentUser['user']['username'],
      'post_id': post_id,
      'content': content,
      'blog_name': blog_name,
      'cover': cover
    }),
  );
  if (response.statusCode == 200)
    print(json.decode(response.body)['message']);
  else
    print("Server Error");
}

editTimeline(post_id, title, events, cover) async {
  final response = await http.post(
    '$serverURL/edittimeline',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'username': currentUser['user']['username'],
      'post_id': post_id,
      'title': title,
      'events': events,
      'cover': cover
    }),
  );
  if (response.statusCode == 200)
    print(json.decode(response.body)['message']);
  else
    print("Server Error");
}

editResharedWithComment(post_id, content, category) async {
  final response = await http.post(
    '$serverURL/editrwc',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'post_id': post_id,
      'content': content,
      'category': category
    }),
  );
  if (response.statusCode == 200)
    print(json.decode(response.body)['message']);
  else
    print("Server Error");
}

editShareable(post_id, content, link, name) async {
  final response = await http.post(
    '$serverURL/editshareable',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'post_id': post_id,
      'content': content,
      'link': link,
      'name': name
    }),
  );
  if (response.statusCode == 200)
    print(json.decode(response.body)['message']);
  else
    print("Server Error");
}

editComment(post_id, comment, category) async {
  final response = await http.post(
    '$serverURL/editcomment',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': currentUser['user']['username'],
      'comment_id': post_id,
      'comment': comment,
      'category': category
    }),
  );
  if (response.statusCode == 200)
    print(json.decode(response.body)['message']);
  else
    print("Server Error");
}

editCarousel(post_id, content, images) async {
  final response = await http.post(
    '$serverURL/editcarousel',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'username': currentUser['user']['username'],
      'post_id': post_id,
      'content': content,
      'images': images,
    }),
  );
  if (response.statusCode == 200)
    print(json.decode(response.body)['message']);
  else
    print("Server Error");
}
//-----------------------------------------EDIT POSTS------------------------------------------------

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
  http.Response response = await http.get(
      "$serverURL/exploreblogsandcarousels/${currentUser['user']['username']}");
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
