// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:database_with_model_demo/DatabaseDemo.dart';
import 'package:database_with_model_demo/databasehelper.dart';
import 'package:flutter/material.dart';

import 'package:database_with_model_demo/StudentModel.dart';

class AddEditStudent extends StatefulWidget {
  bool? isEdit;
  StudentModel? studentlist;
  AddEditStudent(this.isEdit, [this.studentlist]);

  @override
  State<AddEditStudent> createState() => _AddEditStudentState();
}

class _AddEditStudentState extends State<AddEditStudent> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerrank = TextEditingController();
  TextEditingController controllerAge = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.isEdit!) {
      //for starting when no edit click i think
      controllerName.text = widget.studentlist!.student_name!;
      controllerrank.text = widget.studentlist!.student_rank.toString();
      controllerAge.text = widget.studentlist!.student_age.toString();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit or add"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("sTudent Name:", style: TextStyle(fontSize: 18)),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(controller: controllerName),
                )
              ],
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("sTudent age:", style: TextStyle(fontSize: 18)),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(controller: controllerAge),
                )
              ],
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("sTudent rank:", style: TextStyle(fontSize: 18)),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(controller: controllerrank),
                )
              ],
            ),
            const SizedBox(height: 60),
            OutlinedButton(
                onPressed: () {
                  if (widget.isEdit!) {
                    UpdateDatabase(widget.studentlist!.student_id!);
                  } else {
                    insertDataintoDB();
                  }
                  //Navigator.pop(context);
                  //Use PUsh Replacement so we go back to previous screen with refresh and build otherwise navigator.pop is enough
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DatabaseDemo(),
                    ),
                  );
                },
                child: const Text("Submit"))
          ],
        ),
      ),
    );
  }

  void insertDataintoDB() async {
    var getStudentName = controllerName.text;
    var getStudentrank = controllerrank.text;
    var getStudentAge = controllerAge.text;
    if (getStudentName.isNotEmpty &&
        getStudentrank.isNotEmpty &&
        getStudentAge.isNotEmpty) {
      StudentModel newEmployee = StudentModel(
          student_name: getStudentName,
          student_rank: getStudentrank,
          student_age: getStudentAge);
      //Convert object to map using TOMAP method here
      var res = await DatabaseHelper.instance.insert(newEmployee.toMap());
      print(res.toString());
    }
  }

  void UpdateDatabase(int ids) async {
    var getStudentName = controllerName.text;
    var getStudentrank = controllerrank.text;
    var getStudentAge = controllerAge.text;
    StudentModel updateEmployee = StudentModel(
        student_id: ids,
        student_name: getStudentName,
        student_rank: getStudentrank,
        student_age: getStudentAge);

    DatabaseHelper.instance.update(updateEmployee.toMap(), ids);
  }
}
