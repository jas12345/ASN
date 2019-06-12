//var _perfil = 0;

$(document).ready(function () {
    //$("#ViewForm").bind("click", function () {
    //    $("#window").data("kendoWindow").open();
    //    $("#ViewForm").hide();
    //});
});

function getFolio() {
    return {
        folioid: $("#folioId").val(),
    };
}

function Salvar() {
    //console.log("Salvado");
    infoEmployee();
}


function infoEmployee() {
    //$.ajax({
    //    type: "POST",
    //    url: urlSolicitudEmpleados,
    //    data: JSON.stringify({ "ccmsid": $("#CCMSIDSolicitado").val() }),
    //    contentType: 'application/json',
    //    success: function (resultData) {
    //        if (resultData.status !== "0") {
                
    //        } else {
    //            console.log("falso");
    //        }
    //    }
    //});

    //$.post(InfoCCMSID + '/?ccms=' + 844795, function (data) {
    //    var dat = data;
    //    //debugger;
    //});
}


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
    debugger;

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
        debugger;
        $.post(urlEmpleadoPuesto + "/?Ident=" + CCMSId, function (data) {
            EmpCCMSId = data[0].Ident
            EmpNombre = data[0].Nombre;
            EmpPosition_Code_Ident = data[0].Position_Code_Ident;
            EmpPosition_Code_Title = data[0].Position_Code_Title;
            EmpContract_Type_Ident = data[0].Contract_Type_Ident;
            EmpContract_Type = data[0].Contract_Type;
            EmpLocation_Ident = data[0].Location_Ident;
            EmpLocation_Name = data[0].Location_Name;
            Active = data[0].Active;

            //$("#lblPropiedades").val(" CCMSId: " + CCMSId + " Empleado: " + Nombre + ", Puesto: " + Position_Code_Title + ", Supervisor: " + Nombre_Manager);
            //$("#lblPropiedades").text(" CCMSId: " + CCMSId + " Empleado: " + Nombre + ", Puesto: " + Position_Code_Title + ", Supervisor: " + Nombre_Manager);
            debugger;
            $("#CCMSID").val(EmpCCMSId);
            $("#CCMSID").text(EmpCCMSId);
            $("#Nombre").val(EmpNombre);
            $("#Nombre").text(EmpNombre);
            $("#Puesto").val(EmpPosition_Code_Title);
            $("#Puesto").text(EmpPosition_Code_Title);
            $("#Contrato").val(EmpContract_Type);
            $("#Contrato").text(EmpContract_Type);
            $("#Site").val(EmpLocation_Name);
            $("#Site").text(EmpLocation_Name);

            //$("#lblCCMSId").show();
            //$("#Nombre").show();
            //$("#Puesto").show();
            //$("#Contrato").show();
            //$("#Site").show();

        }).fail(function (ex) {
            //debugger;
            console.log("fail" + ex);
        });

    }
    else {
        $("#CCMSID").val("");
        $("#CCMSID").text("");
        $("#Nombre").val("");
        $("#Nombre").text("");
        $("#Puesto").val("");
        $("#Puesto").text("");
        $("#Contrato").val("");
        $("#Contrato").text("");
        $("#Site").val("");
        $("#Site").text("");

        //$("#lblCCMSId").hide();
        //$("#lblNombre").hide();
        //$("#lblPuesto").hide();
        //$("#lblContrato").hide();
        //$("#lblSite").hide();

    }
}

function onChangeConceptos() {
    debugger;

    CCMSId = "";
    NombreEmpleado = "";
    PuestoEmpleado = "";
    SupervisorEmpleado = "";

    CCMSId = $("#CCMSIDSolicitado").val();
    NombreEmpleado = "";
    PuestoEmpleado = "";
    SupervisorEmpleado = "";

    if ($("#CCMSIDSolicitado").val().length > 0) {
        debugger;
        $.post(urlEmpleadoPuesto + "/?Ident=" + CCMSId, function (data) {
            EmpCCMSId = data[0].Ident
            EmpNombre = data[0].Nombre;
            EmpPosition_Code_Ident = data[0].Position_Code_Ident;
            EmpPosition_Code_Title = data[0].Position_Code_Title;
            EmpContract_Type_Ident = data[0].Contract_Type_Ident;
            EmpContract_Type = data[0].Contract_Type;
            EmpLocation_Ident = data[0].Location_Ident;
            EmpLocation_Name = data[0].Location_Name;
            Active = data[0].Active;

            debugger;
            $("#CCMSID").val(EmpCCMSId);
            $("#CCMSID").text(EmpCCMSId);
            $("#Nombre").val(EmpNombre);
            $("#Nombre").text(EmpNombre);
            $("#Puesto").val(EmpPosition_Code_Title);
            $("#Puesto").text(EmpPosition_Code_Title);
            $("#Contrato").val(EmpContract_Type);
            $("#Contrato").text(EmpContract_Type);
            $("#Site").val(EmpLocation_Name);
            $("#Site").text(EmpLocation_Name);

        }).fail(function (ex) {
            //debugger;
            console.log("fail" + ex);
        });

    }
    else {
        $("#CCMSID").val("");
        $("#CCMSID").text("");
        $("#Nombre").val("");
        $("#Nombre").text("");
        $("#Puesto").val("");
        $("#Puesto").text("");
        $("#Contrato").val("");
        $("#Contrato").text("");
        $("#Site").val("");
        $("#Site").text("");

        //$("#lblCCMSId").hide();
        //$("#lblNombre").hide();
        //$("#lblPuesto").hide();
        //$("#lblContrato").hide();
        //$("#lblSite").hide();

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