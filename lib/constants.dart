import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

const ghanaPrimary = Color(0xffce1126);
const bodyText1 = Color(0xff000000);
const bodyText2 = Color(0xff525252);
const dark = Color(0xff353535);
const backgroundColor = Color(0xffffffff);


//const hostName = "http://192.168.43.220:80";
//const socketHostName = "ws://192.168.43.220:80";


//const hostName = "http://ec2-54-91-190-234.compute-1.amazonaws.com";
//const socketHostName = "ws://ec2-54-91-190-234.compute-1.amazonaws.com";

const hostName= "https://ghanacologist.teamalfy.co.uk/api";
const socketHostName = "wss://ghanacologist.teamalfy.co.uk/api";


Future<String?> getApiPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("API_Key");
}



bool validatePhoneNumber(String phoneNumber) {
  // Regular expression for international phone number validation
  final RegExp regex = RegExp(r'^\+\d{12}$');

  return regex.hasMatch(phoneNumber);
}


bool isDateBeforeToday(String inputDate) {
  DateTime currentDate = DateTime.now();
  DateTime date = DateTime.parse(inputDate);

  // Extract only the date part from the input date
  DateTime inputDateOnly = DateTime(date.year, date.month, date.day);

  // Extract only the date part from the current date
  DateTime currentDateOnly = DateTime(currentDate.year, currentDate.month, currentDate.day);

  // Check if the input date is before today
  if (inputDateOnly.isBefore(currentDateOnly)) {
    return true;
  } else {
    return false;
  }
}







String formatDateTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  DateFormat formatter = DateFormat('y-MM-dd');
  String formattedDateTime = formatter.format(dateTime);
  return formattedDateTime;
}

