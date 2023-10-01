import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghanacologist/Screens/UserProfile/user_profile.dart';
import 'package:ghanacologist/constants.dart';

class ShopDetails extends StatefulWidget {
  final data;
  const ShopDetails({Key? key, required this.data}) : super(key: key);

  @override
  State<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 2,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Container(
                             // margin: EdgeInsets.symmetric(vertical: 10),

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
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            color: Colors.black,
                            child: Container(
                              child: Stack(
                                children: [
                                  Image.network(
                                    widget.data.photo.toString(),
                                    height: 379,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    height: 379,
                                    width: double.infinity,
                                    decoration: BoxDecoration(

                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.9),
                                          ],
                                        )),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        )

                      ],
                    )
                ),
                Expanded(
                  flex: 1,
                  child:Container()
                )
              ],
            ),
            Image(
              width: double.infinity,
                image: AssetImage('assets/images/gradient-background.png'),fit: BoxFit.cover,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.only(top: 60),
                      padding: EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Icon(
                                Icons.arrow_back, color: dark, size: 18,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100)
                              ),
                              child: Icon(
                                Icons.bookmark, color: dark, size: 18,
                              ),
                            ),
                          ),

                        ],
                      ),

                    )
                ),
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                      //height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              dark.withOpacity(1),
                              dark.withOpacity(0.9)
                            ],
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data.name.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 32),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.data.phone.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),


                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(

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
                                      Expanded(
                                        child: Text(
                                          widget.data.url.toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(

                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                      color: ghanaPrimary,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Center(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 35,
                                        ),
                                        Icon(
                                          Icons.add_shopping_cart,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Add to cart",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          Text(
                            "About",
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.data.description.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 10,),
                          ),


                          SizedBox(
                            height: 20,
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
                            height: 30,
                          ),

                        ],
                      ),
                    ),
                  ),
                )
              ],
            )


          ]
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


