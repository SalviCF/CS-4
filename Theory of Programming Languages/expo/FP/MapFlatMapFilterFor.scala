package FP

/*
  Created by Salvador Carrillo Fuentes
 */

/*
  This program shows:
    - Some methods of the Scala API for List including:
        · map: applies a function to all elements in the list
        · filter: selects all elements which satisfy a predicate
        · flatMap: applies a function that returns a sequence for each element in the list,
                   and flattens the results into the original list
        · foreach: applies a function f to all elements of a list but returns Unit
        · for-comprehensions: makes more readable chains like xs.flatMap(x => ys.flatMap(y => zs.map(z => ...)))
 */

object MapFlatMapFilterFor extends App {

  // https://www.scala-lang.org/api/current/

  // Creating a List by calling the apply() method on the List companion Object
  val list = List(1, 2, 3, 4)
  println("list: " + list)
  println()

  /* Some methods */
  println("Head: " + list.head)
  println("Tail: " + list.tail)
  println("list is empty? " + list.isEmpty)
  println("Reverse: " + list.reverse)
  println("Self zip: " + list.zip(list))

  // map
  println("Adding 1 to each element: " + list.map(_ + 1))

  // filter
  println("Elements >= 3? " + list.filter(_ >= 3))

  // flatMap: map + flatten
  val minusPlus: (Int => List[Int]) = x => List(x-1, x+1)
  println(list.flatMap(minusPlus))
  println(list.map(minusPlus).flatten)

  // printing all combinations between two lists
  // List("a1", "a2", ... , "d4")
  val numbers = List(1, 2, 3, 4)
  val chars = List('a','b','c','d')

  // imperative: two loops ... FP: flatMap + map
  // Applies a function f to each (map) n in "numbers"
  // f takes a n of "numbers" and returns a List[List[String]]
  // Each List[String] is formed by applying another function g to each (map) c in "chars"
  // g takes a c of "chars" and returns a string with the concatenation of c and n
  // Finally, flatten the resulting List[List[String]]
  val comb = numbers.flatMap(n => chars.map(c => s"$c$n"))
  println(comb)

  // imperative: three loops ... FP: flatMap + flatMap + map
  val colors = List("black", "white")

  val comb2 = numbers.flatMap(n => chars.flatMap(c => colors.map(co => s"$c$n-$co")))
  println(comb2)

  // foreach
  numbers.foreach(println)
  numbers.foreach(n => println(s"Number: $n"))

  // for-comprehensions (more readable) (rewritten by compiler as a chain of map, flatMap and filter)
  val forComb = for {
    n <- numbers
    c <- chars
    co <- colors
  } yield s"$c$n-$co"

  println(forComb)

  // Also, we can do some filtering (guards)
  val forCombEven = for {
    n <- numbers if (n % 2 == 0) // compiler inserts filter(_ % 2 == 0)
    c <- chars
    co <- colors
  } yield if (co == "black") s"B[$c$n-${co}]B" else s"W[$c$n-${co}]W"

  println(forCombEven)

  // Returning Unit (side-effects), equivalent to numbers.foreach(println)
  for {
    n <- numbers
  } println(n)

  // Syntax overload (sometimes used)
  println(numbers.map { x =>
    x * 2
  })

  // fold, foldRight, foldLeft
  // fold is allowed to be a tree operation, which is quite nice for parallelization
  val sum = numbers.fold(0)(_+_)
  val length = numbers.foldLeft(0)((acc, e) => acc + 1) // shorthand /:

  println(sum)
  println(numbers.foldRight(0)(_+_)) // shorthand :\
  println(length)

}
