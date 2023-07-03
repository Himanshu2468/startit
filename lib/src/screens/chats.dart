import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:startit/src/screens/add_ins_group.dart';
import 'package:startit/src/screens/fullScreenImage.dart';
import 'package:startit/src/screens/videoPlayerWidget.dart';
import 'package:emoji_picker/emoji_picker.dart';
import '../screens/chat_firebaseMessage.dart';
import '../services/WebApis.dart';
import '../services/WebResponseExtractor.dart';
import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:dio/dio.dart';
//import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:selectable_autolink_text/selectable_autolink_text.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../main.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:video_thumbnail_generator/video_thumbnail_generator.dart';
import 'custom_widget.dart';

FirebaseUser loggedInUser;
final _firestore = FirebaseFirestore.instance;
String receiverId;
String currentId;
Uint8List bytes;
String gs;
String catches = "";
String thumbnailPath;
List<String> selectIndex = [];
List<String> fileUrl = [];
List<String> message = [];
int countMessage = 0;
List<String> userTokenIdList = [];
List<Map<String, dynamic>> forwardMessage = [];
List<Map<String, dynamic>> shareContent = [];

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  var data;

  ChatScreen([this.data]);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  FilePickerResult file;
  bool showEmojiKeyboard = false;

  bool showEmojiPicker = false;
  FocusNode textFieldFocus = FocusNode();
  List list = [];
  String id = '';
  String fileType = '';
  String fileName = '';
  String thumbnailPath;
  String basename;
  List<String> imageId = [];
  List<String> userFirebaseIdList = [];
  DocumentReference documentReference1;
  final Dio _dio = Dio();
  String url =
      'https://cdn3.iconfinder.com/data/icons/sympletts-part-10/128/user-man-plus-512.png';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String senderDeviceToken = "";
  String receiverDeviceToken = "";
  bool isDeleted = true;

  Map<String, dynamic> de;
  @override
  void initState() {
    super.initState();
    receiverId = widget.data['id'];
    selectIndex.clear();
    forwardMessage.clear();
    fileUrl.clear();
    message.clear();
    shareContent.clear();
    print("sdhjhj:" + widget.data['name'].toString());
    print("userFirebaseId:" + userFirebaseId.toString());
    if (widget.data["chat"] == "user")
      getTokenSenderReceiver(userFirebaseId, true);
    // final android = AndroidInitializationSettings('app_icon');
    // final iOS = IOSInitializationSettings();
    // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // final initSettings = InitializationSettings(android:android,iOS: iOS);

    // flutterLocalNotificationsPlugin.initialize(initSettings,
    //     onSelectNotification: _onSelectNotification);
    setState(() {
      // if(widget.data['chat']== "user" ) {

      //   getCountMessage();
      //   // if(widget.data['totalMessage'])
      //   // {
      //   //   countMessage = int.parse(widget.data['totalMessage']);

      //   // }

      //   documentReference1 = FirebaseFirestore.instance.collection(
      //       'user/$userFirebaseId/recentMessage')
      //       .doc(widget.data['receiverId']);
      //   documentReference1.update(
      //       {
      //         'totalMessage':"",
      //         'seenMessage': 'Yes',
      //       }

      //   );

      // //  countMessage = 0;
      // }
      // else
      // {
      //   documentReference1 = FirebaseFirestore.instance.collection(
      //       'user/$userFirebaseId/recentMessage')
      //       .doc(widget.data['receiverId']);
      //   documentReference1.update(
      //       {
      //         'totalMessage':"",
      //         'seenMessage': 'Yes',
      //       }

      //   );

      if (widget.data["chat"] == "group")
        fetchCommitteeMemberData(widget.data['id']);

      // }
    });
  }

  Future<void> onGoBack(dynamic value) {
    fetchCommitteeMemberData("");
    setState(() {});
    // return;
  }

  void deleteMemberIns(String ids) async {
    Map mapData = {
      "group_fire_base_id": widget.data['receiverId'].toString(),
      "user_id": userIdMain.toString()
    };
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.DELETE_MEMBER_GROUP),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "RETURN_MESSAGE");
      if (data["code"] == 1) {
        print(data["data"]);
        WebResponseExtractor.showToast(data["data"].toString());
        // print(getProfileData(ids));
        // print("hgas");
        // String reciever = await getProfileData(ids);
        // print(reciever);
        DocumentReference documentReference1;
        documentReference1 = FirebaseFirestore.instance
            .collection('user/${userFirebaseId.toString()}/recentMessage')
            .doc(widget.data['receiverId']);
        documentReference1.delete();
        // fetchCommitteeMemberData('');
        // getInvestorsFromWeb(data["data"]);
      }
    }
  }

  Future<String> getProfileData(String userid) async {
    Map mapData = {"user_id": userid};
    print(mapData);
    final response = await http.post(
      Uri.parse(WebApis.VIEW_PROFILE),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);
    final jsonData = jsonDecode(response.body) as Map;
    if (response.statusCode == 200) {
      if (jsonData["RETURN_CODE"] == 1) {
        // Map data =
        //     WebResponseExtractor.filterWebData(response, dataObject: "DETAILS");
        Map data1 = WebResponseExtractor.filterWebData(response,
            dataObject: "USER_DATA");

        var userData = data1["data"];
        print("Heelo" + userData["firebase_user_id"]);
        // var userData1 = data["data"];

        // countryID = userData["country"];
        //countryName = userData["country_name"];
        // print(countryID);
        // countryDropDown =
        //     countriesList.firstWhere((element) => element.ID == countryID);
        // countryName = countryDropDown.NAME;

        // await getState();

        // stateID = userData["state"];
        // //stateName = userData["state_name"];
        // print(stateID);
        // stateDropDown =
        //     stateList.firstWhere((element) => element.ID == stateID);
        // stateName = stateDropDown.NAME;

        // await getCity();

        // cityID = userData["city"];
        // //cityName = userData["city_name"];
        // print(cityID);
        // cityDropDown = cityList.firstWhere((element) => element.ID == cityID);
        // cityName = cityDropDown.NAME;

        setState(() {
          // image =
          // profileImageMain = userData["profile_image"] != null
          //     ? userData["profile_image"]
          //     : "";
          // location = "${userData["city_name"]}, ${userData["state_name"]}";
          // dob = userData["dob"];
          // gender = userData["gender"] != null ? userData["gender"] : "";
          // bulbColor = gender;

          // _selectedDate = (DateTime.parse(userData["dob"]));

          // pincodeController.text = userData["pincode"];

          // occupation = userData["what_do_you_do"] != null
          //     ? userData["what_do_you_do"]
          //     : "";

          // if (occupation == "Job") {
          //   screenNo = 1;
          //   jobRadio = 'Job';
          //   employmentTypeID = userData["mst_employement_type_id"];
          //   employmentTypeDropDown = employmentTypeList
          //       .firstWhere((element) => element.ID == employmentTypeID);
          //   employment = employmentTypeDropDown.NAME;
          //   createUserController1.text = userData["job_title"];
          // }

          // if (occupation == "Student") {
          //   screenNo = 2;
          //   tradeRadio = 'Student';
          //   tradeTypeID = userData["mst_trade_id"];
          //   tradeDropDown =
          //       tradeList.firstWhere((element) => element.ID == tradeTypeID);
          //   trade = tradeDropDown.NAME;
          //   createUserController2.text = userData["university_or_school_name"];
          // }

          // if (occupation == "Self Employed") {
          //   screenNo = 3;
          //   natureRadio = 'Self Employed';
          //   nOfWorkID = userData["mst_nature_of_work_id"];
          //   natureOfWork = natureOfWorkList
          //       .firstWhere((element) => element.ID == nOfWorkID);
          //   nOfWork = natureOfWork.NAME;
          //   createUserController3.text = userData["work_title"];
          // }

          // if (occupation == "Business") {
          //   screenNo = 4;
          //   businessRadio = 'Business';
          //   businessTypeID = userData["mst_occupation_business_id"];
          //   businessDropDown = businessList
          //       .firstWhere((element) => element.ID == businessTypeID);
          //   business1 = businessDropDown.NAME;
          // }
        });
        return userData["firebase_user_id"];
      }
    }
  }

  fetchCommitteeMemberData(String committeeId) async {
    try {
      Map data = {"group_fire_base_id": widget.data["receiverId"]};
      final response = await http.post(
        WebApis.GET_CHAT_GROUP,
        body: json.encode(data),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
      );
      if (response.statusCode == 200) {
        Map data = WebResponseExtractor.filterWebData(response,
            dataObject: 'GROUP_DETAILS');

        if (data["code"] == 1) {
          userFirebaseIdList.clear();
          userTokenIdList.clear();
          List<String> userids = [];
          var jsonData = data["data"];
          userids = jsonData["user_ids"] != null
              ? jsonData["user_ids"].toString().split(",")
              : [];
          print(userids.toString());
          for (int i = 0; i < userids.length; i++) {
            print(i);
            getFireIds(userids[i]);
          }

          // for (int i = 0; i < data['data'].length; i++) {
          //   if (data['data'][i]['firebase_userid'] != null &&
          //       data['data'][i]['firebase_userid'] != "" &&
          //       data['data'][i]['firebase_userid'] != "null") {
          //     userFirebaseIdList.add(data['data'][i]['firebase_userid']);
          //   }
          //   if (CustomWidgets.CheckValidString(
          //       data['data'][i]['device_token'].toString())) {
          //     if (data['data'][i]['device_token'].toString() !=
          //         userDeviceToken) {
          //       userTokenIdList.add(data['data'][i]['device_token'].toString());
          //     }
          //   }
          //   //print("List:"+data['data'][i]['device_token'].toString());
          // }

          // List<Map<String,dynamic>> membersList= data['data'];
          // print("committee data:"+data['data'].toStri

        } else {
          return null;
        }
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      print(e + " Getting some issue try again later");
      return null;
    }
  }

  Future<void> getFireIds(String ids) async {
    Map data = {"user_id": ids};
    final response = await http.post(
      WebApis.VIEW_PROFILE,
      body: json.encode(data),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      Map data =
          WebResponseExtractor.filterWebData(response, dataObject: 'USER_DATA');

      if (data["code"] == 1) {
        // userFirebaseIdList.clear();
        // userTokenIdList.clear();
        // List<String> userids = [];
        var jsonData = data["data"];
        print(jsonData);
        getTokenSenderReceiver(jsonData["firebase_user_id"].toString(), false);
        if (jsonData["firebase_user_id"] != null &&
            jsonData["firebase_user_id"] != "")
          userFirebaseIdList.add(jsonData["firebase_user_id"]);
        // userFirebaseIdList.add("LUurrED6JuNybCH5E8b6sdsdyHD3");
        print(userFirebaseIdList.toString());
      }
    }
  }

  Future<void> _onSelectNotification(String json) async {
    final obj = de;
    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
            'Error',
            textScaleFactor: 1,
          ),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  void getTokenSenderReceiver([String usernewfirebase, bool check]) async {
    Map mapData = {
      "senderFirebaseId": usernewfirebase,
      "receiverFirebaseId": check ? widget.data["receiverId"] : ""
    };
    print(mapData);
    final response = await http.post(
      Uri.parse(WebApis.GET_TOKEN_SENDER_RECEIVER),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);
    final jsonData = jsonDecode(response.body) as Map;
    if (response.statusCode == 200) {
      if (jsonData["RETURN_CODE"] == 1) {
        setState(() {
          senderDeviceToken =
              jsonData["SENDER_TOKEN"] != null ? jsonData["SENDER_TOKEN"] : "";
          if (check == false) userTokenIdList.add(senderDeviceToken);
          jsonData["SENDER_TOKEN"] != null ? jsonData["SENDER_TOKEN"] : "";
          receiverDeviceToken = jsonData["RECEIVER_TOKEN"] != null
              ? jsonData["RECEIVER_TOKEN"]
              : "";
          // print(senderDeviceToken);
          // print("dsds" + receiverDeviceToken);
        });
      }
    }
  }

  Future<bool> _requestPermissions() async {
    var permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }

    return permission == PermissionStatus.granted;
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await getApplicationDocumentsDirectory();
      //return await DownloadsPathProvider.downloadsDirectory;
    }

    // in this example we are using only Android and iOS so I can assume
    // that you are not trying it for other platforms and the if statement
    // for iOS is unnecessary

    // iOS directory visible to user
    return await getApplicationDocumentsDirectory();
  }

  Future<void> _startDownload(String savePath, String _fileUrl) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await _dio.download(_fileUrl, savePath,
          onReceiveProgress: _onReceiveProgress);
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
      de = result;
    } catch (ex) {
      de['error'] = ex.toString();
      result['error'] = ex.toString();
    } finally {
      await _showNotification();
    }
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        // _progress = (received / total * 100).toStringAsFixed(0) + "%";
        //print("Downloading...."+_progress.toString());
        //vr = "Downloading .... ";
        //downloadBar = true;
        // value = _progress.toString();
        /* if (_progress == "100%") {
          value = "";
          vr = "Download Successful";
          downloadBar = false;

        }*/
      });
      //WebResponseExtractor.showToast("Downloaded Successfully");
    }
  }

  Future<void> _showNotification() async {
    final android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: Priority.high, importance: Importance.max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(de);
    final isSuccess = de['isSuccess'];
    print("download status:" + de.toString());

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'File has been downloaded successfully!'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
  }

  Future<void> _download(String _fileUrl) async {
    final dir = await _getDownloadDirectory();
    final isPermissionStatusGranted = await _requestPermissions();

    if (isPermissionStatusGranted) {
      final savePath = path.join(dir.path, path.basename(_fileUrl));
      await _startDownload(savePath, _fileUrl);
    } else {
      // handle the scenario when user declines the permissions
    }
  }

  Future<String> getCountMessage() async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('user')
        .doc(widget.data['receiverId'])
        .collection("recentMessage")
        .doc(userFirebaseId);
    String specie;
    await documentReference.get().then((snapshot) {
      // countMessage = CustomWidgets.CheckValidString(snapshot.data()['totalMessage'].toString()) ? int.parse(snapshot.data()['totalMessage'].toString()) : 0;
    });
    return specie;
  }

  // void getCurrentUser() async {
  //   try {
  //     final user = await _auth.currentUser();
  //     if (user != null) {
  //       loggedInUser = user;
  //       currentId = loggedInUser.uid;
  //     }
  //   } catch (e) {}
  // }

  final sendMsg = TextEditingController();

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  Future filePicker(BuildContext context) async {
    try {
      if (fileType == 'image') {
        FilePickerResult result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );

        if (result != null) {
          File file = File(result.files.single.path);
          setState(() {
            fileName = p.basename(file.path);
            basename = p.basename(file.path);
            _uploadFile(file, fileName);
          });
        } else {
          // User canceled the picker
        }

        // file = await FilePicker.getFile(type: FileType.image);

      }
      if (fileType == 'video') {
        FilePickerResult result = await FilePicker.platform.pickFiles(
          type: FileType.video,
        );

        if (result != null) {
          File file = File(result.files.single.path);
          setState(() {
            fileName = p.basename(file.path);
            basename = p.basename(file.path);
            _uploadFile(file, fileName);
          });
        } else {
          // User canceled the picker
        }

        // file = await FilePicker.getFile(type: FileType.image);

      }
      if (fileType == 'file') {
        FilePickerResult result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: [
              'pdf',
              'doc',
              'docx',
              'xls',
              'xlsx',
              'ppt',
              'pptx'
            ]);

        if (result != null) {
          File file = File(result.files.single.path);
          setState(() {
            fileName = p.basename(file.path);
            basename = p.basename(file.path);
            _uploadFile(file, fileName);
          });
        } else {
          // User canceled the picker
        }

        // file = await FilePicker.getFile(type: FileType.image);

      }
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Sorry...',
                textScaleFactor: 1,
              ),
              content: Text(
                'Unsupported exception: $e',
                textScaleFactor: 1,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'OK',
                    textScaleFactor: 1,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  Future<void> _uploadFile(File file, String filename) async {
    FirebaseStorage storageReference = FirebaseStorage.instance;
    Reference ref;
    if (fileType == 'image') {
      ref = storageReference
          .ref()
          .child('images/${widget.data['id']}')
          .child("images/$filename");
    }
    if (fileType == 'audio') {
      ref = storageReference
          .ref()
          .child('images/${widget.data['id']}')
          .child("audio/$filename");
    }
    if (fileType == 'video') {
      ref = storageReference
          .ref()
          .child('images/${widget.data['id']}')
          .child("videos/$filename");
    }
    if (fileType == 'file') {
      print("file name:" + filename);
      ref = storageReference
          .ref()
          .child('images/${widget.data['id']}')
          .child("pdf/$filename");
    }
    if (fileType == 'pdf') {
      print("file name:" + filename);
      ref = storageReference
          .ref()
          .child('images/${widget.data['id']}')
          .child("pdf/$filename");
    }
    if (fileType == 'others') {
      ref = storageReference
          .ref()
          .child('images/${widget.data['id']}')
          .child("others/$filename");
    }
    String formattedDate;

    setState(() {
      countMessage = countMessage + 1;
      DateTime now = DateTime.now();
      formattedDate = now.millisecondsSinceEpoch.toString();
    });
    final UploadTask uploadTask = ref.putFile(file);
    DocumentReference documentReference;
    if (widget.data['chat'] == "user") {
      FirebaseMessage.sendNotification(
          sendMsg.text, receiverDeviceToken, fileType);
      documentReference = FirebaseFirestore.instance
          .collection('messages/$userFirebaseId/${widget.data['receiverId']}')
          .doc();
      documentReference.set({
        "documentId": documentReference.id,
        'Name': widget.data['name'],
        'ProfileImage': widget.data['userProfileImage'],
        'Id': widget.data['receiverId'],
        'SenderName': name,
        'SenderProfileImage': profileImageMain,
        'SenderId': userFirebaseId,
        'Message': "",
        'url': "",
        'fileName': basename,
        'timestamp': formattedDate,
        'DateAndTime': DateTime.now().toString(),
        'messageType': fileType,
        'totalMessage': '$countMessage',
        'seenMessage': '',
        'messageTo': "user",
        'forwardMessage': "no"
      });
      imageId.add(documentReference.id.toString());
      documentReference = FirebaseFirestore.instance
          .collection('messages/${widget.data['receiverId']}/$userFirebaseId')
          .doc(imageId[0]);
      documentReference.set({
        "documentId": imageId[0],
        'Name': name,
        'ProfileImage': profileImageMain,
        'Id': userFirebaseId,
        'SenderName': name,
        'SenderProfileImage': profileImageMain,
        'SenderId': userFirebaseId,
        'Message': "",
        'url': "",
        'fileName': basename,
        'timestamp': formattedDate,
        'DateAndTime': DateTime.now().toString(),
        'messageType': fileType,
        'totalMessage': '$countMessage',
        'seenMessage': '',
        'messageTo': "user",
        'forwardMessage': "no"
      });

      documentReference1 = FirebaseFirestore.instance
          .collection('user/$userFirebaseId/recentMessage')
          .doc(widget.data['receiverId']);
      documentReference1.set({
        "documentId": documentReference1.id,
        'Name': widget.data['name'],
        'ProfileImage': widget.data['userProfileImage'],
        'Id': widget.data['receiverId'],
        'SenderName': name,
        'SenderProfileImage': profileImageMain,
        'SenderId': userFirebaseId,
        'deviceToken': receiverDeviceToken,
        'Message': "",
        'fileName': basename,
        'url': "",
        'timestamp': formattedDate,
        'DateAndTime': DateTime.now().toString(),
        'messageType': fileType,
        'totalMessage': '$countMessage',
        'seenMessage': '',
        'messageTo': "user",
        'forwardMessage': "no"
      });
      documentReference1 = FirebaseFirestore.instance
          .collection('user/${widget.data['receiverId']}/recentMessage')
          .doc(userFirebaseId);
      documentReference1.set({
        "documentId": documentReference1.id,
        'Name': name,
        'ProfileImage': profileImageMain,
        'Id': userFirebaseId,
        'SenderName': name,
        'SenderProfileImage': profileImageMain,
        'SenderId': userFirebaseId,
        'deviceToken': senderDeviceToken,
        'Message': "",
        'url': "",
        'fileName': basename,
        'timestamp': formattedDate,
        'DateAndTime': DateTime.now().toString(),
        'messageType': fileType,
        'totalMessage': '$countMessage',
        'seenMessage': '',
        'messageTo': "user",
        'forwardMessage': "no"
      });
    } else {
      FirebaseMessage.sendNotificationToGroup(
          sendMsg.text, widget.data['deviceToken'], fileType, userTokenIdList);
      for (int i = 0; i < userFirebaseIdList.length; i++) {
        DocumentReference documentReferences = FirebaseFirestore.instance
            .collection(
                'messages/${userFirebaseIdList[i]}/${widget.data['receiverId']}')
            .doc();
        documentReferences.set({
          'documentId': documentReferences.id,
          'Name': widget.data['name'],
          'ProfileImage': widget.data['userProfileImage'],
          'Id': widget.data['receiverId'],
          'SenderName': name,
          'SenderProfileImage': profileImageMain,
          'SenderId': userFirebaseId,
          'Message': sendMsg.text,
          'url': "",
          'timestamp': formattedDate,
          'DateAndTime': DateTime.now().toString(),
          'messageType': fileType,
          'fileName': basename,
          'totalMessage':
              userFirebaseIdList[i] != userFirebaseId ? '$countMessage' : "",
          'seenMessage': '',
          "group_id": widget.data['idea_id'],
          'messageTo': "group",
          'forwardMessage': "no",
          "removedMemberId": "",
          "adminId": widget.data["adminId"]
        });
        imageId.add(documentReferences.id.toString());
      }
    }

    await uploadTask.whenComplete(() {
      ref.getDownloadURL().then((fileUrl) {
        setState(() {
          // url = fileUrl;
          if (widget.data['chat'] == "group") {
            for (int i = 0; i < userFirebaseIdList.length; i++) {
              DocumentReference documentReferences = FirebaseFirestore.instance
                  .collection(
                      'messages/${userFirebaseIdList[i]}/${widget.data['receiverId']}')
                  .doc(imageId[i]);
              documentReferences.update({
                'documentId': imageId[i],
                'Name': widget.data['name'],
                'ProfileImage': widget.data['userProfileImage'],
                'Id': widget.data['receiverId'],
                'SenderName': name,
                'SenderProfileImage': profileImageMain,
                'SenderId': userFirebaseId,
                'Message': sendMsg.text,
                'url': fileUrl,
                'timestamp': formattedDate,
                'DateAndTime': DateTime.now().toString(),
                'messageType': fileType,
                'fileName': basename,
                'totalMessage': userFirebaseIdList[i] != userFirebaseId
                    ? '$countMessage'
                    : "",
                'seenMessage': '',
                "group_id": widget.data['idea_id'],
                'messageTo': "group",
                'forwardMessage': "no",
                "removedMemberId": "",
                "adminId": widget.data["adminId"]
              });
              documentReference1 = FirebaseFirestore.instance
                  .collection('user/${userFirebaseIdList[i]}/recentMessage')
                  .doc(widget.data['receiverId']);
              documentReference1.set({
                "documentId": documentReference1.id,
                'Name': widget.data['name'],
                'ProfileImage': widget.data['userProfileImage'],
                'Id': widget.data['receiverId'],
                'SenderName': name,
                'SenderProfileImage': profileImageMain,
                'SenderId': userFirebaseId,
                'Message': "",
                'url': "",
                'fileName': basename,
                'timestamp': formattedDate,
                'DateAndTime': DateTime.now().toString(),
                'messageType': fileType,
                'totalMessage': userFirebaseIdList[i] != userFirebaseId
                    ? '$countMessage'
                    : "",
                'seenMessage': '',
                "group_id": widget.data['idea_id'],
                'messageTo': "group",
                'forwardMessage': "no",
                "adminId": widget.data["adminId"]
              });
            }
            imageId.clear();
          } else {
            DocumentReference documentReferences;
            documentReferences = FirebaseFirestore.instance
                .collection(
                    'messages/$userFirebaseId/${widget.data['receiverId']}')
                .doc(imageId[0]);
            documentReferences.update({
              "documentId": imageId[0],
              'Name': widget.data['name'],
              'ProfileImage': widget.data['userProfileImage'],
              'Id': widget.data['receiverId'],
              'SenderName': name,
              'SenderProfileImage': profileImageMain,
              'SenderId': userFirebaseId,
              'Message': "",
              'url': fileUrl,
              'fileName': basename,
              'timestamp': formattedDate,
              'DateAndTime': DateTime.now().toString(),
              'messageType': fileType,
              'totalMessage': '$countMessage',
              'seenMessage': '',
              'messageTo': "user",
              'forwardMessage': "no"
            });
            documentReferences = FirebaseFirestore.instance
                .collection(
                    'messages/${widget.data['receiverId']}/$userFirebaseId')
                .doc(imageId[0]);
            documentReferences.update({
              "documentId": imageId[0],
              'Name': name,
              'ProfileImage': profileImageMain,
              'Id': userFirebaseId,
              'SenderName': name,
              'SenderProfileImage': profileImageMain,
              'SenderId': userFirebaseId,
              'Message': "",
              'url': fileUrl,
              'fileName': basename,
              'timestamp': formattedDate,
              'DateAndTime': DateTime.now().toString(),
              'messageType': fileType,
              'totalMessage': '$countMessage',
              'seenMessage': '',
              'messageTo': "user",
              'forwardMessage': "no"
            });
            print("url2:" + url.toString());
            imageId.clear();
          }
        });
      });
    });
    print("Url1" + url);
    // }

    /* _FirebaseFirestore
        .collection(
        'message/${widget.data['userId']}/${widget.data['receiverId']}')
        .add({
      'Name': name,
      'SenderName': widget.data['name'],
      'Message': 'text',
      'image_url': url,
      'SenderId': widget.data['userId'],
      'ReceiverId': widget.data['receiverId'],
      'time': formattedDate,
      'messageType': fileType
    });
    _FirebaseFirestore
        .collection(
        'message/${widget.data['receiverId']}/${widget.data['userId']}')
        .add({
      'Name': name,
      'SenderName': widget.data['name'],
      'Message': 'text',
      'image_url': url,
      'SenderId': widget.data['userId'],
      'ReceiverId': widget.data['receiverId'],
      'time': formattedDate,
      'messageType': fileType,
    });*/
  }

  downloadFile(String fileUrl) async {
    final Directory downloadsDirectory =
        await DownloadsPathProvider.downloadsDirectory;
    final String downloadsPath = downloadsDirectory.path;
    await FlutterDownloader.enqueue(
      url: fileUrl,
      savedDir: downloadsPath,
      showNotification: true,
      // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }

  @override
  Widget build(BuildContext context) {
    // String userId;

    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        documentReference1 = FirebaseFirestore.instance
            .collection('user/$userFirebaseId/recentMessage')
            .doc(widget.data['receiverId']);
        documentReference1.update({
          'totalMessage': "",
          'seenMessage': 'Yes',
        });
        Navigator.of(context).pop();
        return;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],

        appBar: AppBar(
          toolbarHeight: 70,
          elevation: 4,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          // leadingWidth: 1000,
          // leading: Icon(Icons.alarm),
          actions: [
            // if (widget.data["chat"] == "group")
            //   TextButton(
            //       onPressed: () {

            //       },
            //       child: Text("INS",
            //           style: TextStyle(fontSize: 15, color: Colors.black))),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                showMaterialModalBottomSheet(
                  context: context,
                  builder: (context) => SingleChildScrollView(
                    controller: ModalScrollController.of(context),
                    child: Container(
                      child: Column(
                        children: [
                          // message.length > 0
                          //     ? ListTile(
                          //         leading: Icon(
                          //           Icons.arrow_forward_ios_outlined,
                          //           color: Colors.black,
                          //         ),
                          //         title: Text('Forward'),
                          //         onTap: () {
                          //           Navigator.of(context).pushNamed('/chat',
                          //               arguments: forwardMessage);
                          //         })
                          //     : SizedBox(),
                          // fileUrl.length == 1
                          //     ? ListTile(
                          //         leading: Icon(
                          //           Icons.arrow_circle_down,
                          //           color: Colors.black,
                          //         ),
                          //         title: Text('Download'),
                          //         onTap: () async {
                          //           _download(fileUrl.first);
                          //           Navigator.pop(context);
                          //         },
                          //       )
                          //     : SizedBox(),
                          message.length > 0
                              ? ListTile(
                                  leading: Icon(
                                    Icons.copy_outlined,
                                    color: Colors.black,
                                  ),
                                  title: Text(
                                    'Copy',
                                    textScaleFactor: 1,
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      String copyText = message.join("\n");

                                      Clipboard.setData(
                                          new ClipboardData(text: "$copyText"));
                                    });

                                    Navigator.pop(context);
                                  })
                              : SizedBox(),
                          shareContent.length > 0
                              ? ListTile(
                                  leading: Icon(
                                    Icons.share,
                                    color: Colors.black,
                                  ),
                                  title: Text(
                                    'Share',
                                    textScaleFactor: 1,
                                  ),
                                  onTap: () async {
                                    print("share content:" +
                                        shareContent.toString());
                                    saveAndShare(shareContent);
                                    Navigator.pop(context);
                                  },
                                )
                              : SizedBox(),
                          // selectIndex.length > 0
                          //     ? ListTile(
                          //         leading: Icon(
                          //           Icons.delete,
                          //           color: Colors.black,
                          //         ),
                          //         title: Text('Delete Chat'),
                          //         onTap: () {
                          //           Navigator.pop(context);
                          //           _deleteChat();
                          //         })
                          //     : SizedBox(),
                          if (widget.data["chat"] == "group")
                            ListTile(
                                leading: Icon(
                                  Icons.info_outline_rounded,
                                  color: Colors.black,
                                ),
                                title: Text(
                                  'Group Details',
                                  textScaleFactor: 1,
                                ),
                                onTap: () {
                                  if (widget.data["adminId"] == userFirebaseId)
                                    Navigator.of(context)
                                        .pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) => AddInsGroup(
                                                  widget.data["idea_id"]
                                                      .toString(),
                                                  widget.data["receiverId"]
                                                      .toString(),
                                                  true,
                                                  widget.data,
                                                  userFirebaseIdList)),
                                        )
                                        .then(onGoBack);
                                  else
                                    Navigator.of(context)
                                        .push(
                                          MaterialPageRoute(
                                              builder: (context) => AddInsGroup(
                                                  widget.data["idea_id"]
                                                      .toString(),
                                                  widget.data["receiverId"]
                                                      .toString(),
                                                  false,
                                                  widget.data,
                                                  userFirebaseIdList)),
                                        )
                                        .then(onGoBack);
                                }),
                          //      if (widget.data["chat"] == "group"&&widget.data["adminId"] != userFirebaseId)
                          // ListTile(
                          //     leading: Icon(
                          //       Icons.add,
                          //       color: Colors.black,
                          //     ),
                          //     title: Text('Add Me'),
                          //     onTap: () {
                          //       if (widget.data["adminId"] == userFirebaseId)
                          //         Navigator.of(context).pushReplacement(
                          //           MaterialPageRoute(
                          //               builder: (context) => AddInsGroup(
                          //                   widget.data["idea_id"].toString(),
                          //                   widget.data["receiverId"]
                          //                       .toString(),
                          //                   true,
                          //                   widget.data,
                          //                   userFirebaseIdList)),
                          //         );
                          //       else
                          //         Navigator.of(context).push(
                          //           MaterialPageRoute(
                          //               builder: (context) => AddInsGroup(
                          //                   widget.data["idea_id"].toString(),
                          //                   widget.data["receiverId"]
                          //                       .toString(),
                          //                   false,
                          //                   widget.data,
                          //                   userFirebaseIdList)),
                          //         );
                          //     }),
                          // if (widget.data["chat"] == "group")
                          //   ListTile(
                          //       leading: Icon(
                          //         Icons.settings,
                          //         color: Colors.black,
                          //       ),
                          //       title: Text('Group Settings'),
                          //       onTap: () {
                          //         Navigator.of(context).pushNamed("routeName");
                          //       }),
                          ListTile(
                              leading: Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                              title: Text(
                                'Clear All Chat',
                                textScaleFactor: 1,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                _deleteAllChat();
                              }),
                          if (widget.data["chat"] == "group" &&
                              widget.data["adminId"] != userFirebaseId)
                            ListTile(
                                leading: Icon(
                                  Icons.exit_to_app,
                                  color: Colors.black,
                                ),
                                title: Text(
                                  'Leave Group',
                                  textScaleFactor: 1,
                                ),
                                onTap: () {
                                  return showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return AlertDialog(
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "No",
                                                  textScaleFactor: 1,
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  deleteMemberIns(
                                                      userIdMain.toString());
                                                  Navigator.of(context).pop();
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Yes",
                                                  textScaleFactor: 1,
                                                )),
                                          ],
                                          content: Text(
                                            "Are you sure ?",
                                            textScaleFactor: 1,
                                          ),
                                        );
                                      });
                                }),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.only(right: 18),
                child: Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
              ),
            ),
          ],
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  // CircleAvatar(
                  //   backgroundImage: NetworkImage(
                  //       "<https://randomuser.me/api/portraits/men/5.jpg>"),
                  //   maxRadius: 20,
                  // ),
                  Container(
                    width: 50,
                    height: 50,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      // shadowColor: ThemeColors.shadowColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: CachedNetworkImage(
                          imageUrl: CustomWidgets.CheckValidString(
                                  widget.data['userProfileImage'])
                              ? "http://164.52.192.76:8080/startit/" +
                                  widget.data['userProfileImage']
                              : "http://164.52.192.76:8080/Tchrtalk/img/profile-image.jpg",
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) => new Image.asset(
                            "/assets/images/startitsplash.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.data['name'],
                          textScaleFactor: 1,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 1.0),
                        ),
                      ],
                    ),
                  ),
                  // Icon(
                  //   Icons.settings,
                  //   color: Colors.black54,
                  // ),
                ],
              ),
            ),
          ),
        ),

        // backgroundColor: ThemeColors.appbarColor,
        // appBar: AppBarWidget.centerTitleAppbar(context, 'Chat'),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            // padding: EdgeInsets.only(top: mediaQueryHeight * 0.005),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: chatScreen(),
                  ),
                ),
                showEmojiPicker
                    ? Container(
                        child: emojiContainer(),
                      )
                    : Container(),
                Container(
                  height: 60,
                  // height: MediaQuery.of(context).size.height * 0.1,
                  width: mediaQueryWidth,
                  child: Column(
                    children: [
                      Container(
                        height: 1,
                        width: mediaQueryWidth,
                        color: Colors.grey,
                      ),
                      // CustomWidgets.sizedBox(height: 10.0),
                      if (isDeleted == true)
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Container(
                                    width: mediaQueryWidth,
                                    //height: mediaQueryHeight * 0.055,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Colors.grey[100],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons
                                                      .sentiment_satisfied_alt_outlined,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  hideKeyboard();
                                                  showEmojiContainer();
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                })),
                                        Expanded(
                                          child: TextField(
                                            onTap: () {
                                              showKeyboard();
                                              hideEmojiContainer();
                                            },
                                            controller: sendMsg,
                                            // enabled: isDeleted,
                                            minLines: 1,
                                            maxLines: 5,
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              border: InputBorder.none,
                                              hintText: "Write message...",
                                              hintStyle: TextStyle(
                                                  color: Colors.black54),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.attach_file),
                                          onPressed: () {
                                            showAttachmentBottomSheet(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.send_outlined,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () async {
                                      if (sendMsg.text.isNotEmpty) {
                                        DocumentReference documentReference1;

                                        setState(() {
                                          countMessage = countMessage + 1;
                                          DateTime nows = DateTime.now();

                                          String formattedDate = nows
                                              .millisecondsSinceEpoch
                                              .toString();

                                          /*DateFormat('yyyy-MM-dd hh:mm:ss')
                                              .format(nows);*/
                                          /* FirebaseFirestore.instance
                                              .collection("message")
                                              .doc(widget.data['userId'])
                                              .collection(
                                            widget.data['receiverId'],
                                          )
                                              .add({
                                            "SenderId": widget.data['userId'],
                                            "ReceiverId": widget.data['receiverId'],
                                            "Message": sendMsg.text,
                                            "time": formattedDate,
                                            'messageType': 'text',
                                            'image_url': 'url',
                                          });
                                          FirebaseFirestore.instance
                                              .collection("message")
                                              .doc(widget.data['receiverId'])
                                              .collection(widget.data['userId'])
                                              .add({
                                            "SenderId": widget.data['userId'],
                                            "ReceiverId": widget.data['receiverId'],
                                            "Message": sendMsg.text,
                                            "time": formattedDate,
                                            'messageType': 'text',
                                            'image_url': 'url',
                                          });*/
                                          if (widget.data['chat'] == "user") {
                                            FirebaseMessage.sendNotification(
                                                sendMsg.text,
                                                receiverDeviceToken,
                                                "message");

                                            documentReference1 =
                                                FirebaseFirestore.instance
                                                    .collection('messages')
                                                    .doc(userFirebaseId)
                                                    .collection(widget
                                                        .data['receiverId'])
                                                    .doc();
                                            documentReference1.set({
                                              "documentId":
                                                  documentReference1.id,
                                              'Name': widget.data['name'],
                                              'ProfileImage': widget
                                                  .data['userProfileImage'],
                                              'Id': widget.data['receiverId'],
                                              'SenderName': name,
                                              'SenderProfileImage':
                                                  profileImageMain,
                                              'SenderId': userFirebaseId,
                                              'Message': sendMsg.text,
                                              'url': "",
                                              'timestamp': formattedDate,
                                              'DateAndTime':
                                                  DateTime.now().toString(),
                                              'messageType': 'text',
                                              'totalMessage': '$countMessage',
                                              'seenMessage': '',
                                              'messageTo': "user",
                                              'forwardMessage': "no"
                                            });
                                            documentReference1 =
                                                FirebaseFirestore.instance
                                                    .collection('messages')
                                                    .doc(widget
                                                        .data['receiverId'])
                                                    .collection(userFirebaseId)
                                                    .doc();
                                            documentReference1.set({
                                              "documentId":
                                                  documentReference1.id,
                                              'Name': name,
                                              'ProfileImage': profileImageMain,
                                              'Id': userFirebaseId,
                                              'SenderName': name,
                                              'SenderProfileImage':
                                                  profileImageMain,
                                              'SenderId': userFirebaseId,
                                              'Message': sendMsg.text,
                                              'url': "",
                                              'timestamp': formattedDate,
                                              'DateAndTime':
                                                  DateTime.now().toString(),
                                              'messageType': 'text',
                                              'totalMessage': '$countMessage',
                                              'seenMessage': '',
                                              'messageTo': "user",
                                              'forwardMessage': "no"
                                            });
                                            documentReference1 = FirebaseFirestore
                                                .instance
                                                .collection(
                                                    'user/$userFirebaseId/recentMessage')
                                                .doc(widget.data['receiverId']);
                                            documentReference1.set({
                                              "documentId":
                                                  documentReference1.id,
                                              'Name': widget.data['name'],
                                              'ProfileImage': widget
                                                  .data['userProfileImage'],
                                              'Id': widget.data['receiverId'],
                                              'deviceToken':
                                                  receiverDeviceToken,
                                              'SenderName': name,
                                              'SenderProfileImage':
                                                  profileImageMain,
                                              'SenderId': userFirebaseId,
                                              'Message': sendMsg.text,
                                              'url': "",
                                              'timestamp': formattedDate,
                                              'DateAndTime':
                                                  DateTime.now().toString(),
                                              'messageType': 'text',
                                              'totalMessage': '$countMessage',
                                              'seenMessage': '',
                                              'messageTo': "user",
                                              'forwardMessage': "no"
                                            });
                                            documentReference1 = FirebaseFirestore
                                                .instance
                                                .collection(
                                                    'user/${widget.data['receiverId']}/recentMessage')
                                                .doc(userFirebaseId);
                                            documentReference1.set({
                                              "documentId":
                                                  documentReference1.id,
                                              'Name': name,
                                              'ProfileImage': profileImageMain,
                                              'Id': userFirebaseId,
                                              'SenderName': name,
                                              'SenderProfileImage':
                                                  profileImageMain,
                                              'SenderId': userFirebaseId,
                                              'deviceToken': senderDeviceToken,
                                              'Message': sendMsg.text,
                                              'url': "",
                                              'timestamp': formattedDate,
                                              'DateAndTime':
                                                  DateTime.now().toString(),
                                              'messageType': 'text',
                                              'totalMessage': '$countMessage',
                                              'seenMessage': '',
                                              'messageTo': "user",
                                              'forwardMessage': "no"
                                            });
                                          } else {
                                            FirebaseMessage
                                                .sendNotificationToGroup(
                                                    sendMsg.text,
                                                    receiverDeviceToken,
                                                    "message",
                                                    userTokenIdList);
                                            for (int i = 0;
                                                i < userFirebaseIdList.length;
                                                i++) {
                                              documentReference1 = FirebaseFirestore
                                                  .instance
                                                  .collection(
                                                      'user/${userFirebaseIdList[i]}/recentMessage')
                                                  .doc(widget
                                                      .data['receiverId']);
                                              documentReference1.set({
                                                "documentId":
                                                    documentReference1.id,
                                                'Name': widget.data['name'],
                                                'ProfileImage': widget
                                                    .data['userProfileImage'],
                                                'Id': widget.data['receiverId'],
                                                'SenderName': name,
                                                'SenderProfileImage':
                                                    profileImageMain,
                                                'SenderId': userFirebaseId,
                                                'Message': sendMsg.text,
                                                'url': "",
                                                'timestamp': formattedDate,
                                                'DateAndTime':
                                                    DateTime.now().toString(),
                                                'messageType': 'text',
                                                'totalMessage':
                                                    userFirebaseIdList[i] !=
                                                            userFirebaseId
                                                        ? '$countMessage'
                                                        : "",
                                                'seenMessage': '',
                                                "group_id":
                                                    widget.data['idea_id'],
                                                'messageTo': "group",
                                                'forwardMessage': "no",
                                                "adminId":
                                                    widget.data["adminId"]
                                              });
                                              documentReference1 = FirebaseFirestore
                                                  .instance
                                                  .collection(
                                                      'messages/${userFirebaseIdList[i]}/${widget.data['receiverId']}')
                                                  .doc();
                                              documentReference1.set({
                                                "documentId":
                                                    documentReference1.id,
                                                'Name': widget.data['name'],
                                                'ProfileImage': widget
                                                    .data['userProfileImage'],
                                                'Id': widget.data['receiverId'],
                                                'SenderName': name,
                                                'SenderProfileImage':
                                                    profileImageMain,
                                                'SenderId': userFirebaseId,
                                                'Message': sendMsg.text,
                                                'url': "",
                                                'timestamp': formattedDate,
                                                'DateAndTime':
                                                    DateTime.now().toString(),
                                                'messageType': 'text',
                                                'totalMessage':
                                                    userFirebaseIdList[i] !=
                                                            userFirebaseId
                                                        ? '$countMessage'
                                                        : "",
                                                'seenMessage': '',
                                                "group_id":
                                                    widget.data['idea_id'],
                                                'messageTo': "group",
                                                'forwardMessage': "no",
                                                "removedMemberId": "",
                                                "adminId":
                                                    widget.data["adminId"]
                                              });
                                              /*FirebaseFirestore.instance
                                                  .collection("message")
                                                  .doc('${userFirebaseIdList[i]}')
                                                  .collection(widget.data['receiverId'])
                                                  .add({
                                                'Name': widget.data['name'],
                                                'ProfileImage': widget.data['userProfileImage'],
                                                'Id': widget.data['receiverId'],
                                                'SenderName': name,
                                                'SenderProfileImage': profileImageMain,
                                                'SenderId': userFirebaseId,
                                                'Message': sendMsg.text,
                                                'url': "",
                                                'time': formattedDate,
                                                'messageType': 'text',
                                                'totalMessage': '$i',
                                                'seenMessage': '',
                                                "group_id":widget.data['id'],
                                                'messageTo':"group"
                                              });*/

                                            }
                                          }
                                        });

                                        sendMsg.clear();
                                      }
                                    }),
                              ],
                            ),
                          ),
                        ),
                      // CustomWidgets.sizedBox(height: 10.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: Colors.white,
      indicatorColor: Colors.blue,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        sendMsg.text = sendMsg.text + emoji.emoji;
      },
      numRecommended: 50,
    );
  }

  Widget showEmoji(BuildContext context) {
    if (!showEmojiKeyboard) return Container();
    //hide keyboard
    FocusScope.of(context).requestFocus(new FocusNode());
    // create emojipicker
    return EmojiPicker(
      rows: 4,
      columns: 7,
      bgColor: Colors.lightBlueAccent,
      indicatorColor: Colors.grey,
      onEmojiSelected: (emoji, category) {
        sendMsg.text = sendMsg.text + emoji.emoji;
      },
    );
  }

  Widget buildSticker(BuildContext context) {
    return EmojiPicker(
      rows: 3,
      columns: 7,
      buttonMode: ButtonMode.MATERIAL,
      recommendKeywords: ["racing", "horse"],
      numRecommended: 10,
      onEmojiSelected: (emoji, category) {
        print(emoji);
      },
    );
  }

  chatScreen() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(userFirebaseId)
            .collection(
              widget.data['receiverId'],
            )
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
                child: Text(
              "Loading",
              textScaleFactor: 1,
            ));
            //CircularProgressIndicator()
            // );
          } else {
            list = snapshot.data.docs;

            final yesterday = DateTime.now().subtract(Duration(days: 1));
            return (list.isNotEmpty && isDeleted == true)
                ? GroupedListView<dynamic, String>(
                    elements: list,
                    groupBy: (element) => DateTime.fromMillisecondsSinceEpoch(
                            int.parse(element['timestamp']))
                        .toString()
                        .split(" ")[0],
                    groupComparator: (value1, value2) =>
                        value2.compareTo(value1),
                    itemComparator: (item1, item2) => DateTimeFormat.format(
                            DateTime.fromMillisecondsSinceEpoch(int.parse(item2[
                                    'timestamp']
                                .toString())), //DateTime.fromMillisecondsSinceEpoch(int.parse(list[index]['timestamp'].toString())),
                            format: 'j M Y H i s')
                        .compareTo(DateTimeFormat.format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(item1['timestamp'].toString())),
                            format: 'j M Y H i s')),
                    /*   itemComparator: (item1, item2) =>
                  item1['timestamp'].toString().compareTo(item2['timestamp'].toString()),*/

                    order: GroupedListOrder.ASC,
                    useStickyGroupSeparators: false,
                    reverse: true,
                    groupSeparatorBuilder: (String value) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        DateTimeFormat.format(DateTime.parse(value.toString()),
                                    format: 'j M Y') ==
                                DateTimeFormat.format(DateTime.now(),
                                    format: 'j M Y')
                            ? "Today"
                            : DateTimeFormat.format(
                                        DateTime.parse(value.toString()),
                                        format: 'j M Y') ==
                                    DateTimeFormat.format(yesterday,
                                        format: 'j M Y')
                                ? "Yesterday"
                                : DateTimeFormat.format(
                                    DateTime.parse(value.toString()),
                                    format: 'j M Y'),
                        textAlign: TextAlign.center,
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    itemBuilder: (c, element) {
                      // isDeleted =
                      //     ;
                      // print("Last: " + list.last["removedMemberId"]);
                      // print("First: " + list.first["removedMemberId"]);
                      if (widget.data["chat"] == "group") if (element[
                              "documentId"] ==
                          list.first["documentId"]) {
                        if (list.first["removedMemberId"] ==
                            (widget.data['receiverId'] +
                                userIdMain.toString())) {
                          // Navigator.of(context).pop();
                          // WebResponseExtractor.showToast("You have been removed");
                          // Navigator.of(context).pop();
                          // Navigator.of(context).pop();
                          setState(() {
                            isDeleted = false;
                          });
                        } else if (list.first["removedMemberId"] != "") {
                          if (catches != list.first["removedMemberId"]) {
                            setState(() {
                              catches = list.first["removedMemberId"];
                            });
                            fetchCommitteeMemberData("");
                          }
                        }
                      }
                      // if (widget.data["chat"] == "group") if (element[
                      //         "documentId"] ==
                      //     list.first["documentId"])
                      return Container(
                        padding: EdgeInsets.all(2),
                        child: Container(
                          child: userFirebaseId != element['SenderId']
                              ? Wrap(
                                  spacing: 8,
                                  runSpacing: 10,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: element['messageType'] == 'text'
                                          ? GestureDetector(
                                              onLongPress: () {
                                                setState(() {
                                                  if (!selectIndex.contains(
                                                      element['documentId']
                                                          .toString())) {
                                                    selectIndex.add(
                                                        element['documentId']
                                                            .toString());
                                                    message.add(
                                                        element['Message']
                                                            .toString());
                                                    Map<String, dynamic> dr = {
                                                      "file":
                                                          '${element['Message'].toString()}',
                                                      "fileName": ''
                                                    };
                                                    forwardMessage.add(dr);
                                                  } else {
                                                    selectIndex.remove(
                                                        element['documentId']
                                                            .toString());
                                                    message.remove(
                                                        element['Message']
                                                            .toString());
                                                    forwardMessage.removeWhere(
                                                        (elements) =>
                                                            elements.values
                                                                .elementAt(0) ==
                                                            element['Message']
                                                                .toString());
                                                  }
                                                });
                                              },
                                              child: Bubble(
                                                  margin:
                                                      BubbleEdges.only(top: 10),
                                                  nip: BubbleNip.leftTop,
                                                  color: !selectIndex.contains(
                                                          element['documentId']
                                                              .toString())
                                                      ? Colors.grey[300]
                                                      : Colors.lightBlueAccent,
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 200),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        element['forwardMessage'] ==
                                                                'yes'
                                                            ? Text("Forwarded",
                                                                textScaleFactor:
                                                                    1,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left)
                                                            : SizedBox(),
                                                        element['messageTo'] ==
                                                                "group"
                                                            ? Text(
                                                                "${element['SenderName']}",
                                                                textScaleFactor:
                                                                    1,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              )
                                                            : SizedBox(),
                                                        element['messageType'] ==
                                                                'text'
                                                            ? SelectableAutoLinkText(
                                                                '${element['Message']}',
                                                                textScaleFactor:
                                                                    1,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                linkStyle: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline),
                                                                highlightedLinkStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  backgroundColor: Colors
                                                                      .blueAccent
                                                                      .withAlpha(
                                                                          0x33),
                                                                ),
                                                                onTap: (url) => launch(
                                                                    url,
                                                                    forceSafariVC:
                                                                        false),
                                                              )
                                                            : SizedBox(),
                                                        Text(
                                                          "${DateTimeFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(element['timestamp'].toString())), format: 'H:i')}",
                                                          textScaleFactor: 1,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 9),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                            )
                                          : element['messageType'] == 'image'
                                              ? GestureDetector(
                                                  onLongPress: () {
                                                    setState(() {
                                                      if (!selectIndex.contains(
                                                          element['documentId']
                                                              .toString())) {
                                                        selectIndex.add(element[
                                                                'documentId']
                                                            .toString());
                                                        fileUrl.add(
                                                            element['url']);
                                                        message.add(
                                                            element['url']
                                                                .toString());
                                                        Map<String, dynamic>
                                                            dr = {
                                                          "file":
                                                              '${element['url'].toString()}',
                                                          "fileName":
                                                              '${element['fileName'].toString()}'
                                                        };
                                                        forwardMessage.add(dr);
                                                        Map<String, dynamic>
                                                            shareData = {
                                                          "file":
                                                              '${element['url'].toString()}',
                                                          "fileName":
                                                              '${element['fileName'].toString()}'
                                                        };
                                                        shareContent
                                                            .add(shareData);
                                                      } else {
                                                        selectIndex.remove(
                                                            element['documentId']
                                                                .toString());
                                                        fileUrl.remove(
                                                            element['url']
                                                                .toString());
                                                        message.remove(
                                                            element['url']
                                                                .toString());
                                                        forwardMessage.removeWhere(
                                                            (elements) =>
                                                                elements.values
                                                                    .elementAt(
                                                                        0) ==
                                                                element['url']
                                                                    .toString());
                                                        shareContent.removeWhere(
                                                            (elements) =>
                                                                elements.values
                                                                    .elementAt(
                                                                        0) ==
                                                                element['url']
                                                                    .toString());
                                                      }
                                                    });
                                                  },
                                                  child: Bubble(
                                                      margin: BubbleEdges.only(
                                                          top: 10),
                                                      nip: BubbleNip.leftTop,
                                                      color: !selectIndex
                                                              .contains(element[
                                                                      'documentId']
                                                                  .toString())
                                                          ? Colors.grey[300]
                                                          : Colors
                                                              .lightBlueAccent,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          element['forwardMessage'] ==
                                                                  'yes'
                                                              ? Text(
                                                                  "Forwarded",
                                                                  textScaleFactor:
                                                                      1,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                )
                                                              : SizedBox(),
                                                          element['messageTo'] ==
                                                                  "group"
                                                              ? Text(
                                                                  "${element['SenderName']}",
                                                                  textScaleFactor:
                                                                      1,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                  ),
                                                                )
                                                              : SizedBox(),
                                                          element['messageType'] ==
                                                                  'text'
                                                              ? Text(
                                                                  element[
                                                                      'Message'],
                                                                  textScaleFactor:
                                                                      1,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                )
                                                              : GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(builder:
                                                                            (_) {
                                                                      return FullScreenImage(
                                                                        imageUrl:
                                                                            element['url'],
                                                                        tag:
                                                                            "generate_a_unique_tag",
                                                                        username:
                                                                            widget.data['name'],
                                                                        userImage:
                                                                            widget.data['userProfileImage'],
                                                                      );
                                                                    }));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 150,
                                                                    height: 150,
                                                                    // color:
                                                                    //     Colors.lightBlueAccent,
                                                                    child: (element['url'] !=
                                                                                null &&
                                                                            element['url'] !=
                                                                                "")
                                                                        ? CachedNetworkImage(
                                                                            placeholder: (context, url) =>
                                                                                const CircularProgressIndicator(
                                                                              backgroundColor: Colors.blue,
                                                                            ),
                                                                            imageUrl:
                                                                                element['url'],
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            fadeOutDuration:
                                                                                const Duration(seconds: 1),
                                                                            fadeInDuration:
                                                                                const Duration(seconds: 1),
                                                                          )
                                                                        : Icon(Icons
                                                                            .image),
                                                                  ),
                                                                ),
                                                          Text(
                                                            "${DateTimeFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(element['timestamp'].toString())), format: 'H:i')}",
                                                            textScaleFactor: 1,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 9),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ],
                                                      )),
                                                )
                                              : element['messageType'] ==
                                                      'video'
                                                  ? GestureDetector(
                                                      onLongPress: () {
                                                        setState(() {
                                                          if (!selectIndex
                                                              .contains(element[
                                                                      'documentId']
                                                                  .toString())) {
                                                            selectIndex.add(element[
                                                                    'documentId']
                                                                .toString());
                                                            fileUrl.add(
                                                                element['url']);
                                                            message.add(element[
                                                                    'url']
                                                                .toString());
                                                            Map<String, dynamic>
                                                                dr = {
                                                              "file":
                                                                  '${element['url'].toString()}',
                                                              "fileName":
                                                                  '${element['fileName'].toString()}'
                                                            };
                                                            forwardMessage
                                                                .add(dr);
                                                            Map<String, dynamic>
                                                                shareData = {
                                                              "file":
                                                                  '${element['url'].toString()}',
                                                              "fileName":
                                                                  '${element['fileName'].toString()}'
                                                            };
                                                            shareContent
                                                                .add(shareData);
                                                          } else {
                                                            selectIndex.remove(
                                                                element['documentId']
                                                                    .toString());
                                                            fileUrl.remove(
                                                                element['url']
                                                                    .toString());
                                                            message.remove(
                                                                element['url']
                                                                    .toString());
                                                            forwardMessage.removeWhere(
                                                                (elements) =>
                                                                    elements
                                                                        .values
                                                                        .elementAt(
                                                                            0) ==
                                                                    element['url']
                                                                        .toString());
                                                            shareContent.removeWhere(
                                                                (elements) =>
                                                                    elements
                                                                        .values
                                                                        .elementAt(
                                                                            0) ==
                                                                    element['url']
                                                                        .toString());
                                                          }
                                                        });
                                                      },
                                                      child: Bubble(
                                                          margin:
                                                              BubbleEdges.only(
                                                                  top: 10),
                                                          nip:
                                                              BubbleNip.leftTop,
                                                          color: !selectIndex
                                                                  .contains(element[
                                                                          'documentId']
                                                                      .toString())
                                                              ? Colors.grey[300]
                                                              : Colors
                                                                  .lightBlueAccent,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              element['forwardMessage'] ==
                                                                      'yes'
                                                                  ? Text(
                                                                      "Forwarded",
                                                                      textScaleFactor:
                                                                          1,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                    )
                                                                  : SizedBox(),
                                                              element['messageTo'] ==
                                                                      "group"
                                                                  ? Text(
                                                                      "${element['SenderName']}",
                                                                      textScaleFactor:
                                                                          1,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    )
                                                                  : SizedBox(),
                                                              element['messageType'] ==
                                                                      'video'
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        /* downloadFile(list[
                                                                        index]
                                                                    ['image_url']);*/
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder:
                                                                                (_) {
                                                                          return VideoPlayerWidget(
                                                                              element['url']);
                                                                        }));
                                                                      },
                                                                      child:
                                                                          Stack(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        children: [
                                                                          Container(
                                                                            constraints:
                                                                                BoxConstraints(maxWidth: 100),
                                                                            child:
                                                                                ThumbnailImage(
                                                                              videoUrl: "${element['url'].trim()}",
                                                                              width: 100,
                                                                              height: 100,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                          // Container(
                                                                          //   width: 150,
                                                                          //   height: 150,
                                                                          //   // color:
                                                                          //   //     Colors.lightBlueAccent,
                                                                          //   child: bytes !=
                                                                          //       null
                                                                          //       ? Image
                                                                          //       .memory(
                                                                          //     bytes,
                                                                          //     fit: BoxFit
                                                                          //         .cover,
                                                                          //   )
                                                                          //       : Text(
                                                                          //       "loading"),
                                                                          // ),
                                                                          Container(
                                                                            child:
                                                                                Icon(
                                                                              Icons.play_arrow,
                                                                              color: Colors.blueAccent,
                                                                              size: 50,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : SizedBox(),
                                                              Text(
                                                                "${DateTimeFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(element['timestamp'].toString())), format: 'H:i')}",
                                                                textScaleFactor:
                                                                    1,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        9),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                            ],
                                                          )),
                                                    )
                                                  : GestureDetector(
                                                      onLongPress: () {
                                                        setState(() {
                                                          if (!selectIndex
                                                              .contains(element[
                                                                      'documentId']
                                                                  .toString())) {
                                                            selectIndex.add(element[
                                                                    'documentId']
                                                                .toString());
                                                            fileUrl.add(
                                                                element['url']);
                                                            message.add(element[
                                                                    'url']
                                                                .toString());
                                                            Map<String, dynamic>
                                                                dr = {
                                                              "file":
                                                                  '${element['url'].toString()}',
                                                              "fileName":
                                                                  '${element['fileName'].toString()}'
                                                            };
                                                            forwardMessage
                                                                .add(dr);
                                                            Map<String, dynamic>
                                                                shareData = {
                                                              "file":
                                                                  '${element['url'].toString()}',
                                                              "fileName":
                                                                  '${element['fileName'].toString()}'
                                                            };
                                                            shareContent
                                                                .add(shareData);
                                                          } else {
                                                            selectIndex.remove(
                                                                element['documentId']
                                                                    .toString());
                                                            fileUrl.remove(
                                                                element['url']
                                                                    .toString());
                                                            message.remove(
                                                                element['url']
                                                                    .toString());
                                                            forwardMessage.removeWhere(
                                                                (elements) =>
                                                                    elements
                                                                        .values
                                                                        .elementAt(
                                                                            0) ==
                                                                    element['url']
                                                                        .toString());
                                                            shareContent.removeWhere(
                                                                (elements) =>
                                                                    elements
                                                                        .values
                                                                        .elementAt(
                                                                            0) ==
                                                                    element['url']
                                                                        .toString());
                                                          }
                                                        });
                                                      },
                                                      child: Bubble(
                                                        margin:
                                                            BubbleEdges.only(
                                                                top: 10),
                                                        nip: BubbleNip.leftTop,
                                                        color: !selectIndex
                                                                .contains(element[
                                                                        'documentId']
                                                                    .toString())
                                                            ? Colors.grey[300]
                                                            : Colors
                                                                .lightBlueAccent,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            element['forwardMessage'] ==
                                                                    'yes'
                                                                ? Text(
                                                                    "Forwarded",
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                  )
                                                                : SizedBox(),
                                                            element['messageTo'] ==
                                                                    "group"
                                                                ? Text(
                                                                    "${element['SenderName']}",
                                                                    textScaleFactor:
                                                                        1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                    ),
                                                                  )
                                                                : SizedBox(),
                                                            element['messageType'] ==
                                                                    'file'
                                                                ? GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      await launch(
                                                                          element[
                                                                              'url']);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          // Container(
                                                                          //   height: 80,
                                                                          //   width: 150,
                                                                          //   alignment: Alignment.topLeft,
                                                                          //   decoration: BoxDecoration(
                                                                          //       image: DecorationImage(
                                                                          //           image: AssetImage(
                                                                          //               element['fileName'].toString().contains(".pdf")
                                                                          //                   ? AppAssets.pdfIcon  : element['fileName'].toString().contains(".docx")
                                                                          //                   ? AppAssets.wordIcon :
                                                                          //               element['fileName'].toString().contains(".xlsx")
                                                                          //                   ? AppAssets.excelIcon : element['fileName'].toString().contains(".pptx")
                                                                          //                   ? AppAssets.pdfIcon : AppAssets.file)
                                                                          //       )
                                                                          //   ),
                                                                          // ),
                                                                          Text(
                                                                            "${element['fileName']}",
                                                                            textScaleFactor:
                                                                                1,
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 15,
                                                                                decoration: TextDecoration.underline),
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(builder:
                                                                              (_) {
                                                                        return FullScreenImage(
                                                                          imageUrl:
                                                                              element['url'],
                                                                          tag:
                                                                              "generate_a_unique_tag",
                                                                          username:
                                                                              widget.data['name'],
                                                                          userImage:
                                                                              widget.data['userProfileImage'],
                                                                        );
                                                                      }));
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          150,
                                                                      height:
                                                                          150,
                                                                      // color:
                                                                      //     Colors.lightBlueAccent,
                                                                      child: (element['url'] != null &&
                                                                              element['url'] !=
                                                                                  "")
                                                                          ? CachedNetworkImage(
                                                                              placeholder: (context, url) => const CircularProgressIndicator(
                                                                                backgroundColor: Colors.blue,
                                                                              ),
                                                                              imageUrl: element['url'],
                                                                              fit: BoxFit.cover,
                                                                              fadeOutDuration: const Duration(seconds: 1),
                                                                              fadeInDuration: const Duration(seconds: 1),
                                                                            )
                                                                          : Icon(
                                                                              Icons.image),
                                                                    ),
                                                                  ),
                                                            Text(
                                                              "${DateTimeFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(element['timestamp'].toString())), format: 'H:i')}",
                                                              textScaleFactor:
                                                                  1,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 9),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                    ),
                                  ],
                                )
                              : userFirebaseId == element['SenderId']
                                  ? Wrap(
                                      spacing: 8,
                                      runSpacing: 10,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional.topEnd,
                                          child: element['messageType'] ==
                                                  'text'
                                              ? GestureDetector(
                                                  onLongPress: () {
                                                    setState(() {
                                                      if (!selectIndex.contains(
                                                          element['documentId']
                                                              .toString())) {
                                                        selectIndex.add(element[
                                                                'documentId']
                                                            .toString());
                                                        message.add(
                                                            element['Message']
                                                                .toString());
                                                        Map<String, dynamic>
                                                            dr = {
                                                          "file":
                                                              '${element['Message'].toString()}',
                                                          "fileName": ''
                                                        };
                                                        forwardMessage.add(dr);
                                                      } else {
                                                        selectIndex.remove(
                                                            element['documentId']
                                                                .toString());
                                                        message.remove(
                                                            element['Message']
                                                                .toString());
                                                        forwardMessage.removeWhere(
                                                            (elements) =>
                                                                elements.values
                                                                    .elementAt(
                                                                        0) ==
                                                                element['Message']
                                                                    .toString());
                                                        // print('List:'+selectIndex.toString());
                                                      }
                                                    });
                                                  },
                                                  child: Bubble(
                                                      margin: BubbleEdges.only(
                                                          top: 10),
                                                      nip: BubbleNip.rightTop,
                                                      color: !selectIndex
                                                              .contains(element[
                                                                      'documentId']
                                                                  .toString())
                                                          // ? Color.fromRGBO(
                                                          //     2, 136, 157, 1.0)
                                                          ? Colors
                                                              .lightBlue[100]
                                                          : Colors
                                                              .lightBlueAccent,
                                                      child: Container(
                                                        constraints:
                                                            BoxConstraints(
                                                                maxWidth: 200),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            element['forwardMessage'] ==
                                                                    'yes'
                                                                ? Text(
                                                                    "Forwarded",
                                                                    textScaleFactor:
                                                                        1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  )
                                                                : SizedBox(),
                                                            element['messageType'] ==
                                                                    'text'
                                                                ? SelectableAutoLinkText(
                                                                    '${element['Message']}',
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    linkStyle: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        decoration:
                                                                            TextDecoration.underline),
                                                                    highlightedLinkStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                    onTap: (url) => launch(
                                                                        url,
                                                                        forceSafariVC:
                                                                            false),
                                                                  )
                                                                : Container(
                                                                    width: 100,
                                                                    height: 100,
                                                                    // color:
                                                                    //     Colors.lightBlueAccent,
                                                                    child: (element['url'] !=
                                                                                null &&
                                                                            element['url'] !=
                                                                                "")
                                                                        ? CachedNetworkImage(
                                                                            placeholder: (context, url) =>
                                                                                const CircularProgressIndicator(
                                                                              backgroundColor: Colors.blue,
                                                                            ),
                                                                            imageUrl:
                                                                                element['url'],
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            fadeOutDuration:
                                                                                const Duration(seconds: 1),
                                                                            fadeInDuration:
                                                                                const Duration(seconds: 1),
                                                                          )
                                                                        : Icon(Icons
                                                                            .image),
                                                                  ),
                                                            Text(
                                                              "${DateTimeFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(element['timestamp'].toString())), format: 'H:i')}",
                                                              textScaleFactor:
                                                                  1,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 9),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            )
                                                          ],
                                                        ),
                                                      )),
                                                )
                                              : element['messageType'] ==
                                                      'image'
                                                  ? GestureDetector(
                                                      onLongPress: () {
                                                        setState(() {
                                                          if (!selectIndex
                                                              .contains(element[
                                                                      'documentId']
                                                                  .toString())) {
                                                            selectIndex.add(element[
                                                                    'documentId']
                                                                .toString());
                                                            fileUrl.add(
                                                                element['url']);
                                                            message.add(element[
                                                                    'url']
                                                                .toString());
                                                            Map<String, dynamic>
                                                                dr = {
                                                              "file":
                                                                  '${element['url'].toString()}',
                                                              "fileName":
                                                                  '${element['fileName'].toString()}'
                                                            };
                                                            forwardMessage
                                                                .add(dr);
                                                            Map<String, dynamic>
                                                                shareData = {
                                                              "file":
                                                                  '${element['url'].toString()}',
                                                              "fileName":
                                                                  '${element['fileName'].toString()}'
                                                            };
                                                            shareContent
                                                                .add(shareData);
                                                          } else {
                                                            selectIndex.remove(
                                                                element['documentId']
                                                                    .toString());
                                                            fileUrl.remove(
                                                                element['url']
                                                                    .toString());
                                                            message.remove(
                                                                element['url']
                                                                    .toString());
                                                            forwardMessage.removeWhere(
                                                                (elements) =>
                                                                    elements
                                                                        .values
                                                                        .elementAt(
                                                                            0) ==
                                                                    element['url']
                                                                        .toString());
                                                            shareContent.removeWhere(
                                                                (elements) =>
                                                                    elements
                                                                        .values
                                                                        .elementAt(
                                                                            0) ==
                                                                    element['url']
                                                                        .toString());
                                                          }
                                                        });
                                                      },
                                                      child: Bubble(
                                                        margin:
                                                            BubbleEdges.only(
                                                                top: 10),
                                                        nip: BubbleNip.rightTop,
                                                        color: !selectIndex
                                                                .contains(element[
                                                                        'documentId']
                                                                    .toString())
                                                            // ? Color.fromRGBO(2,
                                                            //     136, 157, 1.0)
                                                            ? Colors
                                                                .lightBlue[100]
                                                            : Colors
                                                                .lightBlueAccent,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            element['forwardMessage'] ==
                                                                    'yes'
                                                                ? Text(
                                                                    "Forwarded",
                                                                    textScaleFactor:
                                                                        1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  )
                                                                : SizedBox(),
                                                            element['messageType'] ==
                                                                    'text'
                                                                ? Text(
                                                                    element[
                                                                        'Message'],
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: TextStyle(
                                                                        color: Colors.grey[300], /////////////////////////////
                                                                        fontSize: 15),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                  )
                                                                : GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(builder:
                                                                              (_) {
                                                                        return FullScreenImage(
                                                                          imageUrl:
                                                                              element['url'],
                                                                          tag:
                                                                              "generate_a_unique_tag",
                                                                          username:
                                                                              widget.data['name'],
                                                                          userImage:
                                                                              widget.data['userProfileImage'],
                                                                        );
                                                                      }));
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          150,
                                                                      height:
                                                                          150,
                                                                      // color:
                                                                      //     Colors.lightBlueAccent,
                                                                      child: (element['url'] != null &&
                                                                              element['url'] !=
                                                                                  "")
                                                                          ? CachedNetworkImage(
                                                                              placeholder: (context, url) => const CircularProgressIndicator(
                                                                                backgroundColor: Colors.blue,
                                                                              ),
                                                                              imageUrl: element['url'],
                                                                              fit: BoxFit.cover,
                                                                              fadeOutDuration: const Duration(seconds: 1),
                                                                              fadeInDuration: const Duration(seconds: 1),
                                                                            )
                                                                          : Icon(
                                                                              Icons.image),
                                                                    ),
                                                                  ),
                                                            Text(
                                                              "${DateTimeFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(element['timestamp'].toString())), format: 'H:i')}",
                                                              textScaleFactor:
                                                                  1,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 9),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : element['messageType'] ==
                                                          'video'
                                                      ? GestureDetector(
                                                          onLongPress: () {
                                                            setState(() {
                                                              if (!selectIndex
                                                                  .contains(element[
                                                                          'documentId']
                                                                      .toString())) {
                                                                selectIndex.add(
                                                                    element['documentId']
                                                                        .toString());
                                                                fileUrl.add(
                                                                    element[
                                                                        'url']);
                                                                message.add(element[
                                                                        'url']
                                                                    .toString());
                                                                Map<String,
                                                                        dynamic>
                                                                    dr = {
                                                                  "file":
                                                                      '${element['url'].toString()}',
                                                                  "fileName":
                                                                      '${element['fileName'].toString()}'
                                                                };
                                                                forwardMessage
                                                                    .add(dr);
                                                                Map<String,
                                                                        dynamic>
                                                                    shareData =
                                                                    {
                                                                  "file":
                                                                      '${element['url'].toString()}',
                                                                  "fileName":
                                                                      '${element['fileName'].toString()}'
                                                                };
                                                                shareContent.add(
                                                                    shareData);
                                                              } else {
                                                                selectIndex.remove(
                                                                    element['documentId']
                                                                        .toString());
                                                                fileUrl.remove(
                                                                    element['url']
                                                                        .toString());
                                                                message.remove(
                                                                    element['url']
                                                                        .toString());
                                                                forwardMessage.removeWhere((elements) =>
                                                                    elements
                                                                        .values
                                                                        .elementAt(
                                                                            0) ==
                                                                    element['Message']
                                                                        .toString());
                                                                shareContent.removeWhere((elements) =>
                                                                    elements
                                                                        .values
                                                                        .elementAt(
                                                                            0) ==
                                                                    element['url']
                                                                        .toString());
                                                              }
                                                            });
                                                          },
                                                          child: Bubble(
                                                            margin: BubbleEdges
                                                                .only(top: 10),
                                                            nip: BubbleNip
                                                                .rightTop,
                                                            color: !selectIndex
                                                                    .contains(element[
                                                                            'documentId']
                                                                        .toString())
                                                                // ? Color
                                                                //     .fromRGBO(
                                                                //         2,
                                                                //         136,
                                                                //         157,
                                                                //         1.0)
                                                                ? Colors.lightBlue[
                                                                    100]
                                                                : Colors
                                                                    .lightBlueAccent,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                element['forwardMessage'] ==
                                                                        'yes'
                                                                    ? Text(
                                                                        "Forwarded",
                                                                        textScaleFactor:
                                                                            1,
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black),
                                                                      )
                                                                    : SizedBox(),
                                                                element['messageType'] ==
                                                                        'video'
                                                                    ? GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (_) {
                                                                            return VideoPlayerWidget(element['url']);
                                                                          }));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          constraints:
                                                                              BoxConstraints(maxWidth: 100),
                                                                          child:
                                                                              Stack(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            children: [
                                                                              CustomWidgets.CheckValidString(element['url'])
                                                                                  ? Container(
                                                                                      child: ThumbnailImage(
                                                                                        videoUrl: "${element['url'].trim()}",
                                                                                        width: 100,
                                                                                        height: 100,
                                                                                        fit: BoxFit.cover,
                                                                                      ),
                                                                                    )
                                                                                  : GFLoader(),
                                                                              Container(
                                                                                child: Icon(
                                                                                  Icons.play_arrow,
                                                                                  color: Colors.blueAccent,
                                                                                  size: 50,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : SizedBox(),
                                                                Text(
                                                                  "${DateTimeFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(element['timestamp'].toString())), format: 'H:i')}",
                                                                  textScaleFactor:
                                                                      1,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          9),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : GestureDetector(
                                                          onLongPress: () {
                                                            setState(() {
                                                              if (!selectIndex
                                                                  .contains(element[
                                                                          'documentId']
                                                                      .toString())) {
                                                                selectIndex.add(
                                                                    element['documentId']
                                                                        .toString());
                                                                fileUrl.add(
                                                                    element[
                                                                        'url']);
                                                                message.add(element[
                                                                        'url']
                                                                    .toString());
                                                                Map<String,
                                                                        dynamic>
                                                                    dr = {
                                                                  "file":
                                                                      '${element['url'].toString()}',
                                                                  "fileName":
                                                                      '${element['fileName'].toString()}'
                                                                };
                                                                forwardMessage
                                                                    .add(dr);
                                                                Map<String,
                                                                        dynamic>
                                                                    shareData =
                                                                    {
                                                                  "file":
                                                                      '${element['url'].toString()}',
                                                                  "fileName":
                                                                      '${element['fileName'].toString()}'
                                                                };
                                                                shareContent.add(
                                                                    shareData);
                                                              } else {
                                                                selectIndex.remove(
                                                                    element['documentId']
                                                                        .toString());
                                                                fileUrl.remove(
                                                                    element['url']
                                                                        .toString());
                                                                message.remove(
                                                                    element['url']
                                                                        .toString());
                                                                forwardMessage.removeWhere((elements) =>
                                                                    elements
                                                                        .values
                                                                        .elementAt(
                                                                            0) ==
                                                                    element['url']
                                                                        .toString());
                                                                shareContent.removeWhere((elements) =>
                                                                    elements
                                                                        .values
                                                                        .elementAt(
                                                                            0) ==
                                                                    element['url']
                                                                        .toString());
                                                              }
                                                            });
                                                          },
                                                          child: Bubble(
                                                            margin: BubbleEdges
                                                                .only(top: 10),
                                                            nip: BubbleNip
                                                                .rightTop,
                                                            color: !selectIndex
                                                                    .contains(element[
                                                                            'documentId']
                                                                        .toString())
                                                                // ? Color
                                                                //     .fromRGBO(
                                                                //         2,
                                                                //         136,
                                                                //         157,
                                                                //         1.0)
                                                                ? Colors.lightBlue[
                                                                    100]
                                                                : Colors
                                                                    .lightBlueAccent,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                element['forwardMessage'] ==
                                                                        'yes'
                                                                    ? Text(
                                                                        "Forwarded",
                                                                        textScaleFactor:
                                                                            1,
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black),
                                                                      )
                                                                    : SizedBox(),
                                                                element['messageType'] ==
                                                                        'file'
                                                                    ? Container(
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            await launch(element['url']);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                              children: [
                                                                                // Container(
                                                                                //   height: 80,
                                                                                //   width: 150,
                                                                                //   alignment: Alignment.topRight,
                                                                                //   decoration: BoxDecoration(
                                                                                //       image: DecorationImage(
                                                                                //           image: AssetImage(
                                                                                //               element['fileName'].toString().contains(".pdf")
                                                                                //                   ? AppAssets.pdfIcon  : element['fileName'].toString().contains(".docx")
                                                                                //                   ? AppAssets.wordIcon :
                                                                                //               element['fileName'].toString().contains(".xlsx")
                                                                                //                   ? AppAssets.excelIcon : element['fileName'].toString().contains(".pptx")
                                                                                //                   ? AppAssets.pdfIcon : AppAssets.file)
                                                                                //       )
                                                                                //   ),
                                                                                // ),
                                                                                Text(
                                                                                  "${element['fileName']}",
                                                                                  textScaleFactor: 1,
                                                                                  style: TextStyle(color: Colors.black, fontSize: 15, decoration: TextDecoration.underline),
                                                                                  textAlign: TextAlign.right,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (_) {
                                                                            return FullScreenImage(
                                                                              imageUrl: element['url'],
                                                                              tag: "generate_a_unique_tag",
                                                                              username: widget.data['name'],
                                                                              userImage: widget.data['userProfileImage'],
                                                                            );
                                                                          }));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              150,
                                                                          height:
                                                                              150,
                                                                          // color:
                                                                          //     Colors.lightBlueAccent,
                                                                          child: (element['url'] != null && element['url'] != "")
                                                                              ? CachedNetworkImage(
                                                                                  placeholder: (context, url) => const CircularProgressIndicator(
                                                                                    backgroundColor: Colors.blue,
                                                                                  ),
                                                                                  imageUrl: element['url'],
                                                                                  fit: BoxFit.cover,
                                                                                  fadeOutDuration: const Duration(seconds: 1),
                                                                                  fadeInDuration: const Duration(seconds: 1),
                                                                                )
                                                                              : Icon(Icons.image),
                                                                        ),
                                                                      ),
                                                                Text(
                                                                  "${DateTimeFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(element['timestamp'].toString())), format: 'H:i')}",
                                                                  textScaleFactor:
                                                                      1,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          9),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      "Let's Start a Great Conversation",
                      textScaleFactor: 1,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  );
          }
        });
  }

  showAttachmentBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.image),
                    title: Text(
                      'Image',
                      textScaleFactor: 1,
                    ),
                    onTap: () {
                      setState(() {
                        fileType = 'image';
                      });
                      filePicker(context);
                      Navigator.pop(context);
                    }),
                ListTile(
                  leading: Icon(Icons.videocam),
                  title: Text(
                    'Video',
                    textScaleFactor: 1,
                  ),
                  onTap: () {
                    setState(() {
                      fileType = 'video';
                    });
                    filePicker(context);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.insert_drive_file),
                  title: Text(
                    'File',
                    textScaleFactor: 1,
                  ),
                  onTap: () {
                    setState(() {
                      fileType = 'file';
                    });
                    filePicker(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> _showMyDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete',
            textScaleFactor: 1,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Delete Chat ?",
                  textScaleFactor: 1,
                ),

                /*  TextFormField(
                  controller: albumName,
                  decoration: InputDecoration(hintText: "Enter Album Name"),
                ),*/
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cancel",
                textScaleFactor: 1,
              ),
              onPressed: () {
                selectIndex.clear();
                // Navigator.of(context).pushReplacementNamed("/events");
                Navigator.of(context).pop();
                //_showChooseDialogBox(context);
              },
            ),
            TextButton(
              child: Text(
                "OK",
                textScaleFactor: 1,
              ),
              onPressed: () {
                if (selectIndex.length < 1) {
                  FirebaseFirestore.instance
                      .collection('messages')
                      .doc(userFirebaseId)
                      .collection(widget.data['receiverId'])
                      .get()
                      .then((snapshot) {
                    for (DocumentSnapshot ds in snapshot.docs) {
                      ds.reference.delete();
                    }
                  });
                  FirebaseFirestore.instance
                      .collection('user')
                      .doc(userFirebaseId)
                      .collection('recentMessage')
                      .doc(widget.data['receiverId'])
                      .delete();
                  //Navigator.of(context).pushReplacementNamed("/events");
                  Navigator.of(context).pop();
                  //_showChooseDialogBox(context);
                } else {
                  for (int i = 0; i < selectIndex.length; i++) {
                    FirebaseFirestore.instance
                        .collection('messages')
                        .doc(userFirebaseId)
                        .collection(widget.data['receiverId'])
                        .doc(selectIndex[i])
                        .delete();

                    Navigator.of(context).pop();
                  }
                }
                selectIndex.clear();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteChat() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete',
            textScaleFactor: 1,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Delete Chat ?",
                  textScaleFactor: 1,
                ),

                /*  TextFormField(
                  controller: albumName,
                  decoration: InputDecoration(hintText: "Enter Album Name"),
                ),*/
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cancel",
                textScaleFactor: 1,
              ),
              onPressed: () {
                selectIndex.clear();
                // Navigator.of(context).pushReplacementNamed("/events");
                Navigator.of(context).pop();
                //_showChooseDialogBox(context);
              },
            ),
            TextButton(
              child: Text(
                "OK",
                textScaleFactor: 1,
              ),
              onPressed: () {
                setState(() {
                  for (int i = 0; i < selectIndex.length; i++) {
                    print("selected index:" + selectIndex.toString());
                    FirebaseFirestore.instance
                        .collection('messages')
                        .doc(userFirebaseId)
                        .collection(widget.data['receiverId'])
                        .doc(selectIndex[i])
                        .delete();
                    if (list.first['documentId'] == selectIndex[i]) {
                      list.removeAt(0);
                      print("gasdfg");
                      if (list.isNotEmpty) {
                        DocumentReference documentReference2;
                        documentReference2 = FirebaseFirestore.instance
                            .collection('user/$userFirebaseId/recentMessage')
                            .doc(widget.data['receiverId']);
                        documentReference2.set({
                          "documentId": list.first['documentId'],
                          'Name': list.first['Name'],
                          'ProfileImage': list.first['ProfileImage'],
                          'Id': list.first['Id'],
                          'deviceToken': list.first['deviceToken'],
                          'SenderName': list.first['SenderName'],
                          'SenderProfileImage':
                              list.first['SenderProfileImage'],
                          'SenderId': list.first['SenderId'],
                          'Message': list.first['Message'],
                          'url': list.first['url'],
                          'timestamp': list.first['timestamp'],
                          'DateAndTime': list.first['DateAndTime'],
                          'messageType': list.first['messageType'],
                          'totalMessage': list.first['totalMessage'],
                          'seenMessage': list.first['seenMessage'],
                          'messageTo': list.first['messageTo'],
                          'forwardMessage': list.first['forwardMessage']
                        });
                        print("gasdfg1");
                      } else {
                        print("gasdfg2");
                        FirebaseFirestore.instance
                            .collection('user')
                            .doc(userFirebaseId)
                            .collection('recentMessage')
                            .doc(widget.data['receiverId'])
                            .delete();
                        print("gasdfg3");
                      }
                    } else {
                      if (list.isNotEmpty) {
                        print("gasdfg9");
                        for (int j = 0; j < list.length; j++) {
                          if (list[j]['documentId'] == selectIndex[i]) {
                            list.removeAt(j);
                          }
                        }

                        print("gasdfg4");
                        DocumentReference documentReference2;
                        documentReference2 = FirebaseFirestore.instance
                            .collection('user/$userFirebaseId/recentMessage')
                            .doc(widget.data['receiverId']);
                        documentReference2.set({
                          "documentId": list.first['documentId'],
                          'Name': list.first['Name'],
                          'ProfileImage': list.first['ProfileImage'],
                          'Id': list.first['Id'],
                          'deviceToken': list.first['deviceToken'],
                          'SenderName': list.first['SenderName'],
                          'SenderProfileImage':
                              list.first['SenderProfileImage'],
                          'SenderId': list.first['SenderId'],
                          'Message': list.first['Message'],
                          'url': list.first['url'],
                          'timestamp': list.first['timestamp'],
                          'DateAndTime': list.first['DateAndTime'],
                          'messageType': list.first['messageType'],
                          'totalMessage': list.first['totalMessage'],
                          'seenMessage': list.first['seenMessage'],
                          'messageTo': list.first['messageTo'],
                          'forwardMessage': list.first['forwardMessage']
                        });
                        print("gasdfg5");
                      } else {
                        print("gasdfg6");
                        FirebaseFirestore.instance
                            .collection('user')
                            .doc(userFirebaseId)
                            .collection('recentMessage')
                            .doc(widget.data['receiverId'])
                            .delete();
                        print("gasdfg7");
                      }
                    }
                  }
                  Navigator.of(context).pop();
                  selectIndex.clear();

                  print("gasdfg8");
                });
                Navigator.of(context).pop();
                print("gasdfg9");
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAllChat() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete',
            textScaleFactor: 1,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Clear All Chat ?",
                  textScaleFactor: 1,
                ),

                /*  TextFormField(
                  controller: albumName,
                  decoration: InputDecoration(hintText: "Enter Album Name"),
                ),*/
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cancel",
                textScaleFactor: 1,
              ),
              onPressed: () {
                selectIndex.clear();
                // Navigator.of(context).pushReplacementNamed("/events");
                Navigator.of(context).pop();
                //_showChooseDialogBox(context);
              },
            ),
            TextButton(
              child: Text(
                "OK",
                textScaleFactor: 1,
              ),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('messages')
                    .doc(userFirebaseId)
                    .collection(widget.data['receiverId'])
                    .get()
                    .then((snapshot) {
                  for (DocumentSnapshot ds in snapshot.docs) {
                    ds.reference.delete();
                  }
                });
                FirebaseFirestore.instance
                    .collection('user')
                    .doc(userFirebaseId)
                    .collection('recentMessage')
                    .doc(widget.data['receiverId'])
                    .delete();
                //Navigator.of(context).pushReplacementNamed("/events");
                Navigator.of(context).pop();
                if (selectIndex.length < 1) {
                  //_showChooseDialogBox(context);
                } else {
                  for (int i = 0; i < selectIndex.length; i++) {
                    FirebaseFirestore.instance
                        .collection('messages')
                        .doc(userFirebaseId)
                        .collection(widget.data['receiverId'])
                        .doc(selectIndex[i])
                        .delete();

                    Navigator.of(context).pop();
                  }
                }
                selectIndex.clear();
              },
            ),
          ],
        );
      },
    );
  }

  saveAndShare(var shareList) async {
    List<String> shareContentPath = [];
    final RenderBox box = context.findRenderObject();
    if (Platform.isAndroid) {
      for (int i = 0; i < shareList.length; i++) {
        var url = '${shareList[i]['file']}';
        var response = await get(url);
        final documentDirectory = (await getExternalStorageDirectory()).path;
        File imgFile = new File(
            '$documentDirectory' + '/' + '${shareList[i]['fileName']}');
        imgFile.writeAsBytesSync(response.bodyBytes);
        shareContentPath.add(imgFile.path);
      }

      Share.shareFiles(shareContentPath,
          subject: 'Share',
          text: '',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      Share.share('',
          subject: 'Share',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }
}

class LinkTextSpan extends TextSpan {
  LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                launch(url);
              });
}

// class Uploader extends StatefulWidget {
//   final File file;
//   Uploader({Key key,this.file}) : super(key: key);
//   @override
//   _UploaderState createState() => _UploaderState();
// }

// class _UploaderState extends State<Uploader> {
//   final FirebaseStorage _storage = FirebaseStorage();
//   UploadTask _uploadTask;
//   void _startUplaod(){
//     String filePath = 'images/${DateTime.now()}.png';
//     setState(() {
//       _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     if(_uploadTask!=null)
//     {
//       return StreamBuilder<UploadTask>(
//         stream: _uploadTask.events,
//         builder: (context,snapshot){
//           var event = snapshot?.data?.snapshot;
//           double progressPercent = event != null ?
//           event.bytesTransferred / event.totalByteCount : 0 ;
//           return Column(
//             children: [
//               if(_uploadTask.isComplete)
//                 Text("Download"),
//               if(_uploadTask.isPaused)
//                 FlatButton(onPressed: _uploadTask.resume, child: Icon(Icons.play_arrow)),
//               if(_uploadTask.isInProgress)
//                 FlatButton(onPressed: _uploadTask.resume, child: Icon(Icons.play_arrow)),
//               LinearProgressIndicator(value: progressPercent),
//               Text("${(progressPercent * 100).toStringAsFixed(2)} % "),

//             ],
//           );
//         },
//       );
//     }
//     return Container();
//   }

// }
