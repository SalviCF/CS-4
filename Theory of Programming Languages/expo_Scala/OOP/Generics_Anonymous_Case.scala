package OOP

/*
  Created by Salvador Carrillo Fuentes
 */

/*
This programs shows:
  1. Generics: Collections to store elements of an arbitrary type (reusable code)
          - Multiple generic parameters
          - Also works for traits
          - Generic methods
  2. Anonymous classes: instantiate on the spot
          - Works for classes (abstract or not) and traits
          - The compiler creates a class in the back automatically
          - The constructor arguments are required if needed
          - The members not implemented has to be implemented
  3. Case classes: boilerplate code is automatically implemented in lightweight data structures
          - 3.1. Class parameters are promoted to fields
          - 3.2. Sensible toString method
          - 3.3. equals and hashCode implemented (especially useful in collections)
          - 3.4. Handy copy method (also accepts parameters)
          - 3.5. Companion objects (with factory methods, no need of "new")
          - 3.6. Serializable
                    Useful in distributed systems
                    Send instances through the network and in between JVMs (Akka framework)
          - 3.7. Extractor patterns. Can be use in PATTERN MATCHING
          - 3.8. There are also case Objects. Same as case classes but without companion objects
 */

object Generics_Anonymous_Case extends App {

  /*
  1.
   */

  // Definition of generic class, a list of the generic parameter of type A
  class MyList[A]

  // We can fill the list with an arbitrary type
  val listOfInt = new MyList[Int]
  val listOfString = new MyList[String]

  // Multiple type parameters
  class MyMap[Key, Value]

  // Also works for traits
  trait OtherList[A]{
    def add(e: A) = ???
  }

  // Generic methods
  object MyList {
    def empty[A]: MyList[A] = ???
  }

  // Usage
  // val emptyListOfInt = MyList.empty[Int]

  /*
  2.
   */

  abstract class Animal(category: String) {
    def eat: Unit
  }

  // Anonymous class
  val sleepyAnimal = new Animal("feline") {
    def eat = println("zZz")
  }

  // What the compiler actually does is:
  /*
    class Generics_Anonymous_Case$$anon$1 extends Animal(category: String){
      def eat = println("zZz")
    }

    val sleepyAnimal: Animal = new Generics_Anonymous_Case$$anon$1("feline")
   */

  println(sleepyAnimal.getClass)

  /*
  3.
   */

  case class Person(name: String, age: Int)

  // 1. Class parameters are promoted to fields
  val person = new Person("Joe", 30)
  println(person.name)

  // 2. Sensible toString method
  println(person) // println(person.toString)

  // 3. equals and hashCode implemented (especially useful in collections)
  val person2 = new Person("Joe", 30)
  println(person == person2)

  // 4. Handy copy methods
  val person3 = person.copy(age = 35) // also accepts parameters
  println(person3)

  // 5. Companion objects (it's created automatically)
  val thePerson = Person // companion object of the case class
  val mary = Person("Mary", 28) // factory methods (does the same as the constructor, no need of "new")

  // 6. Serializable
  // Useful in distributed systems
  // Send instances through the network and in between JVMs (Akka framework)

  // 7. Extractor patterns. Can be use in PATTERN MATCHING

  // 8. There are also case Objects. Same as case classes but without companion objects
  case object Animal {
    def greet = println("I'm an animal")
  }
}
