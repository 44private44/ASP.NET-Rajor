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
        public AdminController(CiplatformContext context, IUserAdminRepository userAdminRepository)
        {
            _context = context;
            _userAdminRepository = userAdminRepository;
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
            return Json(new { success = true});
        }
        // get cities by country

        public JsonResult GetCitiesByCountry(int countryId)
        {
            var cities = _context.Cities.Where(c => c.CountryId == countryId)
                                         .Select(c => new { cityId = c.CityId, cityName = c.Name })
                                         .ToList();
            return Json(cities);
        }

        // Cms Admin Page

        public IActionResult CMSAdmin()
        {
            return PartialView("_CMSAdmin");
        }

        // Mission Admin Page

        public IActionResult MissionAdmin()
        {
            return PartialView("_MissionAdmin");
        }

        // Mission Table Data

        public IActionResult MissionAdminTableData()
        {
            return PartialView("_MissionAdminTableData");
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