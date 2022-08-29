import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/componant/Componants.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class DoneTasks extends StatelessWidget {
  const DoneTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if(AppCubit.getCubit(context).donetasks.isNotEmpty){
          return ListView.separated(
              itemBuilder: (context, index) => defaultTaskItem(AppCubit.getCubit(context).donetasks[index],context),
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: 10.0
                ),
                child: Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey[300],
                ),
              ),
              itemCount: AppCubit.getCubit(context).donetasks.length);
        }else{
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.menu ,color: Colors.grey, size: 50,),
                Text('No tasks yet',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
