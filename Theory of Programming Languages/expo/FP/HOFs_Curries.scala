package FP

/*
  Created by Salvador Carrillo Fuentes
 */

/*
  This program shows:
    - Higher order functions (HOFs): takes a function as a parameter or
        return a function as result
    - Currying: is the technique of translating the evaluation of a function
        that takes multiple arguments into evaluating a sequence of functions,
        each with a single argument.
 */

object HOFs_Curries extends App {

  // Higher order function
  // Function that applies another function f, n times over a value x
  // nTimes(f, 3, x) = f(f(f(x)))
  def nTimes(f: Int => Int, n: Int, x: Int): Int =
    if (n <= 0) x
    else nTimes(f, n-1, f(x))

  // Instance
  val nTim: (Int => Int, Int, Int) => Int = { (f, n, x) =>
    if (n <= 0) x
    else nTim(f, n-1, f(x))
  }

  // Successor function (for testing nTimes)
  val suc: Int => Int = _ + 1

  println(nTimes(suc, 3, 2))
  println(nTim(suc, 3, 2))

  // Returning a lambda
  // nTimesL(f, 3) = ( x => f(f(f(x))) )
  def nTimesL(f: Int => Int, n: Int): (Int => Int) =
    if (n <= 0) (x => x)
    else ( x => nTimesL(f, n-1)(f(x)) )

  /*
  nTimesL(suc, 2) =
  ( x => nTimesL(suc, 1)(suc(x)) ) =
  ( x => ( x => nTimesL(suc, 0)(suc(x)) )(suc(x)) ) =
  ( x => ( x => (x => x)(suc(x)) )(suc(x)) ) =
    x =>         f          f(x)
  ( x => ( x => (suc(x)) )(suc(x)) ) =
  ( x => suc(suc(x)) )
   */

  // inc10 is a function that applies suc 10 times to it's param
  val inc10 = nTimesL(suc, 10)
  println(inc10(4))

  // Curried functions (useful to define helper functions to use on different values)
  val adder: (Int, Int) => Int = (x, y) => x + y
  val superAdder: Int => (Int => Int) = x => (y => x + y)

  val add5 = superAdder(5)

  println(add5(6))
  println(superAdder(5)(6))

  /***************************************************************************************/

  // Functions with multiple parameter lists (to act like curried functions)
  def curriedFeel(emotion: String)(name: String): String = s"$name is $emotion"

  // Return type is mandatory
  val angry: (String => String) = curriedFeel("angry")
  val happy: (String => String) = curriedFeel("happy")

  println(angry("Joe"))
  println(happy("Mary"))

  // With more than one param per list
  def ageAndFeel(emotion: String, age: Int)(name: String): String =
    s"My name is $name, I'm $age years old and I'm feeling $emotion"

  val hungry: (String => String) = ageAndFeel("hungry", 30)
  println(hungry("Peter"))

  println()

  /***************************************************************************/

  // def vs val
  // def evaluates on call and creates new function every time (new instance)
  // val evaluates when defined, def when called
  val test: () => Int = {
    val r = util.Random.nextInt
    () => r
  }

  println(test())
  println(test()) // same result

  def test2: () => Int = {
    val r = util.Random.nextInt
    () => r
  }

  println(test2())
  println(test2()) // new result

  // Notes on performance
  /*
  val evaluates when defined.

  def evaluates on every call, so performance could be worse than val for multiple calls.
   */
}
