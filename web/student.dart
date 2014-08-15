library student;

import 'package:polymer/polymer.dart';
import 'package:form_elements/required_component.dart';
import 'dart:html';
import 'util.dart';

@CustomTag('x-student')
class Student extends RequiredComponent {
  String get _nameId => "x-student-name-" + xid;
  String get _classId => "x-student-class-" + xid;
  String get _birthdayId => "x-student-birthday-" + xid;
  
  Student.created() : super.created();
  
  String get name {
    DivElement fullNameElt = queryId(_nameId);
    return fullNameElt.xtag.fullName;
  }
  
  String get className {
    DivElement classElt = queryId(_classId);
    return classElt.xtag.className;
  }
  
  String get birthday {
    DivElement birthdayElt = queryId(_birthdayId);
    return birthdayElt.xtag.date;
  }
  
  void check(List<String> errors) {
    DivElement fullNameElt = queryId(_nameId);
    fullNameElt.xtag.check(errors);
  }
  
  void clear() {
    DivElement fullNameElt = queryId(_nameId);
    fullNameElt.xtag.clear();
  }
}