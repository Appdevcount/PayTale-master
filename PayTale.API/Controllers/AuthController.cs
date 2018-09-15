using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;

namespace PayTale.API.Controllers
{
    public class AuthController : Controller
    {
        //[System.Web.Http.Authorize]
        public ActionResult SignInGoogle()
        {
            return View();
        }

        public ActionResult GoogleLogout()
        {
            Request.GetOwinContext().Authentication.SignOut(DefaultAuthenticationTypes.ExternalCookie);
            return View();
        }
    }
}
