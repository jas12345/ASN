//var _perfil = 0;

$(document).ready(function () {
    debugger;
    FolioSolicitud = $("#FolioSolicitud").val();
    calculaEstatusSolicitud();
    deshabilitaControlesEdicion();
    actualizaGrid();
});

function getFolio() {
    //debugger;
    return {
        //folioid: FolioSolicitud,
        FolioSolicitud: $("#FolioSolicitud").val(),
        //FolioSolicitud;
    };
}

function agregarSolicitud() {
    //console.log("Salvado");
    debugger;
    //infoSolicitud();
    $.post(urlCrearSolicitud + "?FolioSolicitud=" + FolioSolicitud + "&Empleado_Ident=" + EmpCCMSId + "&ConceptoId=" + ConConceptoIdent + "&ParametroConceptoMonto=" + ConParametroConceptoMonto + "&MotivosSolicitudId=" + ConMotivoIdent + "&conceptoMotivoId=" + conceptoMotivoId + "&responsableId=" + responsableId + "&periododOriginalId=" + periododOriginalId + "&AutorizadorNivel1=" + autorizadorNivel1 + "&AutorizadorNivel2=" + autorizadorNivel2 + "&AutorizadorNivel3=" + autorizadorNivel3 + "&AutorizadorNivel4=" + autorizadorNivel4 + "&AutorizadorNivel5=" + autorizadorNivel5 + "&AutorizadorNivel6=" + autorizadorNivel6 + "&AutorizadorNivel7=" + autorizadorNivel7 + "&AutorizadorNivel8=" + autorizadorNivel8 + "&AutorizadorNivel9=" + autorizadorNivel9 + "&Active=" + 1, function (data) {
        //"&ConceptoId=" + ConceptoId + "@ParametroConceptoMonto=" + ParametroConceptoMonto                                      , int conceptoMotivoId, int responsableId, int periododOriginalId

        FolioSolicitud = data.FolioSolicitud;

        if (data.res == -2) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Ya existe un registro con este Empleado y Concepto", "error");
        }

        $("#FolioSolicitud").data("kendoNumericTextBox").value(data.FolioSolicitud);
        actualizaGrid();
        //debugger;
    });
}

function autorizarSolicitud() {
    //console.log("Salvado");
    debugger;
    //infoSolicitud();
    $.post(urlAutorizaSolicitud + "?FolioSolicitud=" + FolioSolicitud + "&Empleado_Ident=" + EmpCCMSId + "&ConceptoId=" + ConceptoId + "&NivelAutorizacion=" + NivelAutorizacion + "&Accion=" + 2, function (data) {

        FolioSolicitud = data.FolioSolicitud;

        if (data.res == -1) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("No se pudo procesar la Autorización ", "error");
        }
        else {
            $("#AutorizarSolicitud").hide();
            $("#RechazarSolicitud").hide();
            $("#CancelarSolicitud").hide();

            calculaEstatusSolicitud();
        }

        $("#FolioSolicitud").data("kendoNumericTextBox").value(data.FolioSolicitud);
        actualizaGrid();
        //debugger;
    });
}

function rechazarSolicitud() {
    //console.log("Salvado");
    debugger;
    //infoSolicitud();
    $.post(urlAutorizaSolicitud + "?FolioSolicitud=" + FolioSolicitud + "&Empleado_Ident=" + EmpCCMSId + "&ConceptoId=" + ConceptoId + "&NivelAutorizacion=" + NivelAutorizacion + "&Accion=" + 3, function (data) {

        FolioSolicitud = data.FolioSolicitud;

        if (data.res == -1) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("No se pudo procesar la Autorización ", "error");
        }
        else {
            $("#AutorizarSolicitud").hide();
            $("#RechazarSolicitud").hide();
            $("#CancelarSolicitud").hide();

            calculaEstatusSolicitud();
        }

        $("#FolioSolicitud").data("kendoNumericTextBox").value(data.FolioSolicitud);
        actualizaGrid();
        //debugger;
    });
}

function cancelarSolicitud() {
    //console.log("Salvado");
    debugger;
    //infoSolicitud();
    $.post(urlAutorizaSolicitud + "?FolioSolicitud=" + FolioSolicitud + "&Empleado_Ident=" + EmpCCMSId + "&ConceptoId=" + ConceptoId + "&NivelAutorizacion=" + NivelAutorizacion + "&Accion=" + 4, function (data) {

        FolioSolicitud = data.FolioSolicitud;

        if (data.res == -1) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("No se pudo procesar la Autorización ", "error");
        }
        else {
            $("#AutorizarSolicitud").hide();
            $("#RechazarSolicitud").hide();
            $("#CancelarSolicitud").hide();

            calculaEstatusSolicitud();
        }

        $("#FolioSolicitud").data("kendoNumericTextBox").value(data.FolioSolicitud);
        actualizaGrid();
        //debugger;
    });
}

function enviarSolicitud() {
    //console.log("Salvado");
    debugger;
    //infoSolicitud();
    $.post(urlEnviaSolicitud + "?FolioSolicitud=" + FolioSolicitud, function (data) {
        //"&ConceptoId=" + ConceptoId + "@ParametroConceptoMonto=" + ParametroConceptoMonto                                      , int conceptoMotivoId, int responsableId, int periododOriginalId
        debugger;

        if (data.res == -1) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Error al Enviar Solicitud", "error");
        }

        //$("#FolioSolicitud").data("kendoNumericTextBox").value(data.FolioSolicitud);
        calculaEstatusSolicitud();
        deshabilitaControlesEdicion();
        actualizaGrid();
        debugger;
    });
}

function calculaEstatusSolicitud() {
    debugger;
    $.post(urlConsultarEstatusSolicitud + "?FolioSolicitud=" + FolioSolicitud, function (data) {
        //"&ConceptoId=" + ConceptoId + "@ParametroConceptoMonto=" + ParametroConceptoMonto                                      , int conceptoMotivoId, int responsableId, int periododOriginalId
        debugger;

        if (data.res == -1) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Error al Calcular Estatus", "error");
        }
        debugger;
        $("#Estatus").val(data[0].Descripcion);
        debugger;
    });
}

function habilitaControlesEdicion() {
    var autorizadores = $("div[name='nivel']");
    debugger;
    $(autorizadores).each(function (nivel) {
        //console.log(index + ": " + $(this).text());
        //console.log("ssss");
        if (this.id <= nivelAutorizador) {
            debugger;
            $(this).show();
        }
        if (this.id > nivelAutorizador) {
            debugger;
            $(this).hide();
        }
    });
}

function deshabilitaControlesEdicion() {
    debugger;

    var tempDL = $("#Conceptos").data("kendoDropDownList");
    tempDL.enable(false);

    tempDL = $("#Motivo").data("kendoDropDownList");
    tempDL.enable(false);

    tempDL = $("#ConceptoMotivo").data("kendoDropDownList");
    tempDL.enable(false);

    tempDL = $("#PeriodoIncidente").data("kendoDropDownList");
    tempDL.enable(false);

    var autorizadores = $("CCMSIDSolicitado");
    //autorizadores.Enable(true);

    //$("Conceptos").getKendoComboBox().enable(disa);

    //$("Conceptos").toggleClass('k-state-disabled', true);


    //$("Conceptos").disabled = 'true';

    debugger;
    //$(autorizadores).each(function (nivel) {
    //    //console.log(index + ": " + $(this).text());
    //    //console.log("ssss");
    //    if (this.id <= nivelAutorizador) {
    //        debugger;
    //        $(this).show();
    //    }
    //    if (this.id > nivelAutorizador) {
    //        debugger;
    //        $(this).hide();
    //    }
    //});
}

function actualizaGrid() {
    $("#gridAutorizacion").data("kendoGrid").dataSource.read();
    $("#gridAutorizacion").data("kendoGrid").refresh();
    debugger;
}

function editarEmpleadoSolicitud(e) {
    debugger;
    e.preventDefault(); // sho J
    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    CCMSIdResponsable = dataItem.ResponsableId;
    NivelAutorizacion = dataItem.NivelAutorizacion;
    ConceptoId = dataItem.ConceptoId;
    ConEmpleadoident = dataItem.Ident;
    Solicitante_Ident = dataItem.Solicitante_Ident;

    // Activar botones Autorizar, Rechazar y Cancelar Solicitud
    $("#AutorizarSolicitud").show();
    $("#RechazarSolicitud").show();
    $("#CancelarSolicitud").show();

    // Se actualiza comboBox de Conceptos
    $("#Conceptos").data("kendoDropDownList").dataSource.read(getIdent);
    $("#Conceptos").data("kendoDropDownList").refresh();

    debugger;
    $("#CCMSIDSolicitado").data('kendoNumericTextBox').value(dataItem.Ident);
    //$("#CCMSIDSolicitado").data('kendoNumericTextBox').text(dataItem.Ident);
    $('#CCMSIDSolicitado').data('kendoNumericTextBox').trigger('change');

    $("#Conceptos").data('kendoDropDownList').value(dataItem.ConceptoId);
    $('#Conceptos').data('kendoDropDownList').trigger('change');
    debugger;
    $("#Parametro").data('kendoNumericTextBox').value(dataItem.Monto);
    $('#Parametro').data('kendoNumericTextBox').trigger('change');

    $("#Motivo").data('kendoDropDownList').value(dataItem.MotivosSolicitudId);
    $('#Motivo').data('kendoDropDownList').trigger('change');

    $("#ConceptoMotivo").data('kendoDropDownList').value(dataItem.ConceptoMotivoId);
    $('#ConceptoMotivo').data('kendoDropDownList').trigger('change');

    $("#PeriodoIncidente").data('kendoDropDownList').value(dataItem.PeriodoOriginalId);
    $('#PeriodoIncidente').data('kendoDropDownList').trigger('change');

    //debugger;
    $("#CCMSIdIncidente").data('kendoNumericTextBox').value(dataItem.ResponsableId);
    $('#CCMSIdIncidente').data('kendoNumericTextBox').trigger('change');

    debugger;
    var rowIndex = $(e.currentTarget).closest("tr").index();
    var grid = $("#gridAutorizacion").data("kendoGrid");
    grid.select("tr:eq(" + rowIndex + ")");
}

function borrarEmpleadoSolicitud(e) {
    //debugger;

    if (confirm("Desea eliminar este registro?")) {

        e.preventDefault(); // sho J
        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
        debugger;
        var Solicitud_Ident = dataItem.FolioSolicitud;
        var Empleado_Ident = dataItem.Ident;
        var ConceptoId = dataItem.ConceptoId;
        //Se ejecuta Update con Active=false para eliminar el acceso respondiendo al botón Borrar
        var Active = false;

        //int Perfil_Ident, int Ident, bool Active
        $.post(urlUpdateEmpleadoSolicitud + "/?FolioSolicitud=" + Solicitud_Ident + "&Empleado_Ident=" + Empleado_Ident + "&ConceptoId=" + ConceptoId + "&Activo=" + Active, function (data) {
            //debugger;

            var grid = $("#gridAutorizacion").data("kendoGrid");
            var selectedRows = grid.select();

            actualizaGrid();

            //grid.select("tr:eq(" + selectedRows(0) + ")");

        }).fail(function (ex) {
            console.log("fail" + ex);
        });
    }
}

function onChangeFolioSolicitud() {
    debugger;

    //FolioSolicitud = data.FolioSolicitud;
    //FolioSolicitud: $("#FolioSolicitud").val();

    actualizaGrid();
}

function getIdent() {
    return {
        Ident: ConEmpleadoident,
        Ident_Solicitante: Solicitante_Ident
    }
}

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
        //debugger;

        $.post(urlEmpleadoPuesto + "/?Ident=" + CCMSId, function (data) {

            //FolioSolicitud = data.FolioSolicitud;

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

            if (EmpCCMSId > 0) {
                $("#CCMSIDX").val(EmpCCMSId);
                $("#CCMSIDX").text(EmpCCMSId);

                debugger;
                $("#Conceptos").data("kendoDropDownList").dataSource.read(EmpCCMSId);
                $("#Conceptos").data("kendoDropDownList").refresh();

            }
            else {
                $("#CCMSIDX").val(-1);
                $("#CCMSIDX").text("");
                $("#Conceptos").data("kendoDropDownList").dataSource.read(-1);
                $("#Conceptos").data("kendoDropDownList").refresh();
            }

            $("#NombreX").val(EmpNombre);
            $("#NombreX").text(EmpNombre);
            $("#PuestoX").val(EmpPosition_Code_Title);
            $("#PuestoX").text(EmpPosition_Code_Title);
            $("#ContratoX").val(EmpContract_Type);
            $("#ContratoX").text(EmpContract_Type);
            $("#SiteX").val(EmpLocation_Name);
            $("#SiteX").text(EmpLocation_Name);

            debugger;

            
            //if ($("#CCMSIDIncidente").data("kendoNumericTextBox").value() == 0) {
            if (CCMSIdResponsable == 0) {
                $("#CCMSIDIncidente").data("kendoNumericTextBox").value(CCMSIdResponsable);
                // Sugerencia de responsable de incidente es el Manager del empleado
                $("#ResponsableCCMSIDX").val("");
                $("#ResponsableCCMSIDX").text("");
                $("#NombreRespoX").val("");
                $("#NombreRespoX").text("");

            }
            else {
                $("#CCMSIDIncidente").data("kendoNumericTextBox").value(responsableId);
                 // Sugerencia de responsable de incidente es el Manager del empleado
                $("#ResponsableCCMSIDX").val(responsableId);
                $("#ResponsableCCMSIDX").text(responsableId);
                $("#NombreRespoX").val(NombreResponsableIncidente);
                $("#NombreRespoX").text(NombreResponsableIncidente);
           }

            if (EmpCCMSId == -1) {
                var notification = $("#popupNotification").data("kendoNotification");
                notification.show("No tiene permiso para crear una solicitud a este empleado.", "error");
            }

            if (EmpCCMSId == -2) {
                var notification = $("#popupNotification").data("kendoNotification");
                notification.show("Este empleado no existe o no está activo.", "error");
            }

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
    debugger;

    if ($("#Conceptos").val().length > 0) {
        //$('#grid').data('kendoGrid').dataSource.data([]);

        ConConceptoIdent = ""
        ConConceptoNombre = ""
        ConParametroId = ""
        ConParametroNombre = ""
        ConNivelesAutorizacion = ""

        ConConceptoIdent = $("#Conceptos").val();
        debugger;

        //rellenaPerfilTipoAcceso();

        $.post(urlConceptoParametroConcepto + "/?conceptoIdent=" + ConConceptoIdent, function (data) {
            debugger;
            ConConceptoIdent = data[0].ConceptoId;
            ConConceptoNombre = data[0].DescripcionConcepto;
            ConParametroId = data[0].TipoconceptoId;
            ConParametroNombre = data[0].DescripcionParametroConcepto;
            ConNivelesAutorizacion = data[0].NivelesAutorizacion;

            $("#ConceptoX").val(ConConceptoNombre);
            $("#ConceptoX").text(ConConceptoNombre);    
            $("#ParametroX").val(ConParametroNombre);
            $("#ParametroX").text(ConParametroNombre);

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

        $("#ConceptoMotivo").val(-1);
        $("#PeriodoIncidente").val(-1);

    }
    else {
        $("#MotivoX").val("");
        $("#MotivoX").text("");

    }
}

function onChangeConceptoMotivo() {
    debugger;

    if ($("#ConceptoMotivo").data('kendoDropDownList').text().length > 0) {
        ConConceptoMotivo = ""
        conceptoMotivoId = 0

        //ConConceptoMotivo = $("#Motivo.value").text();
        ConConceptoMotivo = $("#ConceptoMotivo").data('kendoDropDownList').text();
        conceptoMotivoId = $("#ConceptoMotivo").val();
        debugger;

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
    debugger;

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
    debugger;

    if ($("#Parametro").val().length > 0) {
        //debugger;
        ConConceptoMotivo = ""
        ConParametroConceptoValor = 0
        ConParametroConceptoMonto = 0

        //ConConceptoMotivo = $("#Motivo.value").text();
        ConConceptoMotivo = $("#Parametro").val() + ' ' + ConParametroNombre;
        ConParametroConceptoMonto = $("#Parametro").val()
        debugger;

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
    debugger;

    responsableId = "";
    NombreResponsableIncidente = "";

    responsableId = $("#CCMSIDIncidente").val();
    //CCMSIdResponsable = 
    NombreResponsableIncidente = "";

    //ClavePerfil = $("#PerfilUsuarioId").val();
    //debugger;
    //rellenaEmpleadoPuestoSupervisor();

    if ($("#CCMSIDIncidente").val().length > 0) {
        //debugger;
        $.post(urlEmpleadoPuesto + "/?Ident=" + responsableId , function (data) {
            responsableId  = data[0].Ident
            NombreResponsableIncidente = data[0].Nombre;

            debugger;
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

    })
        .fail(function (ex) {
            console.log("fail" + ex);
        });
}