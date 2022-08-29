import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';


Widget defaultFormField({
  required TextEditingController controller,
  required String label,
  required Icon prefix,
  required validate,
  required TextInputType type,
  suffix,
  pressedShow,
  onTap,
  bool isPassword = false,
    }) =>
    TextFormField(
      controller: controller,
      obscureText: isPassword,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefix,
        suffixIcon: suffix!=null ? IconButton(
          icon: suffix,
          onPressed:pressedShow,):null ,
        border: const OutlineInputBorder(),
      ),
      validator: validate,
      keyboardType: type,
    );

Widget defaultTaskItem(Map model , context) => Dismissible(
  key: Key(model['id'].toString()),
  onDismissed:(direction) {
    AppCubit.getCubit(context).deleteDatabase(id: model['id']);
  } ,
  background: Container(
    alignment: Alignment.centerRight,
    padding:const EdgeInsets.symmetric(horizontal: 20,),
    color: Colors.red,
    child: const Icon(Icons.delete_forever, color: Colors.white,size: 45,),
  ),
  secondaryBackground: Container(
    alignment: Alignment.centerRight,
    padding:const EdgeInsets.symmetric(horizontal: 20,),
    color: Colors.red,
    child: const Icon(Icons.delete_forever, color: Colors.white,size: 45,),
  ),
  child: Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      children: [
         CircleAvatar(

          radius: 40,

          backgroundColor: Colors.blue,

          child: Center(

            child: Text(

              '${model['time']}',

              style: const TextStyle(

                color: Colors.white,

              ),

            ),

          ),

        ),

        const SizedBox(width: 10,),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment:CrossAxisAlignment.start ,

            children: [

              Text(

                '${model['title']}',

                style: const TextStyle(

                  fontSize: 20,

                  color: Colors.black,

                  fontWeight: FontWeight.bold,

                ),

              ),

              Text(

                '${model['date']}',

                style: const TextStyle(

                  fontSize: 18,

                  color: Colors.grey,

                ),

              ),

            ],

          ),

        ),

        IconButton(

            color: Colors.green,

            onPressed:(){

              AppCubit.getCubit(context).updateDatabase(

                  status: 'done', id: model['id']);

            },

            icon: const Icon(Icons.check_box)),

        IconButton(

            color: Colors.black45,

            onPressed:(){

              AppCubit.getCubit(context).updateDatabase(

                  status: 'archive', id: model['id']);

            },

            icon: const Icon(Icons.archive)),

      ],

    ),

  ),
);
