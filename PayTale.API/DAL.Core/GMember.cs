//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace PayTale.API.DAL.Core
{
    using System;
    using System.Collections.Generic;
    
    public partial class GMember
    {
        public long Id { get; set; }
        public Nullable<long> GroupId { get; set; }
        public Nullable<long> MemberId { get; set; }
        public string MemberName { get; set; }
        public string GMemberType { get; set; }
        public Nullable<bool> Active { get; set; }
    }
}