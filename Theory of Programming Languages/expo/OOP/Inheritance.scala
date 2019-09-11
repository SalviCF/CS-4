package OOP

/*
  Created by Salvador Carrillo Fuentes
 */

/*
This programs shows:
  1. Single inheritance: can only extend one class
  2. The keyword "extends" implies inherit all non-private fields and methods
  3. Accessibility:
        - private: accessible within the class
        - protected: accessible within the class and subclasses
  4. Extending classes with parameters: JVM calls the constructor of the superclass first
  5. Overriding:
        - fields: can be overridden directly in the constructor
        - methods
  6. Type substitution (polymorphism): goes to the most overridden method
  7. Super: referencing parent class
  8. Preventing overrides:
        - keyword "final" on member
        - keyword "final" on the entire class (prevents extension)
        - keyword "sealed" on the class: allows extending in THIS file but not in others
 */

object Inheritance extends App {

  // Superclass
  class Animal(category: String) {
    val domestic = false
    def eat = println("ñam ñam")
    final protected def sleep = println("zZz") // cannot be overridden
    private def swim = println("glop glop")
  }

  // Subclass
  class Cat(category: String, override val domestic: Boolean = true) extends Animal(category) {
    // override val domestic: Boolean = true // overriding parent field
    def meow = {
      sleep // can be accessed from subclass
      println("miau miau")
    }
    override def eat = {
      super.eat // accessing to the parent definition
      println("crunch crunch") // overriding parent method
    }
  }

  // Testing
  val cat = new Cat("feline") // instantiation

  cat.eat
  println()

  cat.meow
  println()
  // cat.sleep // this does not work

  println(cat.domestic)
  println()

  val unknownAnimals: Animal = new Cat("feline") // type substitution (polymorphism)
  unknownAnimal.eat // goes to the most overridden method

  val unknownAnimal: Animal = new Cat("feline")
  unknownAnimal.eat
}
