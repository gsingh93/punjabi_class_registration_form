library class_selector;

import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('x-class-selector')
class ClassSelector extends PolymerElement {
  @published String xid = "1";
  String get classId => "class-" + xid;
  
  ClassSelector.created() : super.created();
  
  // TODO: This is duplicated
  Element queryId(String id) {
    Element e = $[id];
    if (e == null) {
      throw new Exception('#' + id + " was not found");    
    }
    return e;
  }

  String get className {
    SelectElement classElt = queryId(classId);
    return classElt.value;
  }
}