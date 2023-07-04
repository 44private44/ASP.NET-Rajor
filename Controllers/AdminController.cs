using Microsoft.AspNetCore.Mvc;

namespace Admin_CRUD.Controllers
{
    public class AdminController : Controller
    {
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