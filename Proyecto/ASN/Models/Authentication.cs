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

            //json = httpClient.GetStringAsync(string.Empty).Result;
            ///navarrogutierrez.6       666386
            json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Maydelline Elizabeth Navarro Gutierrez\",\"ident\":666386,\"manager_ident\":3345712,\"manager_first_name\":\"Jose\",\"manager_last_name\":\"Guereque Flores\",\"payroll_number\":\"599670\",\"current_status\":\"Active\",\"hire_date\":\"1996-09-02\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":317,\"location_name\":\"TPMXN Cuauhtemoc\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":49669,\"program_name\":\"TPMX CHTMC IT Development\",\"phone_ident\":\"599670\",\"account_id\":\"navarrogutierrez.6\",\"Position_Code_Title\":\"Payroll Coordinator\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Development Developer\",\"dob\":\"1971-04-23\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"28957102222\",\"sex\":\"Male\",\"email1\":\"luis.rosado@teleperformance.com\",\"civil_status\":\"Unknown\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Director of Development\",\"position_code_abbr_name\":\"Director of Development\",\"Instalacion_Id\":2,\"employee_common_name\":\"Luis Enrique Rosado Baez\",\"manager_employee_common_name\":\"Jose Guereque Flores\",\"contract_type_full_name\":\"ICISA\",\"contract_type_ident\":547,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":109}]";


            List<UserViewModel> Users = JsonConvert.DeserializeObject<List<UserViewModel>>(json);

            if (Users.Count > 0)
            {
                user = Users[0];
            }

            return user;
        }
    }
}