import 'package:remind_me/Imports/imports.dart';


class CreateTask extends StatefulWidget {
  const CreateTask({Key key}) : super(key: key);

  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: background,
          child: Column(

          ),

        ),
      ),
    );
  }
}
