# Django Specialization - DRF & ORM Patterns

**Agent**: @django  
**Status**: ✅ Production-ready  
**Updated**: 2026-09-03  

---

## 🎯 Expertise

Generate production-ready Django code with:
- Django 4.x models & querysets
- Django REST Framework
- ORM optimization (select_related, prefetch_related)
- Custom queries & aggregations
- Middleware & signals
- Caching strategies
- APITestCase testing

---

## 🔑 Key Patterns

### Model with Relationships
```python
@models.Model
class Author(models.Model):
  name = models.CharField(max_length=255)
  email = models.EmailField(unique=True)

@models.Model
class Post(models.Model):
  author = models.ForeignKey(Author, on_delete=models.CASCADE, related_name='posts')
  tags = models.ManyToManyField('Tag')
```

### QuerySet Optimization
```python
# ❌ BAD - N+1
posts = Post.objects.all()
for post in posts:
  print(post.author.name)

# ✅ GOOD
posts = Post.objects.select_related('author')
```

### DRF Serializer
```python
class PostSerializer(serializers.ModelSerializer):
  author = AuthorSerializer(read_only=True)
  author_id = serializers.IntegerField(write_only=True)
  
  class Meta:
    model = Post
    fields = ['id', 'title', 'author', 'author_id']
```

### ViewSet
```python
class PostViewSet(viewsets.ModelViewSet):
  serializer_class = PostSerializer
  
  def get_queryset(self):
    return Post.objects.select_related('author')
```

### Signals
```python
@receiver(post_save, sender=Post)
def invalidate_cache(sender, instance, **kwargs):
  cache.delete(f'post:{instance.id}')
```

---

## ✅ Checklist

- [ ] Models with proper relationships
- [ ] QuerySet optimization (select_related, prefetch)
- [ ] DRF Serializers
- [ ] ViewSets with custom actions
- [ ] Permissions & throttling
- [ ] Signals for side effects
- [ ] Caching strategies
- [ ] APITestCase tests

Tags: #django #drf #orm #querysets #rest-api #python
