package FP
import scala.annotation.tailrec

/*
  Created by Salvador Carrillo Fuentes
 */

/*
  This program shows:
    - the limitations of recursion
    - the importance of tail recursion in functional programming
 */

object RecursionAndTailRecursion extends App {

  // Recursive definition of the factorial function
  def factorial(n: Int): Int = {
    if (n <= 1) 1
    else {
      val result = n * factorial(n-1)
      result
    }
  }

  //println(factorial(50000)) // StackOverflowError
  //println(factorial(5)) // use with debugger

  // Tail-recursive definition of the factorial function
  @tailrec
  def factorialTR(n: Int, accumulator: BigInt = 1): BigInt = {
    if (n <= 1) accumulator
    else factorialTR(n-1, n*accumulator)
  }

  println(factorialTR(50000)) // use with debugger

}
