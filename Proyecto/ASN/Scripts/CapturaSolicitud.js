﻿//var _perfil = 0;

$(document).ready(function () {
    //$("#Conceptos").change(function () {
    //    //debugger;

    //    if ($("#Conceptos").val().length > 0) {
    //        //$('#grid').data('kendoGrid').dataSource.data([]);

    //        ConConceptoIdent = ""
    //        ConConceptoNombre = ""
    //        ConParametroId = ""
    //        ConParametroNombre = ""

    //        ConConceptoIdent = $("#Conceptos").val();
    //        //debugger;

    //        //rellenaPerfilTipoAcceso();

    //        $.post(urlConceptoParametroConcepto + "/?conceptoIdent=" + ConConceptoIdent, function (data) {
    //            //debugger;
    //            ConConceptoId = data[0].ConceptoId;
    //            ConConceptoNombre = data[0].DescripcionConcepto;
    //            ConParametroId = data[0].TipoconceptoId
    //            ConParametroNombre = data[0].DescripcionParametroConcepto;

    //            $("#Concepto").val(ConConceptoNombre);
    //            $("#Concepto").text(ConConceptoNombre);
    //            $("#Parametro").val(ConParametroNombre);
    //            $("#Parametro").text(ConParametroNombre);

    //            //$("#FechaCierreAnio").val(data[0].Active);
    //            //debugger;


    //        }).fail(function (ex) {
    //            //debugger;
    //            console.log("fail" + ex);
    //        });

    //    }
    //    else {

    //        $("#Concepto").val("");
    //        $("#Concepto").text("");
    //        $("#Parametro").val("");
    //        $("#Parametro").text("");

    //    }
    //});

    //$("#ViewForm").bind("click", function () {
    //    $("#window").data("kendoWindow").open();
    //    $("#ViewForm").hide();
    //});
});

function getFolio() {
    //debugger;
    //return //{
    //    //folioid: FolioSolicitud,
    //    FolioSolicitud;
    ////};

      return {
          FolioSolicitud: FolioSolicitud
        };
}

function agregarSolicitud() {
    //console.log("Salvado");
    //debugger;
    //infoSolicitud();
    $.post(urlCrearSolicitud + "?FolioSolicitud=" + FolioSolicitud + "&Empleado_Ident=" + EmpCCMSId + "&ConceptoId=" + ConConceptoIdent + "&ParametroConceptoMonto=" + ConParametroConceptoMonto + "&MotivosSolicitudId=" + ConMotivoIdent + "&conceptoMotivoId=" + conceptoMotivoId + "&responsableId=" + responsableId + "&periododOriginalId=" + periododOriginalId, function (data) {
        //"&ConceptoId=" + ConceptoId + "@ParametroConceptoMonto=" + ParametroConceptoMonto                                      , int conceptoMotivoId, int responsableId, int periododOriginalId

        FolioSolicitud = data.FolioSolicitud;

        if (data.res == -2) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Ya existe un registro con este Empleado y Concepto", "error");
        }

        actualizaGrid();
        //debugger;
    });
}

function actualizaGrid() {
    $("#gridSolicitud").data("kendoGrid").dataSource.read();
    $("#gridSolicitud").data("kendoGrid").refresh();
}

//function infoSolicitud() {
//    $.post(urlCrearSolicitud + "?FolioSolicitud=" + FolioSolicitud, function (data) {

//        //FolioSolicitud
//        //Fecha_Solicitud
//        //Solictante_Ident
//        //debugger;


//    });
//    //$.ajax({
//    //    type: "POST",
//    //    url: urlSolicitudEmpleados,
//    //    data: JSON.stringify({ "ccmsid": $("#CCMSIDSolicitado").val() }),
//    //    contentType: 'application/json',
//    //    success: function (resultData) {
//    //        if (resultData.status !== "0") {
                
//    //        } else {
//    //            console.log("falso");
//    //        }
//    //    }
//    //});

//    //$.post(urlCrearEmpleadoSolicitud + "?FolioSolicitud=" + FolioSolicitud + "&Empleado_Ident" + EmpCCMSId, function (data) {
//    //    var dat = data;
//    //    //debugger;
//    //});
//}


//function GuardaEmpleadosSolicitud() {//GuardarBorrador
//    var valoresGrid = $("#grid").data("kendoGrid");
//    var listado = valoresGrid.selectedKeyNames().join(", ")
//    var solicitud = $("#SolicitudId").val();

//    continuaAccion = false;
//    if (listado !== "") {
//        $.ajax({
//            type: "POST",
//            url: urlSolicitudEmpleados,
//            data: JSON.stringify({ "solicitud": solicitud, "listaEmpleados": listado }),
//            contentType: 'application/json',
//            success: function (resultData) {
//                if (resultData.status !== "0") {
//                    continuaAccion = false;
//                    var notification = $("#popupNotification").data("kendoNotification");
//                    notification.show(resultData.responseError.Errors, "error");
//                } else {
//                    continuaAccion = true
//                    SolicitudNueva = resultData.Id;

//                    var notification = $("#popupNotification").data("kendoNotification");
//                    CargaEmpleadosSolicitud();
//                    notification.show("Procesado Correctamente", "success");
//                }
//            }
//        });
//    } else {
//        var notification = $("#popupNotification").data("kendoNotification");
//        notification.show(" Seleccione al menos 1 empleado", "error");
//    }
//}


//function Perfil() {
//    return {
//        perfil: $("#Perfil_Ident").val(),
//    };
//}

function onChangeCCMSId() {
    //debugger;

    CCMSId = "";
    NombreEmpleado = "";
    PuestoEmpleado = "";
    SupervisorEmpleado = "";

    CCMSId = $("#CCMSIDSolicitado").val();
    NombreEmpleado = "";
    PuestoEmpleado = "";
    SupervisorEmpleado = "";

    //ClavePerfil = $("#PerfilUsuarioId").val();
    //debugger;
    //rellenaEmpleadoPuestoSupervisor();

    if ($("#CCMSIDSolicitado").val().length > 0) {
        //debugger;
        $.post(urlEmpleadoPuesto + "/?Ident=" + CCMSId, function (data) {
            EmpCCMSId = data[0].Ident
            EmpNombre = data[0].Nombre;
            EmpPosition_Code_Ident = data[0].Position_Code_Ident;
            EmpPosition_Code_Title = data[0].Position_Code_Title;
            EmpContract_Type_Ident = data[0].Contract_Type_Ident;
            EmpContract_Type = data[0].Contract_Type;
            EmpLocation_Ident = data[0].Location_Ident;
            EmpLocation_Name = data[0].Location_Name;
            responsableId = data[0].IdentManager;
            NombreResponsableIncidente = data[0].NombreManager;

            Active = data[0].Active;

            $("#CCMSIDX").val(EmpCCMSId);
            $("#CCMSIDX").text(EmpCCMSId);
            $("#NombreX").val(EmpNombre);
            $("#NombreX").text(EmpNombre);
            $("#PuestoX").val(EmpPosition_Code_Title);
            $("#PuestoX").text(EmpPosition_Code_Title);
            $("#ContratoX").val(EmpContract_Type);
            $("#ContratoX").text(EmpContract_Type);
            $("#SiteX").val(EmpLocation_Name);
            $("#SiteX").text(EmpLocation_Name);

            debugger;
            // Sugerencia de responsable de incidente es el Manager del empleado
            $("#ResponsableCCMSIDX").val(responsableId);
            $("#ResponsableCCMSIDX").text(responsableId);
            $("#NombreRespoX").val(NombreResponsableIncidente);
            $("#NombreRespoX").text(NombreResponsableIncidente);

            $("#CCMSIDIncidente").data("kendoNumericTextBox").value(responsableId);


        }).fail(function (ex) {
            //debugger;
            console.log("fail" + ex);
        });

    }
    else {
        $("#CCMSIDX").val("");
        $("#CCMSIDX").text("");
        $("#NombreX").val("");
        $("#NombreX").text("");
        $("#PuestoX").val("");
        $("#PuestoX").text("");
        $("#ContratoX").val("");
        $("#ContratoX").text("");
        $("#SiteX").val("");
        $("#SiteX").text("");

        $("#ResponsableCCMSIDX").val("");
        $("#ResponsableCCMSIDX").text("");
        $("#NombreRespoX").val("");
        $("#NombreRespoX").text("");
    }
}

function onChangeConceptos() {
    //debugger;

    if ($("#Conceptos").val().length > 0) {
        //$('#grid').data('kendoGrid').dataSource.data([]);

        ConConceptoIdent = ""
        ConConceptoNombre = ""
        ConParametroId = ""
        ConParametroNombre = ""

        ConConceptoIdent = $("#Conceptos").val();
        //debugger;

        //rellenaPerfilTipoAcceso();

        $.post(urlConceptoParametroConcepto + "/?conceptoIdent=" + ConConceptoIdent, function (data) {
            //debugger;
            ConConceptoIdent = data[0].ConceptoId;
            ConConceptoNombre = data[0].DescripcionConcepto;
            ConParametroId = data[0].TipoconceptoId
            ConParametroNombre = data[0].DescripcionParametroConcepto;

            $("#ConceptoX").val(ConConceptoNombre);
            $("#ConceptoX").text(ConConceptoNombre);
            $("#ParametroX").val(ConParametroNombre);
            $("#ParametroX").text(ConParametroNombre);

            //$("#FechaCierreAnio").val(data[0].Active);
            //debugger;


        }).fail(function (ex) {
            //debugger;
            console.log("fail" + ex);
        });

    }
    else {

        $("#ConceptoX").val("");
        $("#ConceptoX").text("");
        $("#ParametroX").val("");
        $("#ParametroX").text("");
    }
}

function onChangeMotivo() {
    //debugger;

    if ($("#Motivo").data('kendoDropDownList').text().length > 0) {
        ConMotivoNombre = "";
        ConMotivoIdent = "";

        //ConConceptoMotivo = $("#Motivo.value").text();
        ConMotivoNombre = $("#Motivo").data('kendoDropDownList').text();        
        ConMotivoIdent = $("#Motivo").val();
        //debugger;

        //rellenaPerfilTipoAcceso();

        $("#MotivoX").val(ConMotivoNombre);
        $("#MotivoX").text(ConMotivoNombre);
    }
    else {
        $("#MotivoX").val("");
        $("#MotivoX").text("");

    }
}

function onChangeConceptoMotivo() {
    //debugger;

    if ($("#ConceptoMotivo").data('kendoDropDownList').text().length > 0) {
        ConConceptoMotivo = ""
        conceptoMotivoId = 0

        //ConConceptoMotivo = $("#Motivo.value").text();
        ConConceptoMotivo = $("#ConceptoMotivo").data('kendoDropDownList').text();
        conceptoMotivoId = $("#ConceptoMotivo").val();
        //debugger;

        //rellenaPerfilTipoAcceso();

        $("#ConceptoMotivoX").val(ConConceptoMotivo);
        $("#ConceptoMotivoX").text(ConConceptoMotivo);
    }
    else {
        $("#ConceptoMotivoX").val("");
        $("#ConceptoMotivoX").text("");

    }
}

function onChangePeriodoIncidente() {
    //debugger;

    if ($("#PeriodoIncidente").data('kendoDropDownList').text().length > 0) {
        ConPeriodoIncidente = ""
        periododOriginalId = -1

        //ConConceptoMotivo = $("#Motivo.value").text();
        ConPeriodoIncidente = $("#PeriodoIncidente").data('kendoDropDownList').text();
        periododOriginalId = $("#PeriodoIncidente").val();
        //debugger;

        //rellenaPerfilTipoAcceso();

        $("#PeriodoOPX").val(ConPeriodoIncidente);
        $("#PeriodoOPX").text(ConPeriodoIncidente);
    }
    else {
        $("#PeriodoOPX").val("");
        $("#PeriodoOPX").text("");
    }
}

function onChangeParametro() {
    //debugger;

    if ($("#Parametro").val().length > 0) {
        //debugger;
        ConConceptoMotivo = ""
        ConParametroConceptoValor = 0
        ConParametroConceptoMonto = 0

        //ConConceptoMotivo = $("#Motivo.value").text();
        ConConceptoMotivo = $("#Parametro").val() + ' ' + ConParametroNombre;
        ConParametroConceptoMonto = $("#Parametro").val()
        //debugger;

        //rellenaPerfilTipoAcceso();

        $("#ParametroX").val(ConConceptoMotivo);
        $("#ParametroX").text(ConConceptoMotivo);
    }
    else {
        $("#ParametroX").val("");
        $("#ParametroX").text("");
    }}

function onChangeCCMSIdIncidente()
{
    //debugger;

    responsableId = "";
    NombreResponsableIncidente = "";

    responsableId = $("#CCMSIDIncidente").val();
    NombreResponsableIncidente = "";

    //ClavePerfil = $("#PerfilUsuarioId").val();
    //debugger;
    //rellenaEmpleadoPuestoSupervisor();

    if ($("#CCMSIDIncidente").val().length > 0) {
        //debugger;
        $.post(urlEmpleadoPuesto + "/?Ident=" + responsableId , function (data) {
            responsableId  = data[0].Ident
            NombreResponsableIncidente = data[0].Nombre;

            //debugger;
            $("#ResponsableCCMSIDX").val(responsableId );
            $("#ResponsableCCMSIDX").text(responsableId );
            $("#NombreRespoX").val(NombreResponsableIncidente);
            $("#NombreRespoX").text(NombreResponsableIncidente);

        }).fail(function (ex) {
            //debugger;
            console.log("fail" + ex);
        });
    }
    else {

        $("#ResponsableCCMSIDX").val("");
        $("#ResponsableCCMSIDX").text("");
        $("#NombreRespoX").val("");
        $("#NombreRespoX").text("");
    }
}

//function rellenaEmpleadoPuestoSupervisor() {
//    //debugger;

//    //@Perfil_Ident
//    //@Ident

//    if (anioId != 0) {
//        $.post(urlEmpleadoPuesto + "/?Ident=" + CCMSId, function (data) {
//            //$("#FechaInicioAnio").val(data[0].Ident);
//            Nombre = data[0].Nombre;
//            Position_Code_Ident = data[0].Position_Code_Ident;
//            Position_Code_Title = data[0].Position_Code_Title;
//            Manager_Ident = data[0].Manager_Ident;
//            Nombre_Manager = data[0].Nombre_Manager;
//            //Perfil_Ident = data[0].Perfil_Ident;
//            NombrePerfil = data[0].NombrePerfilEmpleados;
//            Active = data[0].Active;
//            TipoAccesoId = data[0].TipoAccesoId;
//            TipoAcceso = data[0].TipoAcceso;

//            AccesoSolicitante = data[0].AccesoSolicitante;
//            AccesoAutorizante = data[0].AccesoAutorizante;
//            AccesoResponsable = data[0].AccesoResponsable;
//            AccesoConsultante = data[0].AccesoConsultante;
//            AccesoOtros = data[0].AccesoOtros;

//            //$("#lblPropiedades").val(CCMSId + " Empleado: " + Nombre + ", Puesto: " + Position_Code_Title + ", Supervisor: " + Nombre_Manager);
//            //$("#lblPropiedades").text(CCMSId + " Empleado: " + Nombre + ", Puesto: " + Position_Code_Title + ", Supervisor: " + Nombre_Manager);

//        }).fail(function (ex) {
//            //debugger;
//            console.log("fail" + ex);
//        });
//    }
//}

function rellenaPerfilTipoAcceso() {
    //debugger;

    $.post(urlPerfilTipoAcceso + "/?Perfil_Ident=" + ClavePerfil, function (data) {
        //debugger;
        //ClavePerfil = data[0].Perfil_Ident;
        NombrePerfil = data[0].NombrePerfilEmpleados;
        TipoAccesoId = data[0].TipoAccesoId;
        TipoAcceso = data[0].Descripcion;
        //$("#FechaCierreAnio").val(data[0].Active);
        $("#lblPerfilNombre").val(NombrePerfil);
        $("#lblPerfilNombre").text(NombrePerfil);
        $("#lblAccesos").val(TipoAcceso);
        $("#lblAccesos").text(TipoAcceso);

        //@Html.Label("lblPerfilNombre", ",", new { id = "lblPerfilNombre", style = "font-weight:normal" })
        //@Html.Label("lblAccesosNombre", ",", new { id = "lblAccesosNombre", style = "font-weight:normal" })

    })
        .fail(function (ex) {
            console.log("fail" + ex);
        });
}