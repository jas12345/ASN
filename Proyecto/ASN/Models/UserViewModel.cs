using Newtonsoft.Json;
using System;

namespace ASN.Models
{
    public class UserViewModel
    {
        [JsonProperty("ident")]
        public Int32 ident { get; set; }
    }
}