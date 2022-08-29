import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_tasks/ArchivedTasks.dart';
import 'package:todo/modules/done_tasks/DoneTasks.dart';
import 'package:todo/modules/new_tasks/NewTasks.dart';
import 'package:todo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {

  AppCubit() : super(AppInitState());

  static AppCubit getCubit(context) => BlocProvider.of(context);

  var currentIndex = 0;

  late Database  database;

  List<Map> newtasks =[];
  List<Map> donetasks =[];
  List<Map> archivedtasks =[];


  List<Widget> screens =[
    const NewTasks(),
    const DoneTasks(),
    const ArchivedTasks(),
  ];
  List<String> titles =[
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  changeIndex(index){
    currentIndex = index;
    emit(AppBottomNavChangeState());
  }


  void createDatabase(){
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database , version) {
        print('database created');
        database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value){
          print('table created');

        }).catchError((error){
          print('an error occur ${error.toString()}');

        });
      },
      onOpen: (database) {
        emit(AppGetDatabaseLoadingState());
        getDataFormDatabase(database);
        print('database open');

      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

   insertDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
     await database.transaction ((txn){
      return txn.rawInsert('INSERT INTO tasks (title ,date ,time ,status ) VALUES ("$title","$date","$time","new")')
          .then((value){
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());
        emit(AppGetDatabaseLoadingState());
        getDataFormDatabase(database);
      } ).catchError((error){
        print('an error occur while inserting data');
      });
    });
  }

  void getDataFormDatabase(Database database) {
    newtasks = [];
    donetasks =[];
    archivedtasks =[];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if(element['status'] == 'new'){
          newtasks.add(element);
        }else if(element['status'] == 'done'){
          donetasks.add(element);
        }else{
          archivedtasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }


  bool isBottomSheetOpen = false;
  IconData fbIcon = Icons.edit;

  void changeBottomSheet({
    required bool isShow,
    required IconData icon,
  }){
    isBottomSheetOpen = isShow;
    fbIcon = icon;
    emit(AppBottomSheetChangeState());
  }

  void updateDatabase({
    required String status,
    required int id,
  }){
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',[status,id])
    .then((value) {
      emit(AppUpdateDatabaseState());
      getDataFormDatabase(database);
      emit(AppGetDatabaseState());
    });

  }

  void deleteDatabase({
    required int id,
  }){
    database.rawUpdate('DELETE FROM tasks WHERE id = ?',[id])
        .then((value) {
      emit(AppDeleteDatabaseState());
      getDataFormDatabase(database);
      emit(AppGetDatabaseState());
    });

  }
}