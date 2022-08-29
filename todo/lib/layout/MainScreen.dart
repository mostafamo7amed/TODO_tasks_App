import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/componant/Componants.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class MainScreen extends StatelessWidget {

  MainScreen({Key? key}) : super(key: key);
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    //
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener:(BuildContext context, AppStates state) {
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        } ,
        builder:(BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.getCubit(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            body: state is AppGetDatabaseLoadingState ? const Center(child: CircularProgressIndicator()): cubit.screens[cubit.currentIndex] ,
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.fbIcon),
              onPressed: () {
                if(cubit.isBottomSheetOpen){
                  if(formKey.currentState!.validate()){
                    cubit.insertDatabase(title: titleController.text,
                        date: dateController.text, time: timeController.text);
                  }
                }
                else{
                  scaffoldKey.currentState?.showBottomSheet((context) => Container(
                    padding: const EdgeInsets.all(20.0),
                    color: Colors.grey[300],
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormField(
                                controller: titleController,
                                label: 'Task Title',
                                prefix: const Icon(Icons.title),
                                validate: (value){
                                  if(value.isEmpty){
                                    return 'Title can\'t be empty';
                                  }
                                  return null;
                                },
                                type: TextInputType.text
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              defaultFormField(
                                  controller: timeController,
                                  label: 'Task Time',
                                  prefix: const Icon(Icons.watch_later_outlined),
                                  onTap: (){
                                    showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now()
                                    ).then((value) {
                                      if(value != null) {
                                        timeController.text = value.format(context);
                                      }else {
                                        timeController.text = '';
                                      }
                                    });

                                  },
                                  validate: (value){
                                    if(value.isEmpty){
                                      return 'Time can\'t be empty';
                                    }
                                    return null;
                                  },
                                  type: TextInputType.number),
                              const SizedBox(
                                height: 15,
                              ),
                              defaultFormField(
                                  controller: dateController,
                                  label: 'Task Date',
                                  prefix: const Icon(Icons.calendar_today),
                                  onTap: (){
                                    showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2022-11-11')
                                    ).then((value) {
                                      if(value != null) {
                                        dateController.text = DateFormat.yMMMd().format(value).toString();
                                      }else {
                                        dateController.text = '';
                                      }
                                    });


                                  },
                                  validate: (value){
                                    if(value.isEmpty){
                                      return 'Date can\'t be empty';
                                    }
                                    return null;
                                  },
                                  type: TextInputType.number),
                            ],
                          ),
                        ),
                      ),
                    ),
                    elevation: 20,
                  ).closed.then((value) {
                    cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
                  });
                    cubit.changeBottomSheet(isShow: true, icon:  Icons.add);
                }



              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex ,
              onTap: (index){
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done),
                  label: 'Done Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'Archived',
                ),
              ],
            ),
          );
        } ,
      ),
    );
  }


}


