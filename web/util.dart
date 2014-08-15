library util;

import 'package:polymer/polymer.dart';
import 'dart:html';

Element queryId(String selector) {
  Element e = querySelector('#' + selector);
  if (e == null) {
    throw new Exception('#' + selector + " was not found");    
  }
  return e;
}
