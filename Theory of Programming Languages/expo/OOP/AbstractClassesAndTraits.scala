package OOP

/*
  Created by Salvador Carrillo Fuentes
 */

/*
This programs shows:
  1. Abstract classes: partially implemented (methods and/or fields)
  2. Abstract classes cannot be instantiated. Subclass implements abstract members when extending
  3. Abstract classes VS Traits:
        3.1. Traits do not have constructor parameters
        3.2. Single class inheritance vs multiple trait inheritance
        3.3. Traits: behavior, Abstract class: nature ... what they do VS what they are (Animals)
        3.4. Using a class is more efficient
        3.5. If the code will be called from Java, use a class
 */

object AbstractClassesAndTraits extends App {

  // Abstract class definition
  abstract class Animal {
    val category: String
    def eat: Unit
  }

  // Extending an abstract class
  class Cat extends Animal with Carnivore with Mammal {
    val category: String = "feline"
    def eat = println("crunch crunch")
    def eat(food: String) = println(s"Eating $food")
  }

  // Trait definition
  trait Carnivore {
    val feeding = "meat"
    def eat(food: String)
  }

  // Another trait
  trait Mammal

  // Testing
  val cat = new Cat
  cat.eat
  cat.eat("meat")
  println(cat.feeding)
  println(cat.category)
}
