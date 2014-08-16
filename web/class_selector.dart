library class_selector;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:form_elements/required_component.dart';

@CustomTag('x-class-selector')
class ClassSelector extends RequiredComponent {
  String get classId => "class-" + xid;
  
  ClassSelector.created() : super.created();
  
  void check(List<String> errors) {
    if (className == "invalid") {
      errors.add("Please select a grade, or select \"I don't know\" if you are not sure");
    }
  }

  void clear() {
  }

  String get className {
    SelectElement classElt = queryId(classId);
    return classElt.value;
  }
}