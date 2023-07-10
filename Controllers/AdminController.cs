using Dapper;
using Entities.AdminData;
using Entities.DataModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Repositories.IRepositories;
using System.Data;

namespace Admin_CRUD.Controllers
{
    public class AdminController : Controller
    {
        private CiplatformContext _context;
        private readonly IUserAdminRepository _userAdminRepository;
        private readonly IMissionAdminRepository _missionAdminRepository;
        private readonly ICMSAdminRepository _cmsAdminRepository;
        public AdminController(CiplatformContext context, IUserAdminRepository userAdminRepository, IMissionAdminRepository missionAdminRepository, ICMSAdminRepository cMSAdminRepository)
        {
            _context = context;
            _userAdminRepository = userAdminRepository;
            _missionAdminRepository = missionAdminRepository;   
            _cmsAdminRepository = cMSAdminRepository;   
        }

        public IActionResult Index()
        {
            return View();
        }

        //Admin Page

        public IActionResult Admin_Page()
        {
            return View();
        }

        // User Admin Page
        public IActionResult UserAdmin()
        {
            return PartialView("_UserAdmin");
        }

        // User Table Data

        public IActionResult UserAdminTableData(string searchText, int pageNo, int pSize)
        {
            try
            {
                if (searchText == null)
                {
                    searchText = "";
                }
                var results = _userAdminRepository.GetAllUserData(searchText, pageNo, pSize);
                return PartialView("_UserAdminTableData", results);
            }
            catch (Exception ex)
            {
                // Return an error view or message
                Console.WriteLine(ex.Message);
                return View("Error");
            }
        }

        // New User Add Data 

        [HttpGet]
        public IActionResult UserAddData()
        {
            var model = new UserAdminViewModel();
            model.Countries = _context.Countries.ToList();
            return PartialView("_UserAddData", model);

        }

        // Submit method
        [HttpPost]
        public JsonResult UserFormDataSubmitMethod(UserAdminViewModel data)
        {
            if (data.created_at == null)
            {
                data.created_at = DateTime.Now; // Set CreatedAt to the current date and time
            }

            var result = _userAdminRepository.addnewuserdatatodb(data);
            if (result == 1)
            {
                return Json(new { success = true });

            }
            else
            {
                return Json(new { success = true });

            }
        }
        // get cities by country

        public JsonResult GetCitiesByCountry(int countryId)
        {
            var cities = _context.Cities.Where(c => c.CountryId == countryId)
                                         .Select(c => new { cityId = c.CityId, cityName = c.Name })
                                         .ToList();
            return Json(cities);
        }

        // Edit User

        [HttpGet]
        public IActionResult UserEditData(long userId)
        {
            var user = _context.Users.FirstOrDefault(u => u.UserId == userId);
            if (user == null)
            {
                // Handle the case when the user is not found
                return NotFound();
            }

            var model = new UserAdminViewModel
            {
                // Populate the properties of the view model with the retrieved user data
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                password = user.Password,
                EmpID = user.EmployeeId,
                Manager = user.Manager,
                Title = user.Title,
                Dept = user.Department,
                ProfileText = user.ProfileText,
                WhyIVolunteer = user.WhyIVolunteer,
                CityId = user.CityId,
                CountryId = user.CountryId,
                Status = user.Status ?? 0,
                LinkedInUrl = user.LinkedInUrl,
                Cities = _context.Cities.Where(city => city.CountryId == user.CountryId).ToList(),
                Countries = _context.Countries.ToList()
            };

            return PartialView("_UserEditData", model);
        }

        // Edit Form Submit 
        public JsonResult UserFormEditData(UserAdminViewModel data)
        {
            if (data.UserID == 0)
            {
                return Json(new { error = true });
            }

            var result = _userAdminRepository.addedituserdatatodb(data);
            if (result == 1)
            {
                return Json(new { success = true });
            }
            else
            {
                return Json(new { error = true });
            }
        }

        // User delete 

        public IActionResult UserDeleteData()
        {
            return PartialView("_UserDeleteData");
        }

        // Confirm user delete

        public JsonResult UserDeleteConfirmData(long userId)
        {
            var deletedata = _userAdminRepository.DeleteUserRecords(userId);

            if (deletedata == true)
            {
                return Json(new { success = true });
            }
            else
            {
                return Json(new { error = true });
            }

        }


        // Cms Admin Page

        public IActionResult CMSAdmin()
        {
            return PartialView("_CMSAdmin");
        }

        // CMS Table Data

        public IActionResult CMSAdminTableData(string searchText, int pageNo, int pSize)
        {
            try
            {
                if (searchText == null)
                {
                    searchText = "";
                }
                var results = _cmsAdminRepository.GetAllCMSData(searchText, pageNo, pSize);
                return PartialView("_CMSAdminTableData", results);
            }
            catch (Exception ex)
            {
                // Return an error view or message
                Console.WriteLine(ex.Message);
                return View("Error");
            }

        }

        // New CMS Add Data 

        [HttpGet]
        public IActionResult CMSAddData()
        {
            return PartialView("_CMSAddData");
        }

        // Submit method CMS
        [HttpPost]
        public JsonResult CMSFormDataSubmitMethod(CMSAdminViewModel data)
        {
            var result = _cmsAdminRepository.addnewcmsdatatodb(data);
            if (result == 1)
            {
                return Json(new { success = true });

            }
            else
            {
                return Json(new { success = true });

            }
        }
        // Edit CMS

        [HttpGet]
        public IActionResult CMSEditDate(long cmsId)
        {
            var cms = _context.CmsPages.FirstOrDefault(u => u.CmsPageId == cmsId);
            if (cms == null)
            {
                // Handle the case when the user is not found
                return NotFound();
            }

            var model = new CMSAdminViewModel
            {
                Title = cms.Title,
                Slug = cms.Slug,  
                Status = cms.Status,
            };

            return PartialView("_CMSEditDate", model);
        }

        // CMS Edit Form Submit 
        public JsonResult CMSFormUpdateData(CMSAdminViewModel data)
        {
            if (data.CMSID == 0)
            {
                return Json(new { error = true });
            }

            var result = _cmsAdminRepository.EditCMSDataUpdate(data);
            if (result == 1)
            {
                return Json(new { success = true });
            }
            else
            {
                return Json(new { error = true });
            }
        }


        // CMS delete 

        public IActionResult CMSDeleteData()
        {
            return PartialView("_CMSDeleteData");
        }

        // Confirm CMS delete

        public JsonResult CmsDeleteConfirmData(long cmsId)
        {
            var deletedata = _cmsAdminRepository.DeleteCMSRecords(cmsId);

            if (deletedata == true)
            {
                return Json(new { success = true });
            }
            else
            {
                return Json(new { error = true });
            }

        }


        // Mission Admin Page

        public IActionResult MissionAdmin()
        {
            return PartialView("_MissionAdmin");
        }

        // Mission Table Data

        public IActionResult MissionAdminTableData(string searchText, int pageNo, int pSize)
        {
            try
            {
                if (searchText == null)
                {
                    searchText = "";
                }
                var results = _missionAdminRepository.GetAllMissionData(searchText, pageNo, pSize);
                return PartialView("_MissionAdminTableData", results);
            }
            catch (Exception ex)
            {
                // Return an error view or message
                Console.WriteLine(ex.Message);
                return View("Error");
            }

        }


        // New mission Add Data 

        [HttpGet]
        public IActionResult MissionAddData()
        {
            var model = new MissionAdminViewModel();
            model.Countries = _context.Countries.ToList();
            return PartialView("_MissionAddData", model);

        }

        // MissionTheme Admin Page

        public IActionResult MissionThemeAdmin()
        {
            return PartialView("_MissionThemeAdmin");
        }

        // Mission Skill Admin Page
        public IActionResult MissionSkillAdmin()
        {
            return PartialView("_MissionSkillAdmin");
        }

        // Mission Application Admin Page

        public IActionResult MissionAppAdmin()
        {
            return PartialView("_MissionAppAdmin");
        }

        // Story Admin Page

        public IActionResult StoryAdmin()
        {
            return PartialView("_StoryAdmin");
        }

        // Banner Admin Page

        public IActionResult BannerAdmin()
        {
            return PartialView("_BannerAdmin");
        }
    }
}

/////////////////////////////////////////////