﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Mvc;

namespace PayTale.API.Controllers
{
    public class AuthController : Controller
    {
        public ActionResult SignInGoogle()
        {
            return View();
        }
    }
}
