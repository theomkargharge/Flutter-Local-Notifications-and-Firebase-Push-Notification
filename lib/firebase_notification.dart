import 'package:flutter/material.dart';
import 'package:notification_app/firebase_service.dart';

class FirebaseNotification extends StatefulWidget {
  const FirebaseNotification({super.key});

  @override
  State<FirebaseNotification> createState() => _FirebaseNotificationState();
}

class _FirebaseNotificationState extends State<FirebaseNotification> {
  NotificationServices services = NotificationServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    services.requestNoiticationPremission();
    services.getToken().then((value) {
      print('Device Token');
      print(value);
    });
    services.firebaseInit();


    // services.refreshToken();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title:const Text('Firebase Notification'), backgroundColor: Colors.blue,),
    );
  }
}
