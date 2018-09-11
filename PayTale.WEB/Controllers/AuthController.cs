using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace PayTale.WEB.Controllers
{
    public class AuthController : Controller
    {
        // GET: Auth
        public ActionResult SignInGoogle()
        {

            //ClientId=797307720381-ofg1v9bhmqo2k4u7u3e2bcqca0hvh07r.apps.googleusercontent.com
            //ClientSecret=X7YczMPgm_VdDg0XTZFRVe7O
            return View();
        }
    }
}