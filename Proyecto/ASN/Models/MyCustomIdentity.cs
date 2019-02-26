using System.Security.Principal;

namespace ASN.Models
{
    public class MyCustomIdentity : GenericIdentity
    {
        public CatUserInfoSel_Result UserInfo { get; set; }
        public string UserNumerito { get; set; }
        public string[] UserRoles { get; set; }
        public MyCustomIdentity(string a, string b)
            : base(a, b)
        {
        }
    }
}