

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghanacologist/Screens/Shop/shop_screen.dart';
import 'package:ghanacologist/Screens/UserProfile/user_profile.dart';
import 'package:ghanacologist/constants.dart';
import 'package:http/http.dart' as http;

import '../Services/add_screen.dart';


class InsightsPage extends StatefulWidget {
  @override
  _InsightsPageState createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  TextEditingController _searchController = TextEditingController();
  List<SearchData> _searchResults = [];

  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }
    var token = await getApiPref();


    // Replace 'your_api_endpoint' with the actual server API endpoint for search
    String apiUrl = hostName + "/insights/?filter[caption]=$query";

    try {
      http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token.toString()
        },
      );

      if (response.statusCode == 200) {
        // Assuming the server returns a list of search results
        print(json.decode(response.body));
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        SearchResponse searchResponse = SearchResponse.fromJson(jsonResponse);

        setState(() {
          _searchResults = searchResponse.data;
        });
      } else {
        // Handle error response from the server if needed
        print('Error: ${response.statusCode}');
        print(json.decode(response.body));
      }
    } catch (e) {
      // Handle any exceptions that occurred during the request
      print('Exception: $e');
    }
  }

  @override
  void initState() {

    super.initState();
    _performSearch(" ");
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Image(
                                    height: 41,
                                    image: AssetImage(
                                      'assets/images/ghanaco-logo.png',
                                    )),
                              ),
                              Stack(
                                children: [
                                  Container(
                                    width: 80,
                                    child: Image(
                                        height: 41,
                                        image: AssetImage(
                                          'assets/icons/cart.png',
                                        )),
                                  ),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        //padding: EdgeInsets.all(5),
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(100)

                                        ),
                                        child: Center(
                                          child: Text("1", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
                                        ),
                                      )
                                  )
                                ],
                              ),
                              InkWell(
                                onTap:(){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => UserProfile()));
                                },
                                child: Image(
                                    height: 41,
                                    image: AssetImage(
                                      'assets/icons/logo-yellow.png',
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                "Insights",
                                style: TextStyle(
                                    fontSize: 36, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: dark.withOpacity(0.1))),
                            child: TextFormField(
                                enabled: true,
                                controller: _searchController,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  //hintText: 'Enter Username/Email',
                                    suffixIcon: Icon(
                                      Icons.search,
                                      color: dark,
                                    ),
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal),
                                    labelText: "Search term here",
                                    labelStyle: TextStyle(fontSize: 13, color: bodyText2),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white)),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: bodyText2))),
                                inputFormatters: [LengthLimitingTextInputFormatter(225)],
                                validator: (name) {

                                },
                                textInputAction: TextInputAction.next,
                                autofocus: true,
                                onSaved: (value) {
                                  setState(() {});
                                },
                                onChanged: (query) {
                                  if(query.isEmpty){
                                    _performSearch(" ");
                                  }else{
                                    _performSearch(query);
                                  }

                                }
                            ),
                          ),
                        ),

                        Container(
                          height: MediaQuery.of(context).size.height-243,

                          child: Container(
                            width: double.infinity,
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _searchResults.length,

                                    itemBuilder: (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap:(){
                                              // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EventDetails()));
                                            },
                                            child: Container(
                                              //height: 362,
                                              //color: Colors.blue,
                                              child: Column(
                                                children: [
                                                  Image.network(_searchResults[index].media.toString(),
                                                    height: 362,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Image(
                                                          height: 41,
                                                          image: AssetImage(
                                                            'assets/icons/logo-yellow.png',
                                                          )),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(child: Text(_searchResults[index].caption.toString(), style: TextStyle(fontSize: 12),))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),

                                                  InkWell(
                                                    onTap: (){
                                                      _showModalBottomSheet(context);

                                                    },
                                                    child: Container(
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 55,
                                                            height: 55,
                                                            child: Icon(Icons.send),
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10),)

                                                            ),
                                                          ),
                                                          Container(
                                                            width: 305,
                                                            height: 55,
                                                            padding: EdgeInsets.all(15),
                                                            decoration: BoxDecoration(
                                                                color: ghanaPrimary,
                                                                borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10),)

                                                            ),
                                                            child: Align(
                                                              child: Container(
                                                                child: Text("Share", style: TextStyle(fontSize: 15, color: Colors.white),),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    height: 10,
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )

                              ],
                            ),
                          ),
                        )
                      ],
                    ),


                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                //height: 70,
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [

                        InkWell(
                          onTap: () {
                         /*   Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => InsightsPage()),
                                  (route) => false,
                            );*/
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [

                                  Image(image: AssetImage('assets/icons/home.png')),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Home'),
                                ],
                              ),
                            ],
                          ),
                        ),
                       /* InkWell(
                          onTap: () {
                            *//*    Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    UserProfile()));
                          *//*},
                          child: Column(
                            children: [

                              Image(image: AssetImage('assets/icons/insights.png')),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Insight'),
                            ],
                          ),
                        ),*/

                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AddScreen()));
                          },
                          child: Column(
                            children: [

                              Image(image: AssetImage('assets/icons/add.png')),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Add'),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ShopScreen()));
                          },
                          child: Column(
                            children: [

                              Image(image: AssetImage('assets/icons/shop.png')),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Shop'),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    UserProfile()));
                          },
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundImage: AssetImage('assets/icons/logo-yellow.png'), // Replace with your profile image path
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Profile'),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }


  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,

      builder: (BuildContext context) {
        return Container(
          height: 265.0,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            color: Colors.white,

          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.horizontal_rule, size: 50, color: dark.withOpacity(0.3),)
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: dark,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Icon(
                        Icons.arrow_back, color: Colors.white, size: 17,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  Text("Share item", style: TextStyle(fontWeight: FontWeight.w700),)


                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Text("Share via:", style: TextStyle(fontWeight: FontWeight.w700),),
              ),

              SizedBox(
                height: 30,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                    image: AssetImage('assets/icons/whatsapp.png'),
                    height: 60,
                  ),
                  Image(
                    image: AssetImage('assets/icons/facebook.png'),
                    height: 60,
                  ),
                  Image(
                    image: AssetImage('assets/icons/instagram.png'),
                    height: 60,
                  ),
                  Image(
                    image: AssetImage('assets/icons/twitter.png'),
                    height: 60,
                  ),
                  Image(
                    image: AssetImage('assets/icons/snapchat.png'),
                    height: 60,
                  ),

                ],

              ),
            ],
          ),
        );
      },
    );
  }





}



// Model Classes
class SearchResponse {
  String message;
  List<SearchData> data;
  Meta meta;

  SearchResponse({
    required this.message,
    required this.data,
    required this.meta,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      message: json['message'],
      data: List<SearchData>.from(json['data'].map((data) => SearchData.fromJson(data))),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

class SearchData {
  String uuid;
  String caption;
  String media;
  String updatedAt;
  String createdAt;
  User user;

  SearchData({
    required this.uuid,
    required this.caption,
    required this.media,
    required this.updatedAt,
    required this.createdAt,
    required this.user,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) {
    return SearchData(
      uuid: json['uuid'],
      caption: json['caption'],
      media: json['media'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  String uuid;
  String firstName;
  String lastName;
  String avatar;

  User({
    required this.uuid,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uuid: json['uuid'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }
}

class Meta {
  Pagination pagination;

  Meta({required this.pagination});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class Pagination {
  int total;
  int count;
  int perPage;
  int currentPage;
  int totalPages;

  Pagination({
    required this.total,
    required this.count,
    required this.perPage,
    required this.currentPage,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'],
      count: json['count'],
      perPage: json['per_page'],
      currentPage: json['current_page'],
      totalPages: json['total_pages'],
    );
  }
}
