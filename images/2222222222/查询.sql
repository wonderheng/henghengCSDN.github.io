UPDATE 
  users 
SET
  users.`userMoney` = (
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
  WHERE users.`userID` = user_data.`userID`))
  WHERE	users.`userID` = user_data.`userID`;
  
  
SELECT
  users.`userMoney`=elements.`elementPrice`*user_data.`userNum` AS userMoney
FROM users,user_data,elements
WHERE elements.`elementName`=user_data.`userElement`
AND users.`userID`=user_data.`userID`
  
  
CREATE TRIGGER `element_data`.`tg1` [BEFORE|AFTER] UPDATE OF users.`userMoney`
    ON `element_data`.`users` FOR EACH ROW 
    BEGIN
      SET users.`userMoney` = (
        
        (SELECT 
          elements.`elementPrice` 
          AS 
          price
        FROM
          elements,
          user_data 
        WHERE elements.`elementName` = user_data.`userElement`) * 
        (SELECT 
          user_data.`userNum` 
          AS
          num
        FROM
          users,
          user_data 
        WHERE users.`userID` = user_data.`userID`)
      ) 
    END ;
    
    SELECT * FROM user_data WHERE userID='16407050511'