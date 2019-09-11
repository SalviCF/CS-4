package FP

/*
  Created by Salvador Carrillo Fuentes
 */

/*
  This program shows:
    - How Scala simulates functions
    - Intro to higher order functions and curried functions
 */

object WhatsAFunction extends App {

  // Function simulation (approach 1)
  trait MyFunction[A, B] {
    def apply(element: A): B
  }

  // Instance of MyFunction (example approach 1)
  val doubler = new MyFunction[Int, Int] {
    override def apply(element: Int): Int = element * 2
  }

  // Calling doubler like a function (approach 1)
  println(doubler(4))


  // Scala already have the function types by default
  // Function1[A, B] receives 1 parameter and return a result

  // Instance of Function1[A, B] (example approach 2)
  val stringToInt = new Function1[String, Int] {
    override def apply(cad: String): Int = cad.toInt
  }

  // Function call (approach 2)
  println(stringToInt("3") + 4)

  // Instance of Function2[A, B, C] (example approach 2)
  val adder = new Function2[Int, Int, Int] {
    override def apply(v1: Int, v2: Int): Int = v1 + v2
  }

  // Function call (approach 2)
  println(adder(4, 9))

  /*******************************************************************************************/

  // Scala support syntactic sugar for function types
  // Function2[A, B, R] === (A, B) => R

  // Instance of (A, B) => R (approach 3)
  val adder2: (Int, Int) => Int = new Function2[Int, Int, Int] {
    override def apply(v1: Int, v2: Int): Int = v1 + v2
  }

  // Instance of (A, B) => C (approach 4)
  val concat = new ((String, String) => String) {
    def apply(s1: String, s2: String): String = s1 + s2
  }

  // Function call (approach 4)
  println(concat("Hi,", "Scala"))

  /***************************************************************************************************/

  // Higher order function: takes a function as parameter or return a function as result
  // Instance of Function1[Int, Function1[Int, Int]] == (Int => (Int => Int))
  val superAdder = new (Int => (Int => Int)) {
    override def apply(x: Int): Int => Int = new (Int => Int) {
      override def apply(y: Int): Int = x + y
    }
  }

  // Calling HOF (higher order function)
  val add3 = superAdder(3) // add3 is a function that will add 3 to it's argument
  println(add3(5))

  // Currying: transform a function that takes more than one argument into a sequence of
  //  functions with a single argument
  // All you need are functions that take one argument
  // Take the first argument and return a function to apply to the second argument
  println(superAdder(3)(5))
}

