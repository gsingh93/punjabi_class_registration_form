library student;

import 'package:polymer/polymer.dart';
import 'package:form_elements/required_component.dart';
import 'package:form_elements/full_name.dart';
import 'package:form_elements/date.dart';
import 'class_selector.dart';
import 'dart:html';

@CustomTag('x-student')
class Student extends RequiredComponent {
  @observable bool male = false;
  @observable bool female = false;
  String get nameId => "x-student-name-" + xid;
  String get classId => "x-student-class-" + xid;
  String get birthdayId => "x-student-birthday-" + xid;
  
  Student.created() : super.created();
  
  Element queryId(String id) {
    Element e = $[id];
    if (e == null) {
      throw new Exception('#' + id + " was not found");    
    }
    return e;
  }

  String get name {
    FullName fullNameElt = queryId(nameId);
    return fullNameElt.fullName;
  }
  
  String get className {
    ClassSelector classElt = queryId(classId);
    return classElt.className;
  }
  
  String get birthday {
    Date birthdayElt = queryId(birthdayId);
    return birthdayElt.date;
  }
  
  String get gender {
    assert(!(male && female));
    if (male) {
      return "Male";
    } else if (female) {
      return "Female";
    } else {
      return "";
    }
  }
  
  void check(List<String> errors) {
    FullName fullNameElt = queryId(nameId);
    fullNameElt.check(errors);
    ClassSelector classElt = queryId(classId);
    classElt.check(errors);
    
    // Check gender
    if (gender == "") {
      errors.add("Student " + xid + " gender is required");
    }
  }
  
  void clear() {
    FullName fullNameElt = queryId(nameId);
    fullNameElt.clear();
  }
}