DELIMITER $$

CREATE TRIGGER `element_data`.`tg1` BEFORE / AFTER INSERT / 
UPDATE 
  / 
  DELETE 
    ON `element_data`.`users` FOR EACH ROW 
    BEGIN
      SET users.`userMoney` = (
        
        (SELECT 
          elements.`elementPrice` 
        FROM
          elements,
          user_data 
        WHERE elements.`elementName` = user_data.`userElement`) * 
        (SELECT 
          user_data.`userNum` 
        FROM
          users,
          user_data 
        WHERE users.`userID` = user_data.`userID`)
      ) 
    END ;
DELIMITER ;
