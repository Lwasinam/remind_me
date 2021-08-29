import 'package:remind_me/Imports/imports.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:remind_me/model/data.dart';
import 'package:remind_me/provider/UserDataProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(UserDataAdapter(),);
 await Hive.openBox("Task_database");
  runApp(
    DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) =>   ChangeNotifierProvider(child: MaterialApp(home: MyApp(), theme: ThemeData(fontFamily: "IndieFlower"),), create: (context) => UserDataProvider(),))
    );
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var inventoryDb = Provider.of<UserDataProvider>(context, listen: false);

    return ScreenUtilInit(
      builder: () => MaterialApp(
        locale: DevicePreview.locale(context), // Add the locale here
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          '/': (context) => TaskScreen(),
          'createTask': (context) => CreateTask()
        },

      )
    );
  }
}
