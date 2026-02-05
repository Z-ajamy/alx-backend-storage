# 0x00 MySQL Advanced

## Overview

This project covers advanced MySQL topics including views, stored procedures, triggers, indexes, and complex query optimization. You will learn how to create efficient database structures, optimize performance, implement business logic at the database level, and maintain data integrity through advanced SQL techniques. These skills are essential for building robust, scalable database systems.

## Learning Objectives

By the end of this project, you should be able to:

- Create and manage database views
- Write and execute stored procedures
- Implement triggers for automatic actions
- Design and use indexes for query optimization
- Create and use transactions
- Implement user-defined functions
- Optimize complex queries
- Use aggregate functions efficiently
- Handle errors in stored procedures
- Manage database security and permissions
- Understand execution plans
- Implement data validation through constraints

## Requirements

### General Requirements

- Allowed editors: `vi`, `vim`, `emacs`
- All files will be executed on Ubuntu 18.04 LTS using MySQL 5.7.x or higher
- All files should end with a comment describing what the script does
- All SQL keywords should be uppercase
- Database name, table names, and field names are in lowercase
- A `README.md` file at the root is mandatory
- Code should be well-commented and documented

### MySQL Installation

```bash
# Install MySQL
sudo apt-get install -y mysql-server mysql-client

# Verify installation
mysql --version

# Start MySQL service
sudo service mysql start

# Access MySQL
mysql -u root -p
```

## Project Structure

A typical 0x00-MySQL_Advanced project includes:

```
0x00-MySQL_Advanced/
├── 0-uniq_users.sql
├── 1-countries.sql
├── 2-fans.sql
├── 3-glam_rock.sql
├── 4-store.sql
├── 5-valid_email.sql
├── 6-bonus.sql
├── 7-average_weighted_score.sql
├── 8-index_my_names.sql
├── 9-index_name_first.sql
├── 10-div.sql
├── 11-need_meeting.sql
├── 12-no_tablename.sql
├── 13-count_all_by_user_id.sql
├── 14-average_weighted_score_for_user.sql
└── README.md
```

## Core Concepts

### 1. Views

A view is a virtual table created from a query. It simplifies complex queries and provides a level of abstraction.

```sql
-- Create a simple view
CREATE VIEW user_posts AS
SELECT u.id, u.name, COUNT(p.id) as post_count
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id;

-- Query the view
SELECT * FROM user_posts;

-- Create a view with specific columns
CREATE VIEW active_users AS
SELECT id, name, email FROM users WHERE is_active = 1;

-- Drop a view
DROP VIEW IF EXISTS user_posts;

-- Modify a view
ALTER VIEW user_posts AS
SELECT u.id, u.name, COUNT(p.id) as post_count, MAX(p.created_at) as last_post
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id;
```

### 2. Stored Procedures

Functions stored in the database that execute a series of SQL statements.

```sql
-- Basic stored procedure
DELIMITER $$
CREATE PROCEDURE get_user_by_id(IN user_id INT)
BEGIN
    SELECT * FROM users WHERE id = user_id;
END $$
DELIMITER ;

-- Procedure with multiple parameters
DELIMITER $$
CREATE PROCEDURE insert_user(
    IN p_name VARCHAR(100),
    IN p_email VARCHAR(100),
    OUT p_id INT
)
BEGIN
    INSERT INTO users (name, email) VALUES (p_name, p_email);
    SET p_id = LAST_INSERT_ID();
END $$
DELIMITER ;

-- Procedure with IF statement
DELIMITER $$
CREATE PROCEDURE update_user_status(IN user_id INT, IN status VARCHAR(20))
BEGIN
    IF status IN ('active', 'inactive', 'pending') THEN
        UPDATE users SET is_active = (status = 'active') WHERE id = user_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid status';
    END IF;
END $$
DELIMITER ;

-- Call procedure
CALL get_user_by_id(1);
CALL insert_user('John', 'john@example.com', @new_id);
SELECT @new_id;
```

### 3. Triggers

Automatic actions that execute when specific database events occur.

```sql
-- Create a trigger for INSERT
DELIMITER $$
CREATE TRIGGER update_timestamp_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    SET NEW.created_at = NOW();
    SET NEW.updated_at = NOW();
END $$
DELIMITER ;

-- Create a trigger for UPDATE
DELIMITER $$
CREATE TRIGGER update_timestamp_update
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
    IF NEW.email != OLD.email THEN
        SET NEW.email_verified = FALSE;
    END IF;
END $$
DELIMITER ;

-- Create a trigger for DELETE (with logging)
DELIMITER $$
CREATE TRIGGER log_user_deletion
BEFORE DELETE ON users
FOR EACH ROW
BEGIN
    INSERT INTO user_logs (user_id, action, timestamp)
    VALUES (OLD.id, 'deleted', NOW());
END $$
DELIMITER ;

-- List triggers
SHOW TRIGGERS;

-- Drop trigger
DROP TRIGGER IF EXISTS update_timestamp_insert;
```

### 4. Indexes

Structures that speed up data retrieval by creating a sorted reference to table data.

```sql
-- Create single column index
CREATE INDEX idx_email ON users(email);

-- Create composite index
CREATE INDEX idx_name_email ON users(last_name, first_name);

-- Create unique index
CREATE UNIQUE INDEX idx_username ON users(username);

-- Create full-text index
CREATE FULLTEXT INDEX idx_description ON posts(description);

-- Drop index
DROP INDEX idx_email ON users;

-- Show indexes
SHOW INDEXES FROM users;

-- Analyze query execution plan
EXPLAIN SELECT * FROM users WHERE email = 'john@example.com';
EXPLAIN SELECT * FROM users WHERE last_name = 'Doe' AND first_name = 'John';
```

### 5. Transactions

Groups of SQL statements that execute as a single unit.

```sql
-- Start transaction
START TRANSACTION;

-- OR
BEGIN;

-- Execute statements
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

-- Commit changes
COMMIT;

-- Or rollback on error
ROLLBACK;

-- Transaction with error handling
DELIMITER $$
CREATE PROCEDURE transfer_funds(
    IN from_account INT,
    IN to_account INT,
    IN amount DECIMAL(10,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transfer failed';
    END;
    
    START TRANSACTION;
    
    UPDATE accounts SET balance = balance - amount WHERE id = from_account;
    UPDATE accounts SET balance = balance + amount WHERE id = to_account;
    
    COMMIT;
END $$
DELIMITER ;
```

### 6. User-Defined Functions

Custom functions that return a single value.

```sql
-- Function that returns a scalar value
DELIMITER $$
CREATE FUNCTION get_user_age(user_id INT) RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE age INT;
    SELECT YEAR(CURDATE()) - YEAR(birth_date) INTO age
    FROM users WHERE id = user_id;
    RETURN age;
END $$
DELIMITER ;

-- Use the function
SELECT id, name, get_user_age(id) as age FROM users;

-- Function with logic
DELIMITER $$
CREATE FUNCTION calculate_discount(price DECIMAL(10,2), customer_type VARCHAR(20))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE discount DECIMAL(10,2);
    
    IF customer_type = 'premium' THEN
        SET discount = price * 0.20;
    ELSEIF customer_type = 'gold' THEN
        SET discount = price * 0.15;
    ELSE
        SET discount = price * 0.05;
    END IF;
    
    RETURN discount;
END $$
DELIMITER ;

-- Drop function
DROP FUNCTION IF EXISTS get_user_age;
```

## Detailed Task Examples

### Task 0: Unique Users (0-uniq_users.sql)
Create a view for users and their unique emails.

**Concepts:** Views, DISTINCT, GROUP BY

```sql
-- Create view of unique users
CREATE VIEW uniq_users AS
SELECT DISTINCT user_id, email
FROM users
GROUP BY user_id
ORDER BY user_id;

-- Query the view
SELECT * FROM uniq_users;
```

### Task 1: Countries (1-countries.sql)
Query countries based on ID.

**Concepts:** Filtering, string matching

```sql
-- Get countries with specific IDs
SELECT id, name FROM countries WHERE id IN (1, 2, 3);

-- OR create indexed view
CREATE VIEW country_list AS
SELECT id, name FROM countries ORDER BY id;
```

### Task 2: Fans (2-fans.sql)
Find top fans by number of records.

**Concepts:** Aggregation, GROUP BY, ORDER BY

```sql
-- Get top fans
SELECT user_id, COUNT(*) as fan_count
FROM user_fans
GROUP BY user_id
ORDER BY fan_count DESC
LIMIT 10;

-- Create view for top fans
CREATE VIEW top_fans AS
SELECT user_id, COUNT(*) as fan_count
FROM user_fans
GROUP BY user_id
ORDER BY fan_count DESC;
```

### Task 3: Glam Rock (3-glam_rock.sql)
Complex query joining multiple tables.

**Concepts:** JOINs, GROUP BY, aggregation

```sql
-- Find bands formed between 1977 and 1985
SELECT b.id, b.name, SUM(ba.lifespan) as years_active
FROM bands b
JOIN band_albums ba ON b.id = ba.band_id
WHERE b.formed_year BETWEEN 1977 AND 1985
GROUP BY b.id
ORDER BY years_active DESC;
```

### Task 4: Store (4-store.sql)
Create trigger for sales records.

**Concepts:** Triggers, INSERT, UPDATE

```sql
-- Create store table
CREATE TABLE store (
    id INT PRIMARY KEY AUTO_INCREMENT,
    store_name VARCHAR(100),
    manager_id INT,
    total_sales DECIMAL(10,2),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create trigger to update last_updated
DELIMITER $$
CREATE TRIGGER update_store_timestamp
BEFORE UPDATE ON store
FOR EACH ROW
BEGIN
    SET NEW.last_updated = NOW();
END $$
DELIMITER ;
```

### Task 5: Valid Email (5-valid_email.sql)
Validate email format using trigger.

**Concepts:** Triggers, validation, regular expressions

```sql
-- Create trigger to validate email format
DELIMITER $$
CREATE TRIGGER validate_email_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF NEW.email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid email format';
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER validate_email_update
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    IF NEW.email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid email format';
    END IF;
END $$
DELIMITER ;
```

### Task 6: Bonus (6-bonus.sql)
Add bonus scores to users.

**Concepts:** Stored procedures, INSERT, UPDATE

```sql
-- Create stored procedure for bonus calculation
DELIMITER $$
CREATE PROCEDURE add_bonus(
    IN user_id INT,
    IN bonus_points INT
)
BEGIN
    DECLARE current_score INT;
    
    SELECT score INTO current_score FROM user_scores WHERE id = user_id;
    
    IF current_score IS NOT NULL THEN
        UPDATE user_scores SET score = score + bonus_points WHERE id = user_id;
    ELSE
        INSERT INTO user_scores (user_id, score) VALUES (user_id, bonus_points);
    END IF;
END $$
DELIMITER ;

-- Call procedure
CALL add_bonus(1, 50);
```

### Task 7: Average Weighted Score (7-average_weighted_score.sql)
Calculate average weighted score using views.

**Concepts:** Complex aggregation, weighted calculations

```sql
-- Create view for average weighted score
CREATE VIEW average_weighted_scores AS
SELECT 
    u.id,
    u.name,
    SUM(s.score * s.weight) / SUM(s.weight) as weighted_average
FROM users u
JOIN scores s ON u.id = s.user_id
GROUP BY u.id, u.name
ORDER BY weighted_average DESC;

-- Query the view
SELECT * FROM average_weighted_scores;
```

### Task 8: Index My Names (8-index_my_names.sql)
Create indexes on name columns.

**Concepts:** Indexing, performance optimization

```sql
-- Create index on last name
CREATE INDEX idx_last_name ON users(last_name);

-- Create composite index on first and last name
CREATE INDEX idx_name ON users(first_name, last_name);

-- Show created indexes
SHOW INDEXES FROM users;

-- Verify index usage
EXPLAIN SELECT * FROM users WHERE last_name = 'Doe';
```

### Task 9: Index Name First (9-index_name_first.sql)
Create optimized indexes for name queries.

**Concepts:** Composite indexes, query optimization

```sql
-- Create composite index (first_name first for optimization)
CREATE INDEX idx_fn_ln ON users(first_name, last_name);

-- This query will use the index efficiently
EXPLAIN SELECT * FROM users WHERE first_name = 'John' AND last_name = 'Doe';

-- Even this will use partial index
EXPLAIN SELECT * FROM users WHERE first_name = 'John';
```

### Task 10: Division (10-div.sql)
Create function for safe division.

**Concepts:** User-defined functions, error handling

```sql
-- Create function for safe division
DELIMITER $$
CREATE FUNCTION safe_divide(numerator INT, denominator INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    IF denominator = 0 THEN
        RETURN 0;
    END IF;
    RETURN numerator / denominator;
END $$
DELIMITER ;

-- Use the function
SELECT id, name, safe_divide(total_sales, num_transactions) as avg_transaction
FROM sales
ORDER BY id;
```

### Task 11: Need Meeting (11-need_meeting.sql)
Find users who need meetings based on criteria.

**Concepts:** Complex WHERE clauses, date functions

```sql
-- Find users needing meetings
CREATE VIEW need_meeting AS
SELECT u.id, u.name
FROM users u
WHERE (u.last_meeting IS NULL 
   OR u.last_meeting < DATE_SUB(NOW(), INTERVAL 1 MONTH))
AND u.score < 80
ORDER BY u.id;

-- Query the view
SELECT * FROM need_meeting;
```

### Task 12: No Table Name (12-no_tablename.sql)
Create view without using explicit table name in query.

**Concepts:** Information schema, dynamic queries

```sql
-- Create view using INFORMATION_SCHEMA
CREATE VIEW column_names AS
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'your_database'
AND TABLE_NAME = 'your_table'
ORDER BY ORDINAL_POSITION;
```

### Task 13: Count All By User ID (13-count_all_by_user_id.sql)
Aggregate counts by user ID.

**Concepts:** GROUP BY, COUNT, aggregation

```sql
-- Count records by user ID
CREATE VIEW user_activity_count AS
SELECT 
    user_id,
    COUNT(*) as activity_count,
    MAX(created_at) as last_activity
FROM user_activities
GROUP BY user_id
ORDER BY activity_count DESC;

-- Query the view
SELECT * FROM user_activity_count;
```

### Task 14: Average Weighted Score For User (14-average_weighted_score_for_user.sql)
Calculate weighted scores for specific user.

**Concepts:** Window functions, stored procedures

```sql
-- Create stored procedure for user's average weighted score
DELIMITER $$
CREATE PROCEDURE get_user_weighted_average(IN user_id INT)
BEGIN
    SELECT 
        user_id,
        SUM(score * weight) / SUM(weight) as weighted_average
    FROM user_scores
    WHERE user_id = user_id
    GROUP BY user_id;
END $$
DELIMITER ;

-- Call procedure
CALL get_user_weighted_average(1);
```

## Best Practices

### 1. Naming Conventions
```sql
-- Use descriptive names
CREATE TABLE user_accounts (  -- Not just 'users'
    user_id INT,              -- Not just 'id'
    account_number VARCHAR(20),
    created_at TIMESTAMP
);

-- Use prefixes for clarity
CREATE INDEX idx_email ON users(email);
CREATE INDEX idx_user_id_status ON orders(user_id, status);
```

### 2. Documentation
```sql
-- Always comment your code
-- This view shows active users with their post counts
-- Updated: 2024-01-15
CREATE VIEW active_user_posts AS
SELECT u.id, u.name, COUNT(p.id) as post_count
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
WHERE u.is_active = 1
GROUP BY u.id;
```

### 3. Error Handling
```sql
-- Use proper error handling in stored procedures
DELIMITER $$
CREATE PROCEDURE delete_user(IN user_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error occurred during deletion' as error_message;
    END;
    
    START TRANSACTION;
    DELETE FROM user_posts WHERE user_id = user_id;
    DELETE FROM users WHERE id = user_id;
    COMMIT;
END $$
DELIMITER ;
```

### 4. Optimization
```sql
-- Use EXPLAIN to understand query execution
EXPLAIN SELECT u.id, u.name, COUNT(p.id) as post_count
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id;

-- Add indexes for frequently queried columns
CREATE INDEX idx_user_id ON posts(user_id);

-- Verify index usage with EXPLAIN
EXPLAIN SELECT * FROM posts WHERE user_id = 1;
```

### 5. Security
```sql
-- Use parameterized queries in application code
-- Never use string concatenation for queries

-- Create users with minimal required privileges
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT, INSERT, UPDATE ON database.* TO 'app_user'@'localhost';

-- Use views to restrict data access
CREATE VIEW user_public_profile AS
SELECT id, name, email FROM users WHERE is_public = 1;
```

## Common Patterns

### Pattern 1: Audit Trail
```sql
-- Create audit table
CREATE TABLE audit_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(50),
    operation VARCHAR(10),
    user_id INT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create trigger for auditing
DELIMITER $$
CREATE TRIGGER audit_user_update
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, operation, user_id)
    VALUES ('users', 'UPDATE', NEW.id);
END $$
DELIMITER ;
```

### Pattern 2: Soft Delete
```sql
-- Add deleted_at column
ALTER TABLE users ADD COLUMN deleted_at TIMESTAMP NULL;

-- Create view for active records only
CREATE VIEW active_users AS
SELECT * FROM users WHERE deleted_at IS NULL;

-- Create procedure for soft delete
DELIMITER $$
CREATE PROCEDURE soft_delete_user(IN user_id INT)
BEGIN
    UPDATE users SET deleted_at = NOW() WHERE id = user_id;
END $$
DELIMITER ;
```

### Pattern 3: Sequence Generation
```sql
-- Create function for generating sequences
DELIMITER $$
CREATE FUNCTION next_order_number()
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE next_num INT;
    SELECT IFNULL(MAX(CAST(SUBSTRING(order_number, 4) AS INT)), 0) + 1
    INTO next_num FROM orders;
    RETURN CONCAT('ORD', LPAD(next_num, 7, '0'));
END $$
DELIMITER ;

-- Use in trigger
DELIMITER $$
CREATE TRIGGER set_order_number
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    SET NEW.order_number = next_order_number();
END $$
DELIMITER ;
```

## Performance Optimization Tips

### 1. Query Optimization
```sql
-- Use indexes on filtered columns
CREATE INDEX idx_status ON orders(status);

-- Use EXPLAIN to analyze queries
EXPLAIN SELECT * FROM orders WHERE status = 'pending' AND user_id = 1;

-- Optimize JOIN order
SELECT o.id, o.total, u.name
FROM orders o
INNER JOIN users u ON o.user_id = u.id
WHERE o.created_at > DATE_SUB(NOW(), INTERVAL 30 DAY);
```

### 2. Index Strategy
```sql
-- Single column index for equality
CREATE INDEX idx_email ON users(email);

-- Composite index for multiple conditions
CREATE INDEX idx_user_status_date ON orders(user_id, status, created_at);

-- Covering index to avoid table lookup
CREATE INDEX idx_user_name_email ON users(user_id, name, email);
```

### 3. Materialized Views
```sql
-- Create table with precomputed results
CREATE TABLE user_stats AS
SELECT 
    user_id,
    COUNT(*) as post_count,
    MAX(created_at) as last_post
FROM posts
GROUP BY user_id;

-- Create trigger to update materialized view
DELIMITER $$
CREATE TRIGGER update_user_stats
AFTER INSERT ON posts
FOR EACH ROW
BEGIN
    UPDATE user_stats 
    SET post_count = post_count + 1,
        last_post = NOW()
    WHERE user_id = NEW.user_id;
END $$
DELIMITER ;
```

## Troubleshooting

### Issue: "Delimiter already in use"
```sql
-- Solution: Use different delimiter for nested procedures
DELIMITER $$
CREATE PROCEDURE outer_proc()
BEGIN
    -- Your code
END $$
DELIMITER ;
```

### Issue: Trigger not executing
- Check trigger syntax with SHOW TRIGGERS;
- Verify table operations match trigger timing (BEFORE/AFTER)
- Check for errors in trigger logic

```sql
-- Debug trigger
SHOW TRIGGERS FROM your_database;
```

### Issue: Index not being used
- Use EXPLAIN to verify index usage
- Check cardinality of indexed column
- Rebuild index if needed

```sql
-- Analyze index usage
EXPLAIN SELECT * FROM users WHERE email = 'john@example.com';

-- Rebuild index
REPAIR TABLE users;
ANALYZE TABLE users;
```

### Issue: Stored procedure errors
```sql
-- Check procedure definition
SHOW CREATE PROCEDURE procedure_name;

-- Drop and recreate with debugging
DROP PROCEDURE IF EXISTS my_proc;
```

## Common SQL Patterns

```sql
-- Row numbering
SELECT 
    id,
    name,
    ROW_NUMBER() OVER (ORDER BY id) as row_num
FROM users;

-- Running totals
SELECT 
    id,
    amount,
    SUM(amount) OVER (ORDER BY id) as running_total
FROM transactions;

-- Rank with ties
SELECT 
    id,
    score,
    RANK() OVER (ORDER BY score DESC) as score_rank
FROM results;

-- Partition with aggregates
SELECT 
    category,
    product,
    sales,
    SUM(sales) OVER (PARTITION BY category) as category_total
FROM sales;
```

## Resources

- [MySQL Official Documentation](https://dev.mysql.com/doc/)
- [MySQL 5.7 Reference Manual](https://dev.mysql.com/doc/refman/5.7/en/)
- [MySQL Stored Procedures](https://dev.mysql.com/doc/refman/5.7/en/stored-procedures.html)
- [MySQL Triggers](https://dev.mysql.com/doc/refman/5.7/en/triggers.html)
- [MySQL Indexes](https://dev.mysql.com/doc/refman/5.7/en/optimization-indexes.html)
- [EXPLAIN Query Plan](https://dev.mysql.com/doc/refman/5.7/en/explain.html)
- [MySQL Views](https://dev.mysql.com/doc/refman/5.7/en/views.html)

## Key Takeaways

- **Views** provide abstraction and simplify complex queries
- **Stored procedures** encapsulate business logic in the database
- **Triggers** enforce rules and maintain data consistency
- **Indexes** dramatically improve query performance
- **Transactions** ensure data integrity
- **Functions** allow reusable calculations
- **EXPLAIN** helps understand and optimize query execution
- **Proper naming** and documentation are essential
- **Error handling** prevents data corruption
- **Performance monitoring** is critical for production systems

## License

This project is part of the ALX Software Engineering Program.
