import 'package:polymer/polymer.dart';
import 'package:sprintf/sprintf.dart';
import 'package:form_elements/full_name.dart';
import 'package:form_elements/address.dart';
import 'package:form_elements/email.dart';
import 'package:form_elements/phone_number.dart';
import 'dart:html';
import '../util.dart';
import '../student.dart';

const String _url = "https://api.parse.com/1/classes/Student";
const String _successUrl = "success.html";

int successfulSubmissions = 0;

void main() {
  initPolymer().run(() {
    queryId('numentries').onChange.listen((e) => numEntriesChanged());
    queryId('submit').onClick.listen((e) => submit(e));
  });
}

void onComplete(HttpRequest request) {
  _loadingGifOff();
  if (request.readyState == HttpRequest.DONE && request.status == 201) {
    successfulSubmissions++;
    if (successfulSubmissions == _getNumEntries()) {
      window.location.href = _successUrl;
    }
  } else {
    print("Status: " + request.status.toString());
    print("Response: " + request.responseText);
    window.alert("An error occured, please try again.");
  }
}

void submit(Event e) {
  e.preventDefault();

  String jsonFormat = '''
  {
    "address": "%s",
    "primaryEmail": "%s",
    "secondaryEmail": "%s",
    "phoneNumber": "%s",
    "name": "%s",
    "class": "%s",
    "birthday": "%s",
    "gender": "%s",
    "mother": "%s",
    "father": "%s"
  }
''';

  FullName mother = queryId('mother-name');
  FullName father = queryId('father-name');
  Address address = querySelector('x-address');
  Email email = queryId('primary-email');
  Email secondaryEmail = queryId('secondary-email');
  PhoneNumber phoneNumber = querySelector('x-phone-number');
  List<Student> students = querySelectorAll('x-student');
  assert(students.length != 0);
  
  List<String> errors = new List<String>();
  int numEntries = _getNumEntries();
  if (numEntries == 0) {
    errors.add("You must enroll at least one student");
  }
  
  for (int i = 0; i < numEntries; i++) {
    students[i].check(errors);
  }
  mother.check(errors);
  father.check(errors);
  address.check(errors);
  email.check(errors);
  secondaryEmail.check(errors);
  phoneNumber.check(errors);
  
  if (errors.isNotEmpty) {
    _displayErrors(errors);
    window.scrollTo(0, 0);
    return;
  }
  
  for (int i = 0; i < numEntries; i++) {
    HttpRequest request = new HttpRequest();
    request.open("POST", _url, async: false);
    request.setRequestHeader("Content-Type", "application/json");
    request.setRequestHeader("X-Parse-Application-Id", "AogX439PltSvXCM8XNKry0M5cdEDQE77s4rrFkJ1");
    request.setRequestHeader("X-Parse-REST-API-Key", "ucHeWSHsIhSlhjbO9S2w8qgM5IqxOwxNjbKWspQj");
    request.onReadyStateChange.listen((_) => onComplete(request));
    
    String jsonData = sprintf(jsonFormat,
                              [address.address,
                              email.email,
                              secondaryEmail.email,
                              phoneNumber.phoneNumber,
                              students[i].name,
                              students[i].className,
                              students[i].birthday,
                              students[i].gender,
                              mother.fullName,
                              father.fullName]);
    
    print(jsonData);
    request.send(jsonData);
  }
  _loadingGifOn();
}

void clearFields() {
  Address address = querySelector('x-address');
  Email email = querySelector('x-email');
  PhoneNumber phoneNumber = querySelector('x-phone-number');
  List<FullName> names = querySelectorAll('x-full-name');
  
  email.clear();
  address.clear();
  phoneNumber.clear();
  int numEntries = _getNumEntries();
  for (int i = 1; i <= numEntries; i++) {
    names[i].clear();
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

  int cost = 50;
  SpanElement costElt = queryId("cost");
  costElt.innerHtml = (cost * numEntries).toString();
}
