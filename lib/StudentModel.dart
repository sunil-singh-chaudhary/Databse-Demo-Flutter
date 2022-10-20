// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class StudentModel {
  int? student_id;
  String? student_name, student_rank, student_age;

  StudentModel(
      {this.student_id,
      @required this.student_name,
      @required this.student_rank,
      @required this.student_age});

  //to be used when inserting a row in the table
  Map<String, dynamic> toMapWithoutId() {
    final map = <String, dynamic>{};
    map["student_name"] = student_name;
    map["student_rank"] = student_rank;
    map["student_age"] = student_age;
    return map;
  }

//Creating map from object
  //to be used when updating a row in the table
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map["student_id"] = student_id;
    map["student_name"] = student_name;
    map["student_rank"] = student_rank;
    map["student_age"] = student_age;
    return map;
  }

  // converting the row or map into object
  factory StudentModel.fromMap(Map<String, dynamic> data) => StudentModel(
      student_id: data['student_id'],
      student_name: data['student_name'],
      student_rank: data['student_rank'],
      student_age: data['student_age']);
}
