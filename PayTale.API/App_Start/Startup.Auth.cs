using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin;
using Microsoft.Owin.Security.Cookies;
using Microsoft.Owin.Security.Google;
using Microsoft.Owin.Security.OAuth;
using Owin;
using PayTale.API.Providers;
using PayTale.API.Models;
using System.Threading.Tasks;
using System.Security.Claims;

namespace PayTale.API
{
    public partial class Startup
    {
        public static OAuthAuthorizationServerOptions OAuthOptions { get; private set; }

        public static string PublicClientId { get; private set; }

        // For more information on configuring authentication, please visit https://go.microsoft.com/fwlink/?LinkId=301864
        public void ConfigureAuth(IAppBuilder app)
        {
            // Configure the db context and user manager to use a single instance per request
            app.CreatePerOwinContext(ApplicationDbContext.Create);
            app.CreatePerOwinContext<ApplicationUserManager>(ApplicationUserManager.Create);

            // Enable the application to use a cookie to store information for the signed in user
            // and to use a cookie to temporarily store information about a user logging in with a third party login provider
            app.UseCookieAuthentication(new CookieAuthenticationOptions());
            app.UseExternalSignInCookie(DefaultAuthenticationTypes.ExternalCookie);

            // Configure the application for OAuth based flow
            PublicClientId = "self";
            OAuthOptions = new OAuthAuthorizationServerOptions
            {
                TokenEndpointPath = new PathString("/Token"),
                Provider = new ApplicationOAuthProvider(PublicClientId),
                AuthorizeEndpointPath = new PathString("/api/Account/ExternalLogin"),
                //AccessTokenExpireTimeSpan = TimeSpan.FromDays(14),
                AccessTokenExpireTimeSpan = TimeSpan.FromSeconds(15),
                // In production mode set AllowInsecureHttp = false
                AllowInsecureHttp = true  
            };

            // Enable the application to use bearer tokens to authenticate users
            app.UseOAuthBearerTokens(OAuthOptions);

            // Uncomment the following lines to enable logging in with third party login providers
            //app.UseMicrosoftAccountAuthentication(
            //    clientId: "",
            //    clientSecret: "");

            //app.UseTwitterAuthentication(
            //    consumerKey: "",
            //    consumerSecret: "");

            //app.UseFacebookAuthentication(
            //    appId: "",
            //    appSecret: "");

            if (System.Configuration.ConfigurationSettings.AppSettings["ProdGoogleAuth"].ToString() == "true")
            {
                app.UseGoogleAuthentication(new GoogleOAuth2AuthenticationOptions()
                {

                    //Prod - localhost:80
                    ClientId = "797307720381-ofg1v9bhmqo2k4u7u3e2bcqca0hvh07r.apps.googleusercontent.com",
                    ClientSecret = "X7YczMPgm_VdDg0XTZFRVe7O",


                    //Added Provider to get more detaiils by me - http://codechrist.blogspot.com/2016/07/a-tutorial-on-how-to-get-profile_9.html
                    Provider = new GoogleOAuth2AuthenticationProvider()
                    {
                        OnAuthenticated = (context) =>
                        {
                            context.Identity.AddClaim(new Claim("urn:google:name", context.Identity.FindFirstValue(ClaimTypes.Name)));
                            context.Identity.AddClaim(new Claim("urn:google:email", context.Identity.FindFirstValue(ClaimTypes.Email)));
                            //This following line is need to retrieve the profile image
                            context.Identity.AddClaim(new System.Security.Claims.Claim("urn:google:accesstoken", context.AccessToken, ClaimValueTypes.String, "Google"));

                            //context.Identity.AddClaim(new System.Security.Claims.Claim("urn:google:mobilephone", context.Identity.FindFirstValue(ClaimTypes.MobilePhone)));
                            //, ClaimValueTypes.String, "Google"));

                            foreach (var claim in context.User)
                            {
                                var claimType = string.Format("urn:google:{0}", claim.Key);
                                string claimValue = claim.Value.ToString();
                                if (!context.Identity.HasClaim(claimType, claimValue))
                                    context.Identity.AddClaim(new System.Security.Claims.Claim(claimType, claimValue, "XmlSchemaString", "Google"));
                            }


                            return Task.FromResult(0);
                        }
                    }
                });
            }
            else {
                app.UseGoogleAuthentication(new GoogleOAuth2AuthenticationOptions()
                {   
                    //TEST - localhost:54628
                    ClientId = "10452304310-cjq2857ugbndp0jp08eg8m7376pmr6co.apps.googleusercontent.com",
                    ClientSecret = "s9yqUILzKdVqWfnSvE0aw5qx",


                    //Added Provider to get more detaiils by me - http://codechrist.blogspot.com/2016/07/a-tutorial-on-how-to-get-profile_9.html
                    Provider = new GoogleOAuth2AuthenticationProvider()
                    {
                        OnAuthenticated = (context) =>
                        {
                            context.Identity.AddClaim(new Claim("urn:google:name", context.Identity.FindFirstValue(ClaimTypes.Name)));
                            context.Identity.AddClaim(new Claim("urn:google:email", context.Identity.FindFirstValue(ClaimTypes.Email)));
                            //This following line is need to retrieve the profile image
                            context.Identity.AddClaim(new System.Security.Claims.Claim("urn:google:accesstoken", context.AccessToken, ClaimValueTypes.String, "Google"));

                            //context.Identity.AddClaim(new System.Security.Claims.Claim("urn:google:mobilephone", context.Identity.FindFirstValue(ClaimTypes.MobilePhone)));
                            //, ClaimValueTypes.String, "Google"));

                            foreach (var claim in context.User)
                            {
                                var claimType = string.Format("urn:google:{0}", claim.Key);
                                string claimValue = claim.Value.ToString();
                                if (!context.Identity.HasClaim(claimType, claimValue))
                                    context.Identity.AddClaim(new System.Security.Claims.Claim(claimType, claimValue, "XmlSchemaString", "Google"));
                            }


                            return Task.FromResult(0);
                        }
                    }
                });
            }


        }
    }
}
