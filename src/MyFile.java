interface Fruit {
    boolean eat();
 }
  
class Apple implements Fruit {
    public boolean eat() {
       peal();
       consume();
       return false;
    }
  
    private void consume() {
    }

    private void peal() { }
}