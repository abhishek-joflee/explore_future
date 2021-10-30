void main(List<String> arguments) {
  print("Start");

  Future(() => 1).then(print);
  Future(() => Future(() => 2)).then(print);

  Future.delayed(Duration(seconds: 1), () => 3).then(print);
  Future.delayed(Duration(seconds: 1), () => Future(() => 4)).then(print);

  Future.value(5).then(print);
  Future.value(Future(() => 6)).then(print);

  Future.sync(() => 7).then(print);
  Future.sync(() => Future(() => 8)).then(print);

  Future.microtask(() => 9).then(print);
  Future.microtask(() => Future(() => 10)).then(print);

  Future(() => 11).then(print);
  Future(() => Future(() => 12)).then(print);

  print("End");
}


//* START ISOLATE */
//* READ, MICRO, EVENT are QUEUES
////--------------------------------------------////
// -----READ : End 12 11 10 9 8 7 6 5 4 3 2 1 Start
//! ---MICRO :
//* ---EVENT :
//? --OUTPUT :
////--------------------------------------------////
// -----READ :
//! ---MICRO : F(10) 9 7 5
//* ---EVENT : F(4) 3 | F(12) 11 8 6 F(2) 1
//? --OUTPUT : Start End
////--------------------------------------------////
// -----READ :
//! ---MICRO :
//* ---EVENT : F(4) 3 | 10 F(12) 11 8 6 F(2) 1
//? --OUTPUT : Start End 5 7 9
////--------------------------------------------////
// -----READ :
//! ---MICRO :
//* ---EVENT : F(4) 3 | 12 2
//? --OUTPUT : Start End 5 7 9 1 6 8 11 10
////--------------------------------------------////
// -----READ :
//! ---MICRO :
//* ---EVENT : F(4) 3 |
//? --OUTPUT : Start End 5 7 9 1 6 8 11 10 2 12
////--------------------------------------------////
// -----READ :
//! ---MICRO :
//* ---EVENT : 4
//? --OUTPUT : Start End 5 7 9 1 6 8 11 10 2 12 3
////--------------------------------------------////
// -----READ :
//! ---MICRO :
//* ---EVENT :
//? --OUTPUT : Start End 5 7 9 1 6 8 11 10 2 12 3 4
////--------------------------------------------////
//* END ISOLATE */