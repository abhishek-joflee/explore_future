import 'dart:async';

void main(List<String> arguments) {
  print("1");
  scheduleMicrotask(() => print("2"));

  Future.delayed(Duration(seconds: 1), () => print("3"));

  Future(() => print("4")).then((_) => print("5")).then((_) {
    print("6");
    scheduleMicrotask(() => print("7"));
  }).then((_) => print("8"));

  scheduleMicrotask(() => print("9"));

  Future(() => print("10"))
      .then((_) => Future(() => print("11")))
      .then((_) => print("12"));

  Future(() => print("13"));
  scheduleMicrotask(() => print("14"));
  print("15");
}


//* START ISOLATE */
////--------------------------------------------////
//! ---MICRO : 14 9 2
//* ---EVENT : 3 | 13 10 4
//? --OUTPUT : 1 15
////--------------------------------------------////
//! ---MICRO :
//* ---EVENT : 3 | 13 10 4
//? --OUTPUT : 1 15 2 9 14
////--------------------------------------------////
//! ---MICRO : 7
//* ---EVENT : 3 | 13 10
//? --OUTPUT : 1 15 2 9 14 4 5 6
////--------------------------------------------////
//! ---MICRO :
//* ---EVENT : 3 | 13 10
//? --OUTPUT : 1 15 2 9 14 4 5 6 7 8
////--------------------------------------------////
//! ---MICRO :
//* ---EVENT : 3 | F(11) 13
//? --OUTPUT : 1 15 2 9 14 4 5 6 7 8 10
////--------------------------------------------////
//! ---MICRO :
//* ---EVENT : 3 | 12 11
//? --OUTPUT : 1 15 2 9 14 4 5 6 7 8 10 13
////--------------------------------------------////
//! ---MICRO :
//* ---EVENT : 3 |
//? --OUTPUT : 1 15 2 9 14 4 5 6 7 8 10 13 11 12
////--------------------------------------------////
//! ---MICRO :
//* ---EVENT :
//? --OUTPUT : 1 15 2 9 14 4 5 6 7 8 10 13 11 12 3
//* END ISOLATE */