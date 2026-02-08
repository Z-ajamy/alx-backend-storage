-- Drop the trigger if it already exists to avoid naming conflicts
DROP TRIGGER IF EXISTS reset_valid_email_on_change;

-- Change the delimiter to allow multi-line statements within the trigger body
DELIMITER $$

-- Create the trigger named 'reset_valid_email_on_change'
-- trigger that resets the attribute valid_email only when the email has been changed.

CREATE TRIGGER reset_valid_email_on_change
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    IF NEW.email != OLD.email THEN 
        SET NEW.valid_email = 0;
    END IF;
END$$

-- Reset the delimiter back to the default semicolon
DELIMITER ;
