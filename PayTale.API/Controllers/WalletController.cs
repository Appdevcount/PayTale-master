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
    public class WalletController : ApiController
    {
        PayTaleEntities dbctx = new PayTaleEntities();

        public async Task<IHttpActionResult> GetWalletBalalance()
        {
            dbctx.sp_WalletBalancePlus(1);
            return Ok();
        }
        [Route("A")]
        [HttpGet]
        public async Task<IHttpActionResult> AddAmount()
        {
            Wallet w = new Wallet { AmtType = "", MemberId = 1, PayMaster = "", WalletAmount = 10, GroupId = 1, GTranCode = "" };
            dbctx.Wallets.Add(w);
            dbctx.SaveChanges();
            return Ok();
        }
        public async Task<IHttpActionResult> RemoveAmount()
        {
            Wallet w= dbctx.Wallets.Find(1);
            dbctx.Wallets.Remove(w);
            return Ok();
        }
        [Route("W")]
        [HttpGet]
        public async Task<IHttpActionResult> WalletStatement()
        {
            var ws=dbctx.Wallets.ToList();
            return Ok(ws);
        }
    }
}
