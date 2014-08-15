import 'package:polymer/polymer.dart';
import 'package:sprintf/sprintf.dart';
import 'package:form_elements/full_name.dart';
import 'package:form_elements/address.dart';
import 'package:form_elements/email.dart';
import 'package:form_elements/phone_number.dart';
import 'dart:html';
import '../util.dart';
import '../student.dart';

//const String _url = "http://www.michigangurudwara.com/wordpress/wp-content/app/punjabi-class-registration/submit.php";
const String _url = "localhost";

void main() {
  initPolymer();
  queryId('numentries').onChange.listen((e) => numEntriesChanged());
  queryId('submit').onClick.listen((e) => submit(e));
}

void onComplete(HttpRequest request) {
  if (request.readyState == HttpRequest.DONE &&
      (request.status == 200 || request.status == 0)) {
    _loadingGifOff();
    if (request.responseText == "success") {
      window.location.href = "http://michigangurudwara.com/wordpress/wp-content/app/punjabi-class-registration/success.html";
    } else {
      window.alert("An error occurred");
    }
  }
}

void submit(Event e) {
  e.preventDefault();

  String jsonFormat = '''
  {
    "address": "%s",
    "email": "%s",
    "phoneNumber": "%s",
    "name": "%s",
    "class": "%s",
    "birthday": "%s",
    "mother": "%s",
    "father": "%s"
  }
''';

  FullName mother = queryId('mother-name');
  FullName father = queryId('father-name');
  Address address = querySelector('x-address');
  Email email = querySelector('x-email');
  PhoneNumber phoneNumber = querySelector('x-phone-number');
  List<Student> students = querySelectorAll('x-student');
  assert(students.length != 0);
  
  List<String> errors = new List<String>();
  mother.xtag.check(errors);
  father.xtag.check(errors);
  email.xtag.check(errors);
  address.xtag.check(errors);
  phoneNumber.xtag.check(errors);
  int numEntries = _getNumEntries();
  for (int i = 0; i < numEntries; i++) {
    students[i].xtag.check(errors);
  }
  
  if (errors.isNotEmpty) {
    _displayErrors(errors);
    return;
  }
  
  for (int i = 0; i < numEntries; i++) {
//    HttpRequest request = new HttpRequest();
//    request.open("POST", _url, async: false);
//    request.setRequestHeader("Content-Type", "application/json");
//    request.onReadyStateChange.listen((_) => onComplete(request));
    
    String jsonData = sprintf(jsonFormat,
                              [address.xtag.address,
                              email.xtag.email,
                              phoneNumber.xtag.phoneNumber,
                              students[i].xtag.name,
                              students[i].xtag.className,
                              students[i].xtag.birthday,
                              mother.xtag.fullName,
                              father.xtag.fullName]);
    
    print(jsonData);
//    request.send(jsonData);
  }
//  _loadingGifOn();
}

void clearFields() {
  Address address = querySelector('x-address');
  Email email = querySelector('x-email');
  PhoneNumber phoneNumber = querySelector('x-phone-number');
  List<FullName> names = querySelectorAll('x-full-name');
  
  email.xtag.clear();
  address.xtag.clear();
  phoneNumber.xtag.clear();
  int numEntries = _getNumEntries();
  for (int i = 1; i <= numEntries; i++) {
    names[i].xtag.clear();
  }
}

void _loadingGifOn() {
  var s = queryId("loading").style;
  s.display = "inline";
}

void _loadingGifOff() {
  var s = queryId("loading").style;
  s.display = "none";
}

void _displayErrors(List<String> errors) {
  DivElement errorDiv = queryId("errors");
  errorDiv.innerHtml = "";
  
  UListElement errorList = new UListElement();
  for (String error in errors) {
    LIElement li = new LIElement();
    li.innerHtml = "<span>" + error + "</span>";
    errorList.children.add(li);
  }
  errorDiv.children.add(errorList);
}

int _getNumEntries() {
  SelectElement elt = queryId('numentries');
  return int.parse(elt.value);
}

void numEntriesChanged() {
  int numEntries = _getNumEntries();
  List<Student> studentElts = querySelectorAll("x-student");
  for(int i = 1; i <= studentElts.length; i++) {
    var studentElt = studentElts[i - 1];
    if (i > numEntries) {
      studentElt.style.display = "none";
    } else {
      studentElt.style.display = "block";
    }
  }
}
