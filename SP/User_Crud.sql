
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
    WHERE (u.first_name LIKE '%' + @username + '%'
      OR u.last_name LIKE '%' + @username + '%'
      OR u.email LIKE '%' + @username + '%'
	  OR u.department LIKE '%' + @username + '%'
	  OR u.employee_id LIKE '%' + @username + '%')
	  AND (u.flag = 1)
    ORDER BY created_at DESC
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
	
EXEC GetUserData 'praful', 1, 15;
select * from [user]

-- insert the new use data 

ALTER PROCEDURE InsertNewUserData
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(100),
    @Password VARCHAR(50),
    @CityId BIGINT,
    @CountryId BIGINT,
	@WhyVolunteer TEXT,
	@EmpId VARCHAR(16),
	@Dept VARCHAR(16),
	@ProfileText TEXT,
	@Status INT,
	@Linkurl VARCHAR(255),
	@Manager VARCHAR(50),
	@Title VARCHAR(255)
AS
BEGIN
    BEGIN TRY
        INSERT INTO [user] (first_name, last_name, email, [password], city_id, country_id, why_i_volunteer, employee_id, department, profile_text, status, linked_in_url, manager, title,phone_number) 
        VALUES (@FirstName, @LastName, @Email, @Password, @CityId, @CountryId, @WhyVolunteer, @EmpId, @Dept, @ProfileText, @Status, @Linkurl, @Manager, @Title, '12345');
    END TRY
    BEGIN CATCH
    END CATCH;
END;

EXEC InsertNewUserData
	@FirstName = "soham",
	@LastName = "Modi",
	@Email = "sohammodi13@gmail.com",
	@Password = "Hellosoham",
	@CityId = 1,
	@CountryId = 1,
	@WhyVolunteer ="bdjhqb",
	@EmpId ="wbefjk",
	@Dept = "edjkwb",
	@ProfileText = "kdnqwe",
	@Status = 0,
	@Linkurl = "EJDBWE",
	@Manager = "WEFJWBK"
	@Title = "wekn"

SELECT * FROM [user];

delete from [user]
where user_id between 56 and 150;


-- Update the user data 

ALTER PROCEDURE UpdateUserData
    @UserId INT,
	@FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @CityId BIGINT,
    @CountryId BIGINT,
	@WhyVolunteer TEXT,
	@EmpId VARCHAR(16),
	@Dept VARCHAR(16),
	@ProfileText TEXT,
	@Status INT,
	@Linkurl VARCHAR(255),
	@Manager VARCHAR(50),
	@Title VARCHAR(255)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Update user data
        UPDATE [user]
        SET first_name = @FirstName,
            last_name = @LastName,
            city_id = @CityId,
			country_id = @CountryId,
			why_i_volunteer = @WhyVolunteer,
			employee_id = @EmpId,
			department = @Dept,
			status = @Status,
			linked_in_url = @Linkurl,
			manager = @Manager,
			title = @Title
        WHERE [user_id] = @UserId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Handle the exception
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
    END CATCH;
END;

EXEC UpdateUserData
	@UserId = 56,
    @FirstName = soham,
    @LastName = modi,
    @CityId = 3,
	@CountryId = 4,
	@WhyVolunteer = "fknwfw",
	@EmpId = "efwb",
	@Dept = "wefm,nf",
	@ProfileText = "djdbqw",
	@Status =1,
	@Linkurl ="wlfknwkle",
	@Manager ="wefbnw",
	@Title = "wefnb"

SELECT * FROM [user];