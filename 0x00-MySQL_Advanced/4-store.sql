-- Drop the trigger if it already exists to avoid naming conflicts
DROP TRIGGER IF EXISTS reduce_quantity;

-- Change the delimiter to allow multi-line statements within the trigger body
DELIMITER //

-- Create the trigger named 'reduce_quantity'
-- It executes AFTER a new record is inserted into the 'orders' table
CREATE TRIGGER reduce_quantity
AFTER INSERT
ON orders
FOR EACH ROW
BEGIN
    -- Update the 'items' table
    -- Subtract the ordered amount (NEW.number) from the current stock (quantity)
    -- matching the item by its name
    UPDATE items
    SET quantity = quantity - NEW.number
    WHERE item_name = NEW.item_name;
END //

-- Reset the delimiter back to the default semicolon
DELIMITER ;
