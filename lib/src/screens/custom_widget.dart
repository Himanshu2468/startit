import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomWidgets {
  static SizedBox sizedBox({double width = 0.0, double height = 0.0}){
    return SizedBox(
      height: height,
      width: width,
    );
  }

  static Future<String> pickDate(BuildContext context) async{
    DateTime pickDate = DateTime.now();
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 0)),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: pickDate,
    );
    if(date!=null)
    {
        pickDate=date;
        //return "${pickDate.day}-${pickDate.month}-${pickDate.year}";
        return "${pickDate.day.toString().padLeft(2, '0')}-${pickDate.month.toString().padLeft(2, '0')}-${pickDate.year}";
        //_updateProfileController.elementAt(i).text="${pickDate.day}-${pickDate.month}-${pickDate.year}";
    }else {
      return null;
    }
  }

  static Future<String> pickDate1(BuildContext context) async{
    DateTime pickDate = DateTime.now();
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year - 15,DateTime.now().month,DateTime.now().day),
      initialDate: DateTime(DateTime.now().year - 15,DateTime.now().month,DateTime.now().day),
    );
    if(date!=null)
    {
      pickDate=date;
      //return "${pickDate.day}-${pickDate.month}-${pickDate.year}";
      return "${pickDate.day.toString().padLeft(2, '0')}-${pickDate.month.toString().padLeft(2, '0')}-${pickDate.year}";
      //_updateProfileController.elementAt(i).text="${pickDate.day}-${pickDate.month}-${pickDate.year}";
    }else {
      return null;
    }
  }

  static Future<String> annyversaryDate(BuildContext context,String anny) async{
   /* DateTime annyDate = DateTime.parse(anny);*/
    int annyDate1 = int.parse(anny.split('-')[2]);

    DateTime pickDate = DateTime.now();
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(annyDate1 + 18,int.parse(anny.split('-')[1]),int.parse(anny.split('-')[0])),
      lastDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day),
      initialDate: DateTime(annyDate1 + 18,int.parse(anny.split('-')[1]),int.parse(anny.split('-')[0])),
    );
    if(date!=null)
    {
      pickDate=date;
      //return "${pickDate.day}-${pickDate.month}-${pickDate.year}";
      return "${pickDate.day.toString().padLeft(2, '0')}-${pickDate.month.toString().padLeft(2, '0')}-${pickDate.year}";
      //_updateProfileController.elementAt(i).text="${pickDate.day}-${pickDate.month}-${pickDate.year}";
    }else {
      return null;
    }
  }
  static Future<String> pickDate2(BuildContext context) async{
    DateTime pickDate = DateTime.now();
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().day),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: pickDate,
    );
    if(date!=null)
    {
      pickDate=date;
      //return "${pickDate.day}-${pickDate.month}-${pickDate.year}";
      return "${pickDate.day.toString().padLeft(2, '0')}-${pickDate.month.toString().padLeft(2, '0')}-${pickDate.year}";
      //_updateProfileController.elementAt(i).text="${pickDate.day}-${pickDate.month}-${pickDate.year}";
    }else {
      return null;
    }
  }

  static Future<String> pickTime(BuildContext context) async{
    TimeOfDay time = TimeOfDay.now();
    TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      initialTime: time,

    );
    if(timeOfDay != null)
    {
        time = timeOfDay;
        return "${timeOfDay.hour}:${timeOfDay.minute}";
    }else{
      return null;
    }
  }



 static bool CheckValidString(String value){
    if(value == null || value == "null" || value == "NULL" || value.isEmpty || value == ""){
      return false;
    }
    return true;
  }
  static String timeAgo(String de) {
    Duration diff = DateTime.now().difference(DateTime.parse(de));
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    return "just now";
  }
}