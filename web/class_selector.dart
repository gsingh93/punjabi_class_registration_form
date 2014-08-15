library class_selector;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'util.dart';

@CustomTag('x-class-selector')
class ClassSelector extends PolymerElement {
  @published String xid = "1";
  String get _classId => "class-" + xid;
  
  ClassSelector.created() : super.created();
  
  String get className {
    SelectElement classElt = queryId(_classId);
    return classElt.value;
  }
}