import 'package:remind_me/Imports/imports.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
class notify {



  void IntitializeSetting()  async{
    tz.initializeTimeZones();
    var initializeAndroid = AndroidInitializationSettings("my_icon");
    var initializeSettings = InitializationSettings(android: initializeAndroid);
    notificationsPlugin.initialize(initializeSettings);
  }



}
class addAlarm{
  Future notify(int index, String Title, DateTime date) async{
    notificationsPlugin.zonedSchedule(index,
        Title,
        "its Time",
        tz.TZDateTime.from(date, tz.local),
        NotificationDetails(android: AndroidNotificationDetails("channel id", "channel name", "channel description")),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }
}
