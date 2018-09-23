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
    //Group CRUD/ User CRUD / Member CRUD
    public class UserGroupController : ApiController
    {
        PayTaleEntities dbctx = new PayTaleEntities();

        #region Groups

        public async Task<IHttpActionResult> GetGroups()
        {
            var GetGroups= dbctx.PayTaleGroups.ToList();
            return Ok(GetGroups);
        }
        public async Task<IHttpActionResult> CreateGroup()
        {
            var GetGroups = dbctx.PayTaleGroups.ToList();
            return Ok(GetGroups);
        }
        public async Task<IHttpActionResult> GetGroupDetail()
        {
            var GetGroups = dbctx.PayTaleGroups.ToList();
            return Ok(GetGroups);
        }
        public async Task<IHttpActionResult> UpdateGroup()
        {
            var GetGroups = dbctx.PayTaleGroups.ToList();
            return Ok(GetGroups);
        }
        public async Task<IHttpActionResult> DeleteGroup()
        {
            var GetGroups = dbctx.PayTaleGroups.ToList();
            return Ok(GetGroups);
        }

        #endregion

        #region Members

        public async Task<IHttpActionResult> GetMembers()
        {
            var GetMembers = dbctx.PayTaleUsers.ToList();
            return Ok(GetMembers);
        }
        public async Task<IHttpActionResult> CreateMember()
        {
            var GetMembers = dbctx.PayTaleUsers.ToList();
            return Ok(GetMembers);
        }
        public async Task<IHttpActionResult> GetMemberDetail()
        {
            var GetMembers = dbctx.PayTaleUsers.ToList();
            return Ok(GetMembers);
        }
        public async Task<IHttpActionResult> UpdateMember()
        {
            var GetMembers = dbctx.PayTaleUsers.ToList();
            return Ok(GetMembers);
        }
        public async Task<IHttpActionResult> DeleteMember()
        {
            var GetMembers = dbctx.PayTaleUsers.ToList();
            return Ok(GetMembers);
        }

        #endregion


    }
}
