package FP

/*
  Created by Salvador Carrillo Fuentes
 */

/*
  This program shows:
    - Anonymous functions (Lambdas): more syntactic sugar for instantiate functions
 */

object AnonymousFunctions extends App {

  // Equivalent notations (1 parameter)
  val doubler = (x: Int) => x * 2

  val doubler_2: Int => Int = x => x * 2

  // Equivalent notations (multiple parameters)
  val adders = (x: Int, y: Int) => x + y

  val adder_2: (Int, Int) => Int = (x, y) => x + y

  // Equivalent notations (no parameters)
  // When using lambdas, calling with () is mandatory: println(return7())
  val return7 = () => 7

  val return7_2: () => Int = () => 7

  // Common style (curly braces)
  val stringToInt = { (s: String) =>
    s.toInt
  }

  // More syntactic sugar
  val suc: Int => Int = _ + 1 // x => x + 1

  val multi: (Int, Int) => Int = _ * _ // (x, y) => x + y

  /***************************************************************************************/

  // Curried function write as an anonymous function
  val superAdder = (x: Int) => ((y: Int) => x + y)

  val superAdder_2: Int => (Int => Int) = x => (y => x + y)

  println(superAdder(3)(7))
  println(superAdder_2(3)(7))
}
