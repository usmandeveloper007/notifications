import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'notification_services.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    // notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value){
      if (kDebugMode) {
        print('Device Token');
        print(value);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: TextButton(onPressed: (){
              notificationServices.getDeviceToken().then((value) async {
                var data = {
                  'to': value.toString(),
                  'priority': 'high',
                  'notification': {
                    'title': 'My self Muhammad Usman',
                    'body': 'I am flutter developer',
                  },
                  'data' : {
                    'msg' : 'Flutter Developer',
                    'id' : '1122',
                }
                };
                await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                  body: jsonEncode(data),
                  headers: {
                  'Content-Type' : 'application/json; charset=UTF-8',
                    'Authorization' : 'key=AAAAhIKajwM:APA91bEijucqGEO_dMymGivgJbKa9PWVE3z97GVlrgdW-WDxdU0ERZ99gzpw30dC0gnG42sjK5f0AwpWIIXY14fAxVijw4Wu_qBOmJRC5Af_JtqhYQTDd-V763tC5pS-PyeqW5z9lmAl',
                  }
                );
              });
            },
                child: const Text('Click here for Notification!', style: TextStyle(
                  fontSize: 22, color: Colors.green, fontWeight: FontWeight.w900
                ),),
            ),
          ),
        ],
      ),
    );
  }
}
