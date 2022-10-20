import 'dart:async';

import 'package:database_with_model_demo/StudentModel.dart';
import 'package:database_with_model_demo/databasehelper.dart';

import 'package:flutter/material.dart';

import 'AddEditStudent.dart';

class DatabaseDemo extends StatefulWidget {
  DatabaseDemo({super.key});

  @override
  State<DatabaseDemo> createState() => _DatabaseDemoState();
}

class _DatabaseDemoState extends State<DatabaseDemo>
    with WidgetsBindingObserver {
  List<StudentModel>? studentList;
  int queryRowCount = 0;
  Future<List<Map<String, dynamic>>?> getStudentInfo() async {
    studentList = [];

    //first get all rows from database
    List<Map<String, dynamic>> getallrows =
        await DatabaseHelper.instance.queryAllRows();
    print(getallrows);

    getTableInfo_emptyorNot();
    setState(() {
      // return getallrows.map((e) => studentList.add(StudentModel.fromMap(e)));
      return getallrows.forEach(
          (element) => {studentList!.add(StudentModel.fromMap(element))});
    });
  }

  void getTableInfo_emptyorNot() async {
    queryRowCount = (await DatabaseHelper.instance.queryRowCount())!;
    print("Table row is-->" + queryRowCount.toString());
  }

  @override
  void initState() {
    ///To listen onResume method
    WidgetsBinding.instance.addObserver(this);
    //Future.delayed(Duration(milliseconds: 1000));
    getStudentInfo();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

//get info when resumed app
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getStudentInfo();
      print('onresume call');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddEditStudent(
                              false,
                            )));
              },
            )
          ],
        ),
        body: Container(
          child: queryRowCount > 0
              ? listview(studentList!)
              : const Center(
                  child: Text("No DB present add data"),
                ),
        ));
  }

  Widget listview(List<StudentModel> studentList) {
    return ListView.builder(
      itemCount: studentList.length,
      itemBuilder: (context, index) => Card(
        elevation: 10,
        margin: const EdgeInsets.all(10),
        child: ListTile(
          title: Text(studentList[index].student_name.toString()),
          leading: Text(studentList[index].student_age.toString()),
          subtitle: Text(studentList[index].student_rank.toString()),
          trailing: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            AddEditStudent(true, studentList[index])));
              },
              icon: const Icon(
                Icons.edit,
              )),
        ),
      ),
    );
  }
}
