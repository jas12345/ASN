using System;
using System.Web;



namespace ASN.Models
{
    public class LogError
    {
        public string LogErrorMessage { get; set; }
        public string StackTrace { get; set; }
        public string IpAddress { get; set; }
        public string Browser { get; set; }
        public Nullable<int> CreatedBy { get; set; }

        protected string GetIpAddress()
        {
            string IP = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();

            if (string.IsNullOrEmpty(IP))
            {
                IP = System.Web.HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            }

            if (string.IsNullOrEmpty(IP))
            {
                IP = System.Web.HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
            }

            return IP;
        }

        public string GetIpAddressInfo()
        {
            string IP = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();

            if (string.IsNullOrEmpty(IP))
            {
                IP = System.Web.HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            }

            if (string.IsNullOrEmpty(IP))
            {
                IP = System.Web.HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
            }

            return IP;
        }

        public void RecordError(Exception ex, int EID)
        {
            try
            {
                string IP = GetIpAddress();

                HttpBrowserCapabilities bc = System.Web.HttpContext.Current.Request.Browser;

                string Browser = bc.Browser;

                string MessageInnerEx = string.Format("[ExecUser:{2}]:_:[ex.Msg: {0}]:_:[ex.Src: {1}]"
                            , ex.Message, ex.Source, System.Security.Principal.WindowsIdentity.GetCurrent().Name);
                if (ex.InnerException != null)
                {
                    MessageInnerEx += string.Format(":_:[{0}]:_:[{1}]", ex.InnerException.Message, ex.InnerException.StackTrace);
                }

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.CatLogErrorSi(MessageInnerEx, ex.StackTrace, IP, Browser, EID);
                }
            }
            catch (Exception exs)
            {

            }
        }

    }
}