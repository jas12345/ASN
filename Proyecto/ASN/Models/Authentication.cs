using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;

namespace ASN.Models
{
    public class Authentication
    {
        public static UserViewModel CCMSLogin(string username, string password)
        {
            UserViewModel user = new UserViewModel();

            var httpClient = new HttpClient();
            string HTTPSecurityService = System.Configuration.ConfigurationManager.AppSettings["HTTPSecurityService"];

            httpClient.BaseAddress = new Uri(HTTPSecurityService + "values/?ccmsUsername=" + HttpUtility.UrlEncode(username) + "&ccmspassword=" + HttpUtility.UrlEncode(password) + "");
            httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/xml"));
            string json = "";

            json = httpClient.GetStringAsync(string.Empty).Result;

            List<UserViewModel> Users = JsonConvert.DeserializeObject<List<UserViewModel>>(json);

            if (Users.Count > 0)
            {
                user = Users[0];
            }

            return user;
        }
    }
}