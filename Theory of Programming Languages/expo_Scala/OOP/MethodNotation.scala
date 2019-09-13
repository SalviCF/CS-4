package OOP

/*
  Created by Salvador Carrillo Fuentes
 */

/*
This programs shows:
  1. Operators in Scala are methods
  2. Different notations for calling methods (closer to natural language)
      2.1 Infix notation
      2.2 Prefix notation
      2.3 Postfix notation
  3. The apply() method: link between OOP and FP
 */

object MethodNotation extends App {

  // Instantiation
  val salvi = new Person("Salvi", "Inception")
  val angela = new Person("Angela", "Harry Potter")

  // 1. Operators in Scala are methods
  println(1 + 2)
  println(1.+(2))
  println(1.+(2.+(3)))
  println()


  // Method notation

  // 2.1 INFIX notation (for methods with 1 parameter)
  println(salvi.likes("Inception"))
  println(salvi likes "Inception")
  println()

  println(salvi + angela)
  println(salvi.+(angela))
  println()

  // 2.2 PREFIX notation (unary operators. unary_ only works with + - ~ !)
  val x = -1
  val y = 1.unary_-
  println(s"x = $x  and y = $y")
  println()

  println(!salvi)
  println(salvi.unary_!)
  println()

  // 2.3 POSTFIX notation (for parameter-less methods)
  println(salvi.isAlive)
  println(salvi isAlive)

  salvi.isAlive
  salvi isAlive

  // 3. The apply() method: link between OOP and FP
  println(salvi.apply())
  println(salvi()) // calling "salvi" like if it were a function

  salvi.apply()
  salvi()
}

// Class implementation
class Person(val name: String, favoriteMovie: String){

  def likes(movie: String): Boolean = movie == favoriteMovie  // infix
  def +(person: Person): String = s"$name is hanging out with ${person.name}" // infix
  def unary_! : String = s"${name.toUpperCase}!!!" // prefix
  def isAlive: Boolean = true // postfix

  def apply():String = s"Hi, my name is $name and I like $favoriteMovie"
}

