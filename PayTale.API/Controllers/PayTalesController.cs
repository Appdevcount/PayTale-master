using PayTale.API.DAL.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace PayTale.API.Controllers
{
    public class PayTalesController : ApiController
    {
        PayTaleEntities dbctx = new PayTaleEntities();

        #region TaleAccount

        public async Task<IHttpActionResult> GetTaleAccounts()
        {
            var GetTaleAccounts = dbctx.GTrans.ToList();
            return Ok(GetTaleAccounts);
        }
        public async Task<IHttpActionResult> CreateTaleAccount()
        {
            var GetTaleAccounts = dbctx.GTrans.ToList();
            return Ok(GetTaleAccounts);
        }
        public async Task<IHttpActionResult> GetTaleAccountDetail()
        {
            var GetTaleAccounts = dbctx.GTrans.ToList();
            return Ok(GetTaleAccounts);
        }
        public async Task<IHttpActionResult> UpdateTaleAccount()
        {
            var GetTaleAccounts = dbctx.GTrans.ToList();
            return Ok(GetTaleAccounts);
        }
        public async Task<IHttpActionResult> DeleteTaleAccount()
        {
            var GetTaleAccounts = dbctx.GTrans.ToList();
            return Ok(GetTaleAccounts);
        }

        #endregion

        #region Tale

        public async Task<IHttpActionResult> GetPayTales()
        {
            var GetPayTales = dbctx.PayTales.ToList();
            return Ok(GetPayTales);
        }
        public async Task<IHttpActionResult> CreatePayTale()
        {
            var GetPayTales = dbctx.PayTales.ToList();
            return Ok(GetPayTales);
        }
        public async Task<IHttpActionResult> GetPayTaleDetail()
        {
            var GetPayTales = dbctx.PayTales.ToList();
            return Ok(GetPayTales);
        }
        public async Task<IHttpActionResult> UpdatePayTale()
        {
            var GetPayTales = dbctx.PayTales.ToList();
            return Ok(GetPayTales);
        }
        public async Task<IHttpActionResult> DeletePayTale()
        {
            var GetPayTales = dbctx.PayTales.ToList();
            return Ok(GetPayTales);
        }

        #endregion
    }
}
