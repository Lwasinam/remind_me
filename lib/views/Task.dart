
import 'package:remind_me/Imports/imports.dart';
import  'package:rive/rive.dart';


final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
class TaskScreen extends StatefulWidget {
  const TaskScreen({Key key}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  TextEditingController taskName = TextEditingController();
  bool status = false;


  @override
  void initState() {
    notify().IntitializeSetting();
    super.initState();
  }




  Widget build(BuildContext context) {
    var inventoryDb = Provider.of<UserDataProvider>(context, listen: false);
    int indexx = 1;


    return Scaffold(
      floatingActionButton: SizedBox(
        height: 60.h,
        width: 60.w,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: (){
          showDialog(context: context, builder: (BuildContext context) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
            child: Container(
              height: 200.h,
              width: 300.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: taskName,
                      decoration: InputDecoration(
                        hintText: "Task Name",
                        hintStyle: TextStyle(fontSize: ScreenUtil().setSp(21), fontFamily: "IndieFlower")
                      ),
                    ),
                  )),
                  TextButton(onPressed: (){
                    Navigator.of(context).pop();
                     DatePicker.showDateTimePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(2018, 3, 5),
                  maxTime: DateTime(2022, 12, 31), onChanged: (date) {
                  }, onConfirm: (date) async {
                       //add data to hive box
                   UserData data = UserData(date, status, taskName.text );
                   // add alarm with flutter_local_notificationd
                   addAlarm().notify(indexx, taskName.text, date);
                   // alarms are kept with indexes, this ensures that each alrm has its own index
                   indexx ++;
                   print(indexx);
                  await inventoryDb.addTask(data);
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                  }, child: Text("Ok", style: TextStyle(fontFamily: "IndieFlower",fontSize: ScreenUtil().setSp(18)),))
                ],
              ),

            ),
          ) );},


            backgroundColor: Colors.white,
            child: Icon(Icons.add, size: ScreenUtil().setSp(30), color: Colors.black,),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: AutoSizeText("My Tasks", maxLines: 2, style: TextStyle(color: Colors.black, fontFamily: "IndieFlower", fontSize: ScreenUtil().setSp(28)),))
                ],
              ),
            SizedBox(height: 20.h,),
            Consumer<UserDataProvider>(builder: (context, data, child){

              if(data.box.isEmpty == true) {
                return Center(
                  child: Container(
                    height: 500.h,
                    width: 500.w,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 300.w,
                          width: 300.w,
                          child: RiveAnimation.asset("assets/pencil.riv",
                          onInit: (_) => setState((){}),),
                        ),
                        Text("Write your first task", style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(27), fontFamily: "IndieFlower"),)
                      ],
                    ),
                  ),
                );
              }
              //
              return   AnimatedList(
                  shrinkWrap: true,
                  key: listKey ,
                  physics: NeverScrollableScrollPhysics(),
                  //shrinkWrap: true,
                  initialItemCount:data.box.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index, animation) {
                    UserData tasks = data.box.getAt(index);
                    //print(tasks.pending);

                    return GestureDetector(
                      onTap: () => setState((){
                        tasks.pending = !tasks.pending;
                        print(tasks.pending);
                      }),
                      child: SlideTransition(
                        position: Tween(begin: Offset(1,0), end: Offset(0,0)).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOutSine)),
                        child: Slidable(
                         actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          secondaryActions: [
                            IconSlideAction(
                              caption: "Delete",
                              color: background,
                              icon: Icons.delete,
                              foregroundColor: Colors.black26,
                              onTap: () async{ await inventoryDb.deleteTask(index);
                              listKey.currentState.removeItem(
                                  index, (_, animation){
                                return SlideTransition(
                                  position: Tween(begin: Offset(1,0), end: Offset(0,0)).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
                                  child: Slidable(
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    secondaryActions: [
                                      IconSlideAction(
                                        caption: "Delete",
                                        color: background,
                                        icon: Icons.delete,
                                        foregroundColor: Colors.black26,
                                        onTap: () async => await inventoryDb.deleteTask(index),
                                      ),
                                      IconSlideAction(
                                        caption: "Edit",
                                        color: background,
                                        icon: Icons.edit_rounded,
                                        foregroundColor: Colors.black26,
                                        onTap: (){
                                          taskName = TextEditingController(text: tasks.taskName);
                                          showDialog(context: context, builder: (BuildContext context) => Dialog(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                                            child: Container(
                                              height: 200.h,
                                              width: 300.w,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(30.r)
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Center(child: Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: TextField(
                                                      controller: taskName,
                                                      decoration: InputDecoration(
                                                          hintText: "Task Name",
                                                          hintStyle: TextStyle(fontSize: ScreenUtil().setSp(19), fontFamily: "IndieFlower"),
                                                      ),
                                                    ),
                                                  )),
                                                  TextButton(onPressed: (){
                                                    Navigator.of(context).pop();
                                                    DatePicker.showDateTimePicker(context,
                                                        showTitleActions: true,
                                                        minTime: DateTime(2018, 3, 5),
                                                        maxTime: DateTime(2019, 6, 7), onChanged: (date) {
                                                          print('change $date');
                                                        }, onConfirm: (date) async {
                                                          print('confirm $date');
                                                          UserData data = UserData(date, status, taskName.text );
                                                          await inventoryDb.updateTask(data, index);
                                                          //TODO ADD TO DATABASE AND READ FROM IT
                                                        }, currentTime: tasks.time, locale: LocaleType.en);
                                                  }, child: Text("Ok", style: TextStyle(fontFamily: "IndieFlower",fontSize: ScreenUtil().setSp(15)),))
                                                ],
                                              ),

                                            ),
                                          ) );
                                        },
                                      )
                                    ],
                                    child: Container(
                                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                                      height: 50.h,
                                      width: 300.w,

                                      decoration: BoxDecoration(
                                        boxShadow: [BoxShadow(
                                            color: shadow,
                                            offset: Offset(0, 8),
                                            blurRadius: 50,
                                            spreadRadius: 1
                                        )],
                                        borderRadius: BorderRadius.circular(18.r),
                                        color: Colors.white,

                                      ),
                                      child: Row(

                                        children: [
                                          SizedBox(width:20.w ,),
                                          Container(
                                            height: 35.h,
                                            width: 35.h,
                                            decoration: BoxDecoration(
                                                color: checkbox,
                                                borderRadius: BorderRadius.circular(12.r)
                                            ),
                                          ),
                                          SizedBox(width:10.w ,),
                                          AutoSizeText(tasks.taskName, maxLines: 1, style: TextStyle(fontSize: ScreenUtil().setSp(20),fontFamily: "IndieFlower"),),
                                          // Spacer(),
                                          // IconButton(icon: Icon(Icons.edit,color:Colors.black26 ,size: ScreenUtil().setSp(22),), onPressed: (){} )
                                        ],

                                      ),

                                    ),
                                  ),
                                );
                              },
                                  duration: const Duration(milliseconds: 500));
                              },
                            ),
                            IconSlideAction(
                              caption: "Edit",
                              color: background,
                              icon: Icons.edit_rounded,
                              foregroundColor: Colors.black26,
                              onTap: (){
                                taskName = TextEditingController(text: tasks.taskName);
                                showDialog(context: context, builder: (BuildContext context) => Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                                  child: Container(
                                    height: 200.h,
                                    width: 300.w,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30.r)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Center(child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: TextField(
                                            controller: taskName,
                                            decoration: InputDecoration(
                                                hintText: "Task Name",
                                                hintStyle: TextStyle(fontSize: ScreenUtil().setSp(19), fontFamily: "IndieFlower")
                                            ),
                                          ),
                                        )),
                                        TextButton(onPressed: (){
                                          Navigator.of(context).pop();
                                          DatePicker.showDateTimePicker(context,
                                              showTitleActions: true,
                                              minTime: DateTime(2018, 3, 5),
                                              maxTime: DateTime(2022, 12, 31), onChanged: (date) {
                                                print('change $date');
                                              }, onConfirm: (date) async {
                                                print('confirm $date');
                                                UserData data = UserData(date, status, taskName.text );
                                                await inventoryDb.updateTask(data, index);
                                              }, currentTime: tasks.time, locale: LocaleType.en);
                                        }, child: Text("Ok", style: TextStyle(fontFamily: "IndieFlower",fontSize: ScreenUtil().setSp(15)),))
                                      ],
                                    ),

                                  ),
                                ) );
                              },
                            )
                          ],
                          child: Container(
                            margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                            height: 50.h,
                            width: 300.w,
                            decoration: BoxDecoration(
                              boxShadow: [BoxShadow(
                                  color: shadow,
                                  offset: Offset(0, 8),
                                  blurRadius: 50,
                                  spreadRadius: 1
                              )],
                              borderRadius: BorderRadius.circular(18.r),
                              color: Colors.white,

                            ),
                            child: Row(

                              children: [
                                SizedBox(width:20.w ,),
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  child: AnimatedOpacity(
                                    child: Icon(Icons.check, color: Colors.lightBlueAccent, size: ScreenUtil().setSp(25),),
                                    opacity: tasks.pending ? 1.0: 0.0,
                                    duration: Duration(milliseconds: 400),

                                  ),
                                  height: 35.h,
                                  width: 35.h,
                                  decoration: BoxDecoration(
                                      color:  tasks.pending ? Colors.blueAccent : checkbox,
                                      borderRadius: BorderRadius.circular(12.r)
                                  ),
                                ),
                                SizedBox(width:10.w ,),
                                AutoSizeText(tasks.taskName, maxLines: 1, style: TextStyle(fontFamily: "IndieFlower",fontSize: ScreenUtil().setSp(20)),),
                               // Spacer(),
                               // IconButton(icon: Icon(Icons.edit,color:Colors.black26 ,size: ScreenUtil().setSp(22),), onPressed: (){} )
                              ],

                            ),

                          ),
                        ),
                      ),
                    );
                  }

              );


            }),

          ]
      ),
    )
    ));
  }
}
