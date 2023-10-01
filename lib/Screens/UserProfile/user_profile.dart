import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghanacologist/Screens/HomeScreen/event_details.dart';
import 'package:ghanacologist/Screens/Insights/insights.dart';
import 'package:ghanacologist/Screens/Services/add_screen.dart';
import 'package:ghanacologist/Screens/Shop/shop_screen.dart';
import 'package:ghanacologist/Screens/UserProfile/edit_user_profile.dart';
import 'package:ghanacologist/Screens/UserProfile/models/user_profile_model.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../constants.dart';

import 'package:http/http.dart' as http;


Future<ProfileModel> getUserProfile() async {

  var token = await getApiPref();

  final response = await http.get(
    Uri.parse(hostName + "/profile"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token.toString()
    },

  );

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));

    return ProfileModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    print(jsonDecode(response.body));
    return ProfileModel.fromJson(jsonDecode(response.body));
  }  else {

    throw Exception('Failed to load data');
  }
}




class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  Future<ProfileModel>? _futureProfile;


  @override
  void initState() {

    super.initState();

    _futureProfile = getUserProfile();
  }



  @override
  Widget build(BuildContext context) {


    return (_futureProfile == null) ? buildColumn() : buildFutureBuilder();


  }

  buildColumn() {

    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }

  FutureBuilder<ProfileModel> buildFutureBuilder() {
    return FutureBuilder<ProfileModel>(
        future: _futureProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Please Wait...")
                  ],
                ),
              ),
            );
          }
          else if(snapshot.hasData) {

            var data = snapshot.data!;

            print("#########################");
            print(data.message);

            if(data.message == "user profile retrieved successfully") {

              return Scaffold(
                body: SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image(
                                            height: 41,
                                            image: AssetImage(
                                              'assets/images/ghanaco-logo.png',
                                            )),
                                        Image(
                                            height: 41,
                                            image: AssetImage(
                                              'assets/icons/logo-yellow.png',
                                            )),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(100),
                                          image: DecorationImage(
                                            image: NetworkImage("https://ghanacologist.teamalfy.co.uk" + data.data!.avatar!.toString())
                                          )
                                        ),
                                      ),

                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(

                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(data.data!.firstName!.toString() + " " + data.data!.lastName!.toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Text(data.data!.title.toString(), style: TextStyle(fontSize: 12,),),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text("Ghana Technology University College", style: TextStyle(fontSize: 10, color: ghanaPrimary),),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text("Adenta, Greater Accra Region, Ghana", style: TextStyle(fontSize: 8,),)
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EditUserProfile(data: data.data!)));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.red
                                            ),
                                            child: Center(child: Text("Edit Profile",style: TextStyle(color: Colors.white),)),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: (){
                                            _showModalBottomSheet(context);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: dark.withOpacity(0.2),
                                                  width: 1,
                                                ),
                                                color: Colors.white
                                            ),
                                            child: Center(child: Text("Share Profile",style: TextStyle(),)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Text("Saved Events"),
                                      SizedBox(
                                        height: 40,
                                      ),
                                    ],
                                  ),

                                  Container(
                                    height: MediaQuery.of(context).size.height-243-189,

                                    child: Container(
                                      width: double.infinity,
                                      child: DefaultTabController(
                                        length: 3,
                                        child: Column(
                                          children: [

                                            Container(
                                              child: TabBar(
                                                indicator: BoxDecoration(
                                                  borderRadius:  BorderRadius.circular(25.0),
                                                ),
                                                labelColor: ghanaPrimary,
                                                unselectedLabelColor: dark,
                                                tabs: const  [
                                                  Tab(text: 'Location', icon: Icon(
                                                    Icons.map_outlined,
                                                    size: 30,
                                                  )),
                                                  Tab(text: 'Date', icon: Icon(
                                                    Icons.date_range_outlined,
                                                    size: 30,
                                                  )),
                                                  Tab(text: 'Popularity', icon: Icon(
                                                    Icons.show_chart,
                                                    size: 30,
                                                  )),

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
                                                  //enabled: false,
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
                                                    if (name!.isEmpty) {
                                                      return 'Required';
                                                    }
                                                    if (name.length < 3) {}
                                                    return null;
                                                  },
                                                  textInputAction: TextInputAction.next,
                                                  autofocus: true,
                                                  onSaved: (value) {
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Expanded(
                                              child: TabBarView(
                                                  children: [

                                                    location_widget(),
                                                    date_calendar_widget(),
                                                    popularity_widget()

                                                  ]),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )



                                ],
                              ),


                            ],
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
                              /*      InkWell(
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
                                        /*  Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      UserProfile()));
                            */},
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
                ),
              );

            }

          }

          return Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Please Wait...")
                ],
              ),
            ),
          );


        }
    );
  }




  Widget location_widget() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            InkWell(
              onTap:(){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EventDetails()));
              },
              child: Container(
                height: 362,
                //color: Colors.blue,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/homeimage.png',
                      height: 362,
                      width: double.infinity,
                      fit: BoxFit.cover,
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
                      top: 270,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Lynx Entertainment",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Afrochella",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 24),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.white,
                                size: 15,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Independence Square",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
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
    );
  }

  Widget date_calendar_widget() {
    return SingleChildScrollView(
      child: Container(
        height: 500,
        child: Card(
          elevation: 3,

          child: Container(
            height: 200,
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),

              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  // update `_focusedDay` here as well
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget popularity_widget() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            InkWell(
              onTap:(){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EventDetails()));
              },
              child: Column(

                children: [
                  SizedBox(
                    height: 20,
                  ),

                  Row(
                    children: [
                      Text("Select Rating"),
                      Row(
                        children: [
                          Icon(Icons.star, size: 20, color: Colors.yellow,),
                          Icon(Icons.star, size: 20, color: Colors.yellow,),
                          Icon(Icons.star, size: 20, color: Colors.yellow,),
                          Icon(Icons.star, size: 20, color: Colors.yellow,),
                          Icon(Icons.star_outline, size: 20, color: dark,)
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 362,
                    //color: Colors.blue,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/homeimage.png',
                          height: 362,
                          width: double.infinity,
                          fit: BoxFit.cover,
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
                          top: 270,
                          left: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Lynx Entertainment",
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Afrochella",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Independence Square",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 55,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.star, size: 20, color: Colors.yellow,),
                                      Icon(Icons.star, size: 20, color: Colors.yellow,),
                                      Icon(Icons.star, size: 20, color: Colors.yellow,),
                                      Icon(Icons.star, size: 20, color: Colors.yellow,),
                                      Icon(Icons.star_outline, size: 20, color: dark,)
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        );
      },
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
                  Text("Share Event", style: TextStyle(fontWeight: FontWeight.w700),)


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
