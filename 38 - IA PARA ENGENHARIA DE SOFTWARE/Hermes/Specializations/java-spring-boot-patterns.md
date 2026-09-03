# Java Specialization - Spring Boot Patterns

**Agent**: @java  
**Status**: ✅ Production-ready  
**Updated**: 2026-09-03  

---

## 🎯 Expertise

Generate production-ready Spring Boot APIs with:
- Spring Boot 3.x architecture
- JPA/Hibernate ORM
- Spring Data repositories
- Design patterns (SOLID)
- Exception handling
- Testing (JUnit 5, Mockito, MockMvc)

---

## 🔑 Key Patterns

### Entity with Relationships
```java
@Entity
@Table(name = "users")
public class User {
  @Id @GeneratedValue
  private Long id;
  
  @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
  private List<Order> orders;
}
```

### Repository
```java
@Repository
public interface UserRepository extends JpaRepository<User, Long> {
  Optional<User> findByEmail(String email);
}
```

### Service with Transaction
```java
@Service
@Transactional
public class UserService {
  public User createUser(UserDTO dto) { }
}
```

### Controller
```java
@RestController
@RequestMapping("/api/users")
public class UserController {
  @PostMapping
  public ResponseEntity<User> create(@RequestBody UserDTO dto) { }
}
```

### Exception Handler
```java
@RestControllerAdvice
public class GlobalExceptionHandler {
  @ExceptionHandler(UserNotFoundException.class)
  public ResponseEntity<ErrorResponse> handleNotFound(UserNotFoundException ex) { }
}
```

### Testing
```java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {
  @Mock private UserRepository repository;
  @InjectMocks private UserService service;
  
  @Test void shouldCreateUser() { }
}
```

---

## ✅ Checklist

- [ ] @RestController with @RequestMapping
- [ ] @Service with @Transactional
- [ ] @Repository extending JpaRepository
- [ ] DTO for request/response
- [ ] Custom exceptions
- [ ] Global exception handler
- [ ] SOLID principles applied
- [ ] JUnit 5 tests
- [ ] Mockito mocks
- [ ] MockMvc integration tests

---

## 📖 References

- Spring Boot: https://spring.io/projects/spring-boot
- JPA: https://hibernate.org/
- JUnit 5: https://junit.org/junit5/

Tags: #java #spring-boot #jpa #hibernate #junit5 #mockito #rest-api
