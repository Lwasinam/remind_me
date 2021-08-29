import 'package:remind_me/Imports/imports.dart';
import 'package:remind_me/model/data.dart';

class UserDataProvider with ChangeNotifier {

  Box box = Hive.box("Task_Database");
  List list = [UserData(DateTime.now(), true, "hey"),UserData(DateTime.now(), true, "hey"),UserData(DateTime.now(), true, "hey")];

  addTask( UserData userData ) async{
      box.compact();
      var len = box.length;
     box.add(userData);
        //WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (listKey.currentState != null && len < box.length){
            listKey.currentState.insertItem(box.length-1, duration: Duration(milliseconds: 600));
          }
        //});



    /* List keys =  Hive.box("Task_Database").keys.toList();
     print( keys.indexOf(keys.length));*/






      //getItem();
      notifyListeners();
  }
  updateTask(UserData data, int index) async{
   box.putAt(index, data);
   notifyListeners();

  }
  deleteTask(int index)async{
    box.deleteAt(index);

    notifyListeners();
  }


 /*() getItem() async {
    for ( int i in [0,4]) {
     UserData data = Hive.box("Task_Database").getAt(i);
     _inventoryList.add(data);



    }
    print(_inventoryList);
    print(Hive.box("Task_Database").length);

    notifyListeners();
  }

  */


}