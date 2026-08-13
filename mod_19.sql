CREATE TABLE suppliers (
    rating INT CHECK (rating BETWEEN 0 AND 5)
);

INSERT INTO suppliers VALUES (1),(2),(3);

UPDATE suppliers 
SET rating = 2
WHERE rating = 1;

DELETE FROM suppliers 
WHERE rating < 2;

ALTER TABLE suppliers ADD email VARCHAR (100);

SELECT *
FROM suppliers;

use my_assignment;

SET SQL_SAFE_UPDATES = 0;