# Java Design Patterns

## Padrões Criacionais

### 1. Singleton
```java
public class DatabaseConnection {
  private static DatabaseConnection instance;
  
  private DatabaseConnection() {}
  
  public static DatabaseConnection getInstance() {
    if (instance == null) {
      instance = new DatabaseConnection();
    }
    return instance;
  }
}
```

### 2. Factory Method
```java
public interface Animal {
  void makeSound();
}

public class Dog implements Animal {
  @Override
  public void makeSound() { System.out.println("Woof!"); }
}

public class AnimalFactory {
  public Animal createAnimal(String type) {
    switch (type.toLowerCase()) {
      case "dog": return new Dog();
      case "cat": return new Cat();
      default: throw new IllegalArgumentException("Unknown animal");
    }
  }
}
```

### 3. Builder
```java
public class User {
  private String name;
  private int age;
  private String email;
  
  public static class Builder {
    private User user = new User();
    
    public Builder name(String name) {
      user.name = name;
      return this;
    }
    
    public Builder age(int age) {
      user.age = age;
      return this;
    }
    
    public Builder email(String email) {
      user.email = email;
      return this;
    }
    
    public User build() { return user; }
  }
}

// Uso: User user = new User.Builder()
//   .name("João")
//   .age(25)
//   .build();
```

### 4. Abstract Factory
```java
public interface Button {}
public class WindowsButton implements Button {}
public class MacButton implements Button {}

public interface GUIFactory {
  Button createButton();
}
```

## Padrões Estruturais

### 1. Adapter
```java
// Adapata interface de uma classe para outra
public class ShapeAdapter implements Shape {
  private LegacyShape legacyShape;
  
  public ShapeAdapter(LegacyShape shape) {
    this.legacyShape = shape;
  }
  
  @Override
  public void draw() {
    legacyShape.drawShape();
  }
}
```

### 2. Decorator
```java
public abstract class CoffeeDecorator extends Coffee {
  protected Coffee coffee;
  
  public CoffeeDecorator(Coffee coffee) {
    this.coffee = coffee;
  }
  
  @Override
  public String getDescription() {
    return coffee.getDescription();
  }
}

public class MilkDecorator extends CoffeeDecorator {
  public MilkDecorator(Coffee coffee) {
    super(coffee);
  }
  
  @Override
  public double getCost() {
    return super.getCost() + 0.5;
  }
  
  @Override
  public String getDescription() {
    return super.getDescription() + ", Milk";
  }
}
```

### 3. Facade
```java
// Simplifica interface de um subsistema
public class ComputerFacade {
  private CPU cpu;
  private Memory memory;
  private HardDrive hd;
  
  public void start() {
    cpu.free();
    memory.allocate();
    hd.read();
  }
}
```

### 4. Proxy
```java
public interface Image {
  void display();
}

public class RealImage implements Image {
  private String filename;
  
  public RealImage(String filename) {
    this.filename = filename;
    loadFromDisk();
  }
  
  @Override
  public void display() {
    System.out.println("Displaying " + filename);
  }
}

public class ProxyImage implements Image {
  private String filename;
  private RealImage realImage;
  
  public ProxyImage(String filename) {
    this.filename = filename;
  }
  
  @Override
  public void display() {
    if (realImage == null) {
      realImage = new RealImage(filename); // Lazy loading
    }
    realImage.display();
  }
}
```

## Padrões de Comportamento

### 1. Observer
```java
public interface Observer {
  void update(String message);
}

public class Subject {
  private List<Observer> observers = new ArrayList<>();
  
  public void addObserver(Observer o) {
    observers.add(o);
  }
  
  public void removeObserver(Observer o) {
    observers.remove(o);
  }
  
  public void notifyObservers(String message) {
    for (Observer o : observers) {
      o.update(message);
    }
  }
}
```

### 2. Strategy
```java
public interface PaymentStrategy {
  void pay(double amount);
}

public class CreditCardStrategy implements PaymentStrategy {
  @Override
  public void pay(double amount) {
    System.out.println("Paid " + amount + " with credit card");
  }
}

public class ShoppingCart {
  private PaymentStrategy paymentStrategy;
  
  public void setPaymentStrategy(PaymentStrategy strategy) {
    this.paymentStrategy = strategy;
  }
  
  public void checkout(double amount) {
    paymentStrategy.pay(amount);
  }
}
```

### 3. Command
```java
public interface Command {
  void execute();
}

public class LightOnCommand implements Command {
  private Light light;
  
  public LightOnCommand(Light light) {
    this.light = light;
  }
  
  @Override
  public void execute() {
    light.turnOn();
  }
}
```

### 4. Template Method
```java
public abstract class DataProcessor {
  public final void process() {
    readData();
    processData();
    saveData();
  }
  
  protected abstract void readData();
  protected abstract void processData();
  
  protected void saveData() {
    System.out.println("Saving data...");
  }
}
```

## Padrões de Arquitetura

### MVC (Model-View-Controller)
```java
// Model
public class User {
  private String name;
  private String email;
}

// View
public class UserView {
  public void printUserDetails(String name, String email) {
    System.out.println("User: " + name + ", Email: " + email);
  }
}

// Controller
public class UserController {
  private User model;
  private UserView view;
  
  public void updateUserView() {
    view.printUserDetails(model.getName(), model.getEmail());
  }
}
```

## Tags
#java #designpatterns #oop #architecture

---

## 🇧🇷 Tradução em Português

# Padrões de Projeto em Java

## Padrões Criacionais

### 1. Singleton
```java
public class DatabaseConnection {
  private static DatabaseConnection instance;
  
  private DatabaseConnection() {}
  
  public static DatabaseConnection getInstance() {
    if (instance == null) {
      instance = new DatabaseConnection();
    }
    return instance;
  }
}
```

### 2. Factory Method
```java
public interface Animal {
  void makeSound();
}

public class Dog implements Animal {
  @Override
  public void makeSound() { System.out.println("Woof!"); }
}

public class AnimalFactory {
  public Animal createAnimal(String type) {
    switch (type.toLowerCase()) {
      case "dog": return new Dog();
      case "cat": return new Cat();
      default: throw new IllegalArgumentException("Unknown animal");
    }
  }
}
```

### 3. Builder
```java
public class User {
  private String name;
  private int age;
  private String email;
  
  public static class Builder {
    private User user = new User();
    
    public Builder name(String name) {
      user.name = name;
      return this;
    }
    
    public Builder age(int age) {
      user.age = age;
      return this;
    }
    
    public Builder email(String email) {
      user.email = email;
      return this;
    }
    
    public User build() { return user; }
  }
}

// Uso: User user = new User.Builder()
//   .name("João")
//   .age(25)
//   .build();
```

### 4. Abstract Factory
```java
public interface Button {}
public class WindowsButton implements Button {}
public class MacButton implements Button {}

public interface GUIFactory {
  Button createButton();
}
```

## Padrões Estruturais

### 1. Adapter
```java
// Adapta a interface de uma classe para outra
public class ShapeAdapter implements Shape {
  private LegacyShape legacyShape;
  
  public ShapeAdapter(LegacyShape shape) {
    this.legacyShape = shape;
  }
  
  @Override
  public void draw() {
    legacyShape.drawShape();
  }
}
```

### 2. Decorator
```java
public abstract class CoffeeDecorator extends Coffee {
  protected Coffee coffee;
  
  public CoffeeDecorator(Coffee coffee) {
    this.coffee = coffee;
  }
  
  @Override
  public String getDescription() {
    return coffee.getDescription();
  }
}

public class MilkDecorator extends CoffeeDecorator {
  public MilkDecorator(Coffee coffee) {
    super(coffee);
  }
  
  @Override
  public double getCost() {
    return super.getCost() + 0.5;
  }
  
  @Override
  public String getDescription() {
    return super.getDescription() + ", Milk";
  }
}
```

### 3. Facade
```java
// Simplifica a interface de um subsistema
public class ComputerFacade {
  private CPU cpu;
  private Memory memory;
  private HardDrive hd;
  
  public void start() {
    cpu.free();
    memory.allocate();
    hd.read();
  }
}
```

### 4. Proxy
```java
public interface Image {
  void display();
}

public class RealImage implements Image {
  private String filename;
  
  public RealImage(String filename) {
    this.filename = filename;
    loadFromDisk();
  }
  
  @Override
  public void display() {
    System.out.println("Displaying " + filename);
  }
}

public class ProxyImage implements Image {
  private String filename;
  private RealImage realImage;
  
  public ProxyImage(String filename) {
    this.filename = filename;
  }
  
  @Override
  public void display() {
    if (realImage == null) {
      realImage = new RealImage(filename); // Carregamento tardio (lazy loading)
    }
    realImage.display();
  }
}
```

## Padrões de Comportamento

### 1. Observer
```java
public interface Observer {
  void update(String message);
}

public class Subject {
  private List<Observer> observers = new ArrayList<>();
  
  public void addObserver(Observer o) {
    observers.add(o);
  }
  
  public void removeObserver(Observer o) {
    observers.remove(o);
  }
  
  public void notifyObservers(String message) {
    for (Observer o : observers) {
      o.update(message);
    }
  }
}
```

### 2. Strategy
```java
public interface PaymentStrategy {
  void pay(double amount);
}

public class CreditCardStrategy implements PaymentStrategy {
  @Override
  public void pay(double amount) {
    System.out.println("Paid " + amount + " with credit card");
  }
}

public class ShoppingCart {
  private PaymentStrategy paymentStrategy;
  
  public void setPaymentStrategy(PaymentStrategy strategy) {
    this.paymentStrategy = strategy;
  }
  
  public void checkout(double amount) {
    paymentStrategy.pay(amount);
  }
}
```

### 3. Command
```java
public interface Command {
  void execute();
}

public class LightOnCommand implements Command {
  private Light light;
  
  public LightOnCommand(Light light) {
    this.light = light;
  }
  
  @Override
  public void execute() {
    light.turnOn();
  }
}
```

### 4. Template Method
```java
public abstract class DataProcessor {
  public final void process() {
    readData();
    processData();
    saveData();
  }
  
  protected abstract void readData();
  protected abstract void processData();
  
  protected void saveData() {
    System.out.println("Saving data...");
  }
}
```

## Padrões de Arquitetura

### MVC (Model-View-Controller)
```java
// Model
public class User {
  private String name;
  private String email;
}

// View
public class UserView {
  public void printUserDetails(String name, String email) {
    System.out.println("User: " + name + ", Email: " + email);
  }
}

// Controller
public class UserController {
  private User model;
  private UserView view;
  
  public void updateUserView() {
    view.printUserDetails(model.getName(), model.getEmail());
  }
}
```

## Tags
#java #designpatterns #oop #arquitetura
