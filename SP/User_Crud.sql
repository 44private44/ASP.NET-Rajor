
-- getting the userdata of the searching and pagination

ALTER PROCEDURE GetUserData
  @username VARCHAR(255),
  @pageNumber INT,
  @pageSize INT
AS
BEGIN
  SET NOCOUNT ON;

  BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @offset INT = (@pageNumber - 1) * @pageSize;

    SELECT u.user_id AS UserID, 
		u.first_name AS FirstName,
		u.last_name AS LastName,
		u.email AS Email,
		u.employee_id AS EmpID,
		u.department AS Dept,
		u.status AS [Status]
    FROM [user] u
    WHERE u.first_name LIKE '%' + @username + '%'
      OR u.last_name LIKE '%' + @username + '%'
      OR u.email LIKE '%' + @username + '%'
	  OR u.department LIKE '%' + @username + '%'
	  OR u.employee_id LIKE '%' + @username + '%'
    ORDER BY u.user_id
    OFFSET @offset ROWS
    FETCH NEXT @pageSize ROWS ONLY;

    COMMIT;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
      ROLLBACK;
    
    THROW;
  END CATCH;
END;

EXEC GetUserData '1234', 1, 15;
select * from [user]