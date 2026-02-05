# ALX Backend Storage

## Overview

The alx-backend-storage repository is a comprehensive curriculum covering data storage and management techniques essential for backend development. This curriculum covers relational databases (SQL), NoSQL databases, caching systems, and other storage solutions. You will learn how to design efficient databases, write optimized queries, implement caching strategies, and manage data effectively in production environments.

## Learning Path

The curriculum is organized progressively to build storage expertise:

1. **SQL Fundamentals** - Database design, queries, and relationships
2. **Advanced SQL** - Complex queries, optimization, and administration
3. **MySQL/PostgreSQL** - Relational database systems
4. **NoSQL Databases** - MongoDB, document-based storage
5. **Redis & Caching** - In-memory data structures, caching strategies
6. **Database Design** - Schema design, normalization, relationships
7. **Performance Optimization** - Indexing, query optimization
8. **Backup & Recovery** - Data persistence and safety
9. **Data Migration** - Moving and transforming data
10. **Real-time Databases** - Firebase, real-time data sync

## Repository Structure

```
alx-backend-storage/
├── 0x00-SQL_introduction/
│   ├── 0-list_databases.sql
│   ├── 1-create_database.sql
│   ├── 2-delete_database.sql
│   ├── 3-list_tables.sql
│   ├── 4-first_table.sql
│   ├── 5-full_description.sql
│   ├── 6-list_values.sql
│   ├── 7-insert_value.sql
│   ├── 8-count_records.sql
│   ├── 9-full_creation.sql
│   ├── 10-million_dollars_hanged.sql
│   ├── 11-best_score.sql
│   ├── 12-cheating_students.sql
│   ├── 13-change_class.sql
│   ├── 14-average_score.sql
│   ├── 15-groups.sql
│   └── README.md
├── 0x01-SQL_more_queries/
│   ├── 0-privileges.sql
│   ├── 1-create_user.sql
│   ├── 2-create_read_user.sql
│   ├── 3-set_password.sql
│   ├── 4-create_db_user.sql
│   ├── 5-create_unique_id.sql
│   ├── 6-states.sql
│   ├── 7-cities.sql
│   ├── 8-cities_of_california.sql
│   ├── 9-cities_by_state_join.sql
│   ├── 10-genre_id_by_show.sql
│   ├── 11-genre_id_all_shows.sql
│   ├── 12-no_genre.sql
│   ├── 13-count_shows_by_genre.sql
│   ├── 14-my_genres.sql
│   ├── 15-comedy_only.sql
│   ├── 16-shows_by_genre.sql
│   └── README.md
├── 0x02-redis_basic/
│   ├── exercise.py
│   ├── main.py
│   └── README.md
├── 0x03-querying_databases/
│   ├── queries.py
│   ├── database.py
│   └── README.md
├── 0x04-MySQL_Advanced/
│   ├── 0-uniq_users.sql
│   ├── 1-countries.sql
│   ├── 2-fans.sql
│   ├── 3-glam_rock.sql
│   ├── 4-store.sql
│   ├── 5-valid_email.sql
│   ├── 6-bonus.sql
│   ├── 7-average_weighted_score.sql
│   ├── 8-index_my_names.sql
│   ├── 9-index_name_first.sql
│   ├── 10-div.sql
│   ├── 11-need_meeting.sql
│   ├── 12-no_tablename.sql
│   ├── 13-count_all_by_user_id.sql
│   ├── 14-average_weighted_score_for_user.sql
│   └── README.md
├── 0x05-MongoDB/
│   ├── 0-list_databases.js
│   ├── 1-create_database.js
│   ├── 2-insert_school.js
│   ├── 3-all_documents.js
│   ├── 4-match.js
│   ├── 5-more_filter.js
│   ├── 6-update.js
│   ├── 7-delete.js
│   ├── 8-find.js
│   ├── 9-update_todos_i_d.js
│   ├── 10-update_school_by_name.js
│   ├── 11-delete_by_country.js
│   ├── 12-bulk_operations.js
│   └── README.md
├── 0x06-NoSQL/
│   ├── redis_operations.py
│   ├── mongodb_operations.py
│   └── README.md
├── README.md
└── resources/
    ├── SQL_basics.md
    ├── database_design.md
    ├── indexing_optimization.md
    └── backup_recovery.md
```

## Key Modules by Section

### 0x00: SQL Introduction

**Topics:**
- Database creation and deletion
- Table creation and structure
- Data insertion and querying
- Basic SELECT, INSERT, UPDATE operations
- Aggregation functions (COUNT, SUM, AVG, MAX, MIN)
- WHERE, ORDER BY, GROUP BY clauses

**Sample Commands:**
```sql
-- Create database
CREATE DATABASE my_database;

-- Create table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    age INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert data
INSERT INTO users (name, email, age) 
VALUES ('John Doe', 'john@example.com', 30);

-- Query data
SELECT * FROM users WHERE age > 25;

-- Aggregate functions
SELECT COUNT(*) FROM users;
SELECT AVG(age) FROM users;

-- Group by
SELECT age, COUNT(*) FROM users GROUP BY age;

-- Order by
SELECT * FROM users ORDER BY age DESC;
```

### 0x01: SQL More Queries

**Topics:**
- User and privilege management
- Constraints (PRIMARY KEY, FOREIGN KEY, UNIQUE)
- JOIN operations (INNER, LEFT, RIGHT)
- Subqueries
- Set operations (UNION, EXCEPT)

**Key Concepts:**
```sql
-- Create user
CREATE USER 'user'@'localhost' IDENTIFIED BY 'password';

-- Grant privileges
GRANT SELECT ON database.* TO 'user'@'localhost';

-- Foreign key
CREATE TABLE posts (
    id INT PRIMARY KEY,
    user_id INT,
    content TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- INNER JOIN
SELECT u.name, p.content 
FROM users u
INNER JOIN posts p ON u.id = p.user_id;

-- LEFT JOIN
SELECT u.name, p.content
FROM users u
LEFT JOIN posts p ON u.id = p.user_id;

-- Subquery
SELECT * FROM users 
WHERE id IN (SELECT user_id FROM posts);

-- UNION
SELECT name FROM users
UNION
SELECT title FROM posts;
```

### 0x02: Redis Basic

**Topics:**
- Redis fundamentals
- Data structures (strings, lists, sets, hashes)
- Key-value operations
- Expiration and TTL
- Python Redis client

**Example:**
```python
import redis

# Connect to Redis
r = redis.Redis(host='localhost', port=6379, db=0)

# String operations
r.set('key', 'value')
value = r.get('key')

# List operations
r.lpush('mylist', 'item1', 'item2')
items = r.lrange('mylist', 0, -1)

# Set operations
r.sadd('myset', 'member1', 'member2')
members = r.smembers('myset')

# Hash operations
r.hset('myhash', 'field1', 'value1')
value = r.hget('myhash', 'field1')

# Expiration
r.setex('tempkey', 3600, 'value')  # Expires in 1 hour
```

### 0x03: Querying Databases

**Topics:**
- Database connection
- Query execution
- Result processing
- Error handling
- Connection pooling

**Example:**
```python
import mysql.connector
from mysql.connector import Error

try:
    connection = mysql.connector.connect(
        host='localhost',
        user='root',
        password='password',
        database='mydb'
    )
    
    cursor = connection.cursor()
    query = "SELECT * FROM users WHERE age > %s"
    cursor.execute(query, (18,))
    
    results = cursor.fetchall()
    for row in results:
        print(row)
    
    cursor.close()
    connection.close()
    
except Error as e:
    print(f"Error: {e}")
```

### 0x04: MySQL Advanced

**Topics:**
- Views
- Triggers
- Stored procedures
- Indexes and optimization
- Transactions
- Complex queries

**Example:**
```sql
-- Create view
CREATE VIEW user_posts AS
SELECT u.id, u.name, COUNT(p.id) as post_count
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id;

-- Create index
CREATE INDEX idx_email ON users(email);

-- Create trigger
DELIMITER $$
CREATE TRIGGER update_timestamp
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
END $$
DELIMITER ;

-- Stored procedure
DELIMITER $$
CREATE PROCEDURE get_user_by_id(IN user_id INT)
BEGIN
    SELECT * FROM users WHERE id = user_id;
END $$
DELIMITER ;

-- Call procedure
CALL get_user_by_id(1);
```

### 0x05: MongoDB

**Topics:**
- Document-oriented databases
- Collections and documents
- CRUD operations
- Indexing
- Aggregation pipeline

**Example:**
```javascript
// Connect to MongoDB
const client = new MongoClient("mongodb://localhost:27017");

// Insert documents
db.collection("users").insertOne({
    name: "John",
    email: "john@example.com",
    age: 30
});

// Find documents
const users = await db.collection("users").find({
    age: { $gt: 25 }
}).toArray();

// Update documents
await db.collection("users").updateOne(
    { _id: ObjectId("...") },
    { $set: { age: 31 } }
);

// Delete documents
await db.collection("users").deleteOne({
    _id: ObjectId("...")
});

// Aggregation
const results = await db.collection("users").aggregate([
    { $match: { age: { $gt: 25 } } },
    { $group: { _id: "$age", count: { $sum: 1 } } }
]).toArray();
```

### 0x06: NoSQL Operations

**Topics:**
- Redis advanced operations
- MongoDB operations
- Data caching strategies
- Session management

## Requirements

### General Requirements

- Allowed editors: `vi`, `vim`, `emacs`
- All files will be tested on Ubuntu 18.04 LTS or Ubuntu 20.04 LTS
- All files should end with a newline
- A `README.md` file at the root is mandatory
- Code should follow PEP 8 style (for Python)
- All modules should have documentation
- All classes and functions should be documented

### Installation Requirements

#### MySQL/MariaDB
```bash
sudo apt-get install -y mysql-server mysql-client
mysql --version
```

#### MongoDB
```bash
sudo apt-get install -y mongodb
mongod --version
```

#### Redis
```bash
sudo apt-get install -y redis-server redis-tools
redis-cli --version
```

#### Python Packages
```bash
pip install mysql-connector-python
pip install pymongo
pip install redis
pip install sqlalchemy
```

## Common Database Operations

### SQL Basics
```sql
-- Create
CREATE TABLE name (id INT PRIMARY KEY, value VARCHAR(100));

-- Read
SELECT * FROM name WHERE condition;

-- Update
UPDATE name SET column = value WHERE id = 1;

-- Delete
DELETE FROM name WHERE id = 1;

-- Filter
WHERE age > 18 AND city = 'NYC'

-- Sort
ORDER BY name ASC, age DESC

-- Limit
LIMIT 10 OFFSET 20

-- Group
GROUP BY category HAVING COUNT(*) > 5

-- Aggregate
COUNT(*), SUM(amount), AVG(price), MAX(value), MIN(value)
```

### MongoDB Basics
```javascript
// Create
db.collection.insertOne({key: value})
db.collection.insertMany([{}, {}])

// Read
db.collection.findOne({_id: id})
db.collection.find({key: value})

// Update
db.collection.updateOne({_id: id}, {$set: {key: newValue}})
db.collection.updateMany({key: value}, {$set: {status: 'updated'}})

// Delete
db.collection.deleteOne({_id: id})
db.collection.deleteMany({key: value})

// Query operators
{$eq: value}       // Equal
{$ne: value}       // Not equal
{$gt: value}       // Greater than
{$gte: value}      // Greater than or equal
{$lt: value}       // Less than
{$lte: value}      // Less than or equal
{$in: [values]}    // In array
{$nin: [values]}   // Not in array
{$exists: true}    // Field exists
{$type: "string"}  // Field type
```

### Redis Basics
```python
# String operations
r.set(key, value)
r.get(key)
r.getset(key, newvalue)
r.mset({key1: val1, key2: val2})
r.mget([key1, key2])

# List operations
r.lpush(key, value)
r.rpush(key, value)
r.lpop(key)
r.rpop(key)
r.lrange(key, 0, -1)
r.llen(key)

# Set operations
r.sadd(key, member)
r.srem(key, member)
r.smembers(key)
r.sismember(key, member)
r.scard(key)

# Hash operations
r.hset(key, field, value)
r.hget(key, field)
r.hmset(key, {field1: val1, field2: val2})
r.hgetall(key)
r.hdel(key, field)

# Expiration
r.expire(key, seconds)
r.ttl(key)
r.setex(key, seconds, value)
r.persist(key)
```

## Best Practices

1. **Database Design**
   - Use appropriate data types
   - Normalize tables (3NF)
   - Use meaningful names
   - Plan for growth

2. **Query Optimization**
   - Use indexes on frequently queried columns
   - Avoid SELECT * when possible
   - Use JOINs efficiently
   - Limit result sets

3. **Security**
   - Use parameterized queries
   - Implement user authentication
   - Encrypt sensitive data
   - Regular backups

4. **Performance**
   - Monitor slow queries
   - Use caching strategically
   - Connection pooling
   - Regular maintenance

5. **Documentation**
   - Document schema
   - Comment complex queries
   - Maintain data dictionaries
   - Track schema changes

## Troubleshooting

### MySQL Connection Issues
```bash
# Check MySQL service
sudo service mysql status
sudo service mysql start

# Check credentials
mysql -u username -p -h localhost

# Check port
netstat -an | grep 3306
```

### MongoDB Connection Issues
```bash
# Check MongoDB service
sudo service mongod status
sudo service mongod start

# Test connection
mongo --version
mongosh --version
```

### Redis Connection Issues
```bash
# Check Redis service
sudo service redis-server status
sudo service redis-server start

# Test connection
redis-cli ping
```

## Performance Optimization Tips

1. **Indexing Strategy**
   - Index columns used in WHERE, JOIN, ORDER BY
   - Composite indexes for multi-column queries
   - Avoid over-indexing

2. **Query Optimization**
   - Explain plan analysis
   - Query caching
   - Materialized views
   - Denormalization when needed

3. **Caching Strategy**
   - Cache frequently accessed data
   - Set appropriate TTL
   - Invalidate on updates
   - Monitor cache hit rate

4. **Data Management**
   - Archive old data
   - Partition large tables
   - Regular VACUUM/ANALYZE
   - Monitor disk usage

## Resources

- [MySQL Official Documentation](https://dev.mysql.com/doc/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [MongoDB Documentation](https://docs.mongodb.com/)
- [Redis Documentation](https://redis.io/documentation)
- [SQLAlchemy Documentation](https://docs.sqlalchemy.org/)
- [Database Design Principles](https://en.wikipedia.org/wiki/Database_design)
- [SQL Tutorial](https://www.w3schools.com/sql/)
- [NoSQL vs SQL](https://www.mongodb.com/nosql-explained)

## Common Use Cases

| Scenario | Database |
|----------|----------|
| User profiles | SQL/NoSQL |
| Financial transactions | SQL (ACID) |
| Session data | Redis |
| Document storage | MongoDB |
| Analytics queries | SQL with indexing |
| Real-time notifications | Redis/MongoDB |
| Search functionality | Elasticsearch/MongoDB |
| Caching | Redis/Memcached |

## Project Guidelines

1. **Setup**
   - Initialize database
   - Create required tables/collections
   - Set up users and permissions
   - Create indexes

2. **Development**
   - Write migrations for schema changes
   - Use connection pooling
   - Implement error handling
   - Test queries thoroughly

3. **Deployment**
   - Backup before production
   - Test on staging environment
   - Monitor performance
   - Set up alerts

4. **Maintenance**
   - Regular backups
   - Monitor query performance
   - Update statistics
   - Archive old data

## Key Takeaways

- **SQL** is ideal for structured, relational data with ACID guarantees
- **NoSQL** provides flexibility for unstructured, document-based data
- **Redis** excels at caching and real-time data operations
- **Proper indexing** dramatically improves query performance
- **Database design** is critical for scalability and maintainability
- **Backup and recovery** are essential for data protection
- **Monitoring and optimization** ensure production stability
- **Choose the right tool** for your specific use case


## License

This project is part of the ALX Software Engineering Program.
