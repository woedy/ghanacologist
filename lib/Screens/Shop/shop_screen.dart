

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ghanacologist/Screens/Insights/insights.dart';
import 'package:ghanacologist/Screens/Shop/shop_details.dart';
import 'package:ghanacologist/Screens/Shop/shop_screen.dart';
import 'package:ghanacologist/Screens/UserProfile/user_profile.dart';
import 'package:ghanacologist/constants.dart';
import 'package:http/http.dart' as http;

import '../Services/add_screen.dart';


class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Data> _searchResults = [];

  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }
    var token = await getApiPref();


    // Replace 'your_api_endpoint' with the actual server API endpoint for search
    String apiUrl = hostName + "/services/?filter[q]=$query";

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
          _searchResults = searchResponse.data!;
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

                           /*   Text(
                                "Insights",
                                style: TextStyle(
                                    fontSize: 36, fontWeight: FontWeight.w600),
                              ),*/
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
                                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ShopDetails(data: _searchResults[index])));
                                            },
                                            child: Container(
                                              height: 362,
                                              //color: Colors.blue,
                                              child: Stack(
                                                children: [
                                                  /*  Image.network(
                                                              data.data![index].photo!.toString(),
                                                              height: 362,
                                                              width: double.infinity,
                                                              fit: BoxFit.cover,
                                                            ),*/
                                                  Container(
                                                    height: 362,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: NetworkImage(_searchResults[index].photo!.toString()),

                                                          fit: BoxFit.cover,
                                                        ),
                                                        gradient: LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: [
                                                            Colors.transparent,
                                                            Colors.black.withOpacity(0.9),
                                                          ],
                                                        ),
                                                        borderRadius: BorderRadius.circular(30)),
                                                  ),
                                                  Container(
                                                    height: 362,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(

                                                        gradient: LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: [
                                                            Colors.transparent,
                                                            Colors.black.withOpacity(0.9),
                                                          ],
                                                        ),
                                                        borderRadius: BorderRadius.circular(30)),
                                                  ),
                                                  Positioned(
                                                    top: 230,
                                                    left: 20,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          _searchResults[index].name!.toString(),
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 32),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          _searchResults[index].phone!.toString(),
                                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                                        ),


                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                                                          decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(50)
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.language,
                                                                color: Colors.black,
                                                                size: 15,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                _searchResults[index].url!.toString(),
                                                                style: TextStyle(color: Colors.black),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
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
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => InsightsPage()),
                                  (route) => false,
                            );
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
                    /*    InkWell(
                          onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    InsightsPage()));
                          },
                          child: Column(
                            children: [

                              Image(image: AssetImage('assets/icons/insights.png')),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Insight'),
                            ],
                          ),
                        ),
*/
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
                       /*     Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ShopScreen()));
                         */ },
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




}



// Model Classes
class SearchResponse {
  String? message;
  List<Data>? data;
  Meta? meta;

  SearchResponse({this.message, this.data, this.meta});

  SearchResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class Data {
  String? name;
  String? phone;
  String? email;
  String? city;
  String? region;
  String? url;
  String? description;
  String? uuid;
  String? updatedAt;
  String? createdAt;
  String? photo;

  Data(
      {this.name,
        this.phone,
        this.email,
        this.city,
        this.region,
        this.url,
        this.description,
        this.uuid,
        this.updatedAt,
        this.createdAt,
        this.photo});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    city = json['city'];
    region = json['region'];
    url = json['url'];
    description = json['description'];
    uuid = json['uuid'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['city'] = this.city;
    data['region'] = this.region;
    data['url'] = this.url;
    data['description'] = this.description;
    data['uuid'] = this.uuid;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['photo'] = this.photo;
    return data;
  }
}

class Meta {
  Pagination? pagination;

  Meta({this.pagination});

  Meta.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Pagination {
  int? total;
  int? count;
  int? perPage;
  int? currentPage;
  int? totalPages;

  Pagination(
      {this.total,
        this.count,
        this.perPage,
        this.currentPage,
        this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    count = json['count'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['count'] = this.count;
    data['per_page'] = this.perPage;
    data['current_page'] = this.currentPage;
    data['total_pages'] = this.totalPages;
    return data;
  }
}
