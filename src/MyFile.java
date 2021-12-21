interface Fruit {
    boolean eat();
 }
  
class Apple implements Fruit {
    public boolean eat() {
       peal();
       consume();
    }
  
    private void peal() { }
}