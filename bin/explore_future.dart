void main(List<String> arguments) {
  print("Start");

  Future(() => 1).then(print);
  Future(() => Future(() => 2)).then(print);

  // when duration is zero
  Future.delayed(Duration(seconds: 0), () => 3).then(print);
  // => Future(() => 3);
  Future.delayed(Duration(seconds: 0), () => Future(() => 4)).then(print);
  // Future(() => Future(() => 4));

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
//* ---EVENT : F(12) 11 8 6 F(4) 3 F(2) 1
//? --OUTPUT : Start End
////--------------------------------------------////
// -----READ :
//! ---MICRO :
//* ---EVENT : 10 F(12) 11 8 6 F(4) 3 F(2) 1
//? --OUTPUT : Start End 5 7 9
////--------------------------------------------////
// -----READ :
//! ---MICRO :
//* ---EVENT : 12 4 2
//? --OUTPUT : Start End 5 7 9 1 3 6 8 11 10
////--------------------------------------------////
// -----READ :
//! ---MICRO :
//* ---EVENT :
//? --OUTPUT : Start End 5 7 9 1 6 8 11 10 2 4 12
//* END ISOLATE */