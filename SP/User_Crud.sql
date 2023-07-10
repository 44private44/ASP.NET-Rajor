
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
SELECT * FROM [user]

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

DELETE FROM [user]
WHERE user_id between 56 and 150;


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


--Mision -------------------
-- Getting Mission data
ALTER PROCEDURE GetMissionAdminData
  @pageNumber INT,
  @pageSize INT,
  @searchKeyword NVARCHAR(100)
AS
BEGIN
  SET NOCOUNT ON;

  WITH MediaCTE AS (
    SELECT 
      mm.mission_id,
      mm.media_path,
      ROW_NUMBER() OVER (PARTITION BY mm.mission_id ORDER BY mm.mission_media_id) AS firstImage
    FROM mission_media AS mm
  ),
  ApproveCTE AS (
    SELECT 
      ma.mission_id,
      ma.approval_status,
      ma.mission_application_id,
      ROW_NUMBER() OVER (PARTITION BY ma.mission_id ORDER BY ma.mission_application_id) AS rowNumber
    FROM mission_application AS ma
    WHERE ma.user_id = 13
  ),
  RatingCTE AS (
    SELECT 
      mr.mission_id,
      mr.rating,
      ROW_NUMBER() OVER (PARTITION BY mr.mission_id ORDER BY mr.mission_rating_id) AS ratingno
    FROM mission_rating AS mr
  ),
  AvgratingCTE AS (
    SELECT
      mission_id,
      AVG(rating) AS average_rating
    FROM RatingCTE
    GROUP BY mission_id
  )
  SELECT 
    m.mission_id AS mission_id,
    m.theme_id AS theme_id,
    m.city_id AS city_id,
    m.country_id AS country_id,
    m.title AS title,
    m.short_description AS short_description,
    m.description AS description,
    m.start_date AS start_date,
    m.end_date AS end_date,
    m.mission_type AS mission_type,
    m.status AS status,
    m.organization_name AS org_name,
    m.organization_detail AS org_details,
    m.availability AS availability,
    m.seat_left AS seat_left,
    m.deadline AS deadline,
    ci.name AS city_name,
    country.name AS country_name,
    mt.title AS theme_name,
    MediaCTE.media_path,
    ApproveCTE.approval_status,
    ApproveCTE.mission_application_id,
    RatingCTE.rating,
    AvgratingCTE.average_rating,
    gm.goal_objective_text AS goal_text,
    gm.goal_value AS goal_value
  FROM mission AS m
  LEFT JOIN city AS ci ON m.city_id = ci.city_id
  LEFT JOIN country AS country ON m.country_id = country.country_id
  LEFT JOIN mission_theme AS mt ON m.theme_id = mt.mission_theme_id 
  LEFT JOIN MediaCTE ON m.mission_id = MediaCTE.mission_id AND MediaCTE.firstImage = 1
  LEFT JOIN goal_mission AS gm ON m.mission_id = gm.mission_id
  LEFT JOIN ApproveCTE ON m.mission_id = ApproveCTE.mission_id AND ApproveCTE.rowNumber = 1
  LEFT JOIN RatingCTE ON m.mission_id = RatingCTE.mission_id AND RatingCTE.ratingno = 1
  LEFT JOIN AvgratingCTE ON m.mission_id = AvgratingCTE.mission_id
  WHERE (@searchKeyword IS NULL OR m.title LIKE '%' + @searchKeyword + '%' OR m.mission_type LIKE '%' + @searchKeyword + '%')
  ORDER BY m.created_at DESC 

  OFFSET (@pageNumber - 1) * @pageSize ROWS
  FETCH NEXT @pageSize ROWS ONLY;
END;

EXEC GetMissionAdminData
	@pageNumber = 1,
	@pageSize = 5,
	@searchKeyword = 'Goal';

SELECT * FROM Mission

DELETE FROM Mission
WHERE mission_id BETWEEN 175 AND 250;

DELETE FROM mission_application
WHERE mission_id BETWEEN 175 AND 250;


----- GET CMS DATA

CREATE PROCEDURE GetCMSData
  @searchKeyword VARCHAR(255),
  @pageNumber INT,
  @pageSize INT
AS
BEGIN
  SET NOCOUNT ON;

  BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @offset INT = (@pageNumber - 1) * @pageSize;

    SELECT cm.cms_page_id AS CMSID, 
		cm.title AS Title,
		cm.description AS Description,
		cm.status AS Status
    FROM cms_page cm
    WHERE (cm.title LIKE '%' + @searchKeyword + '%')
	  AND (cm.flag = 1)
    ORDER BY cm.created_at DESC
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
	
EXEC GetCMSData '', 1, 5;
SELECT * FROM cms_page;

----- ADD CMS DATA

CREATE PROCEDURE InsertNewCMSData
	@Title VARCHAR(255),
	@Slug VARCHAR(255),
	@Status INT 
AS
BEGIN
    BEGIN TRY
        INSERT INTO cms_page(title,description, slug, status ) 
        VALUES (@Title,'DEfault', @Slug, @Status );
    END TRY
    BEGIN CATCH
    END CATCH;
END;

EXEC InsertNewCMSData
	@Title = 'wekn',
	@Slug = '44',
	@Status = 1

SELECT * FROM cms_page;

DELETE FROM cms_page
WHERE cms_page_id BETWEEN 16 AND 50;

-- Update CMS Data

ALTER PROCEDURE UpdateCMSData
    @CMSId BIGINT,
	@Title VARCHAR(255),
	@Slug VARCHAR(255),
	@Status INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Update user data
        UPDATE cms_page
        SET title = @Title,
			slug = @Slug,
			status = @Status
        WHERE cms_page_id = @CMSId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Handle the exception
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
    END CATCH;
END;

EXEC UpdateCMSData
	@CMSId = 15,
	@Title = 'Test44',
	@Slug = '44',
	@Status = 1;

SELECT * FROM cms_page;
