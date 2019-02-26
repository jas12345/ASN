namespace ASN
{
    using System;
    using System.Data.Entity;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public partial class ASN : DbContext
    {
        public ASN()
            : base("name=ASN")
        {
        }

        //public virtual DbSet<CatConceptos> CatConceptos { get; set; }
        //public virtual DbSet<CatRoles> CatRoles { get; set; }
        //public virtual DbSet<RelConceptoPais> RelConceptoPais { get; set; }
        //public virtual DbSet<sysdiagrams> sysdiagrams { get; set; }

        //protected override void OnModelCreating(DbModelBuilder modelBuilder)
        //{
        //    modelBuilder.Entity<CatConceptos>()
        //        .Property(e => e.Descripcion)
        //        .IsUnicode(false);

        //    modelBuilder.Entity<CatConceptos>()
        //        .Property(e => e.LastModifiedFromPCName)
        //        .IsUnicode(false);

        //    modelBuilder.Entity<CatRoles>()
        //        .Property(e => e.LastModifiedFromPCName)
        //        .IsUnicode(false);

        //    modelBuilder.Entity<RelConceptoPais>()
        //        .Property(e => e.LastModifiedFromPCName)
        //        .IsUnicode(false);
        //}
    }
}
