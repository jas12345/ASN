//var _perfil = 0;

function resizeGrid() {
    var gridElement = $("#gridAutorizacion"),
        dataArea = gridElement.find(".k-grid-content"),
        gridHeight = gridElement.innerHeight(),
        otherElements = gridElement.children().not(".k-grid-content"),
        otherElementsHeight = 0;
    otherElements.each(function () {
        otherElementsHeight += $(this).outerHeight();
    });
    dataArea.height(gridHeight - otherElementsHeight);
}

function resizeWrapper() {
    $("#parent").height(document.body.offsetHeight - 400);
}

$(window).resize(function () {
    resizeWrapper();
    resizeGrid();
});

$(document).ready(function () {
    $(window).trigger("resize");
    //debugger;
    FolioSolicitud = $("#FolioSolicitud").val();
    calculaEstatusSolicitud();
    deshabilitaControlesEdicion();
    actualizaGrid();

    $("#AutorizarSolicitudALL").hide();
    $("#RechazarSolicitudALL").hide();

    //$("#AutorizarSolicitud").hide();
    //$("#RechazarSolicitud").hide();
});

function getFolio() {
    //debugger;
    return {
        //folioid: FolioSolicitud,
        FolioSolicitud: $("#FolioSolicitud").val(),
        //FolioSolicitud;
    };
}

//function agregarSolicitud() {
//    //console.log("Salvado");
//    //debugger;
//    //infoSolicitud();
//    $.post(urlCrearSolicitud + "?FolioSolicitud=" + FolioSolicitud + "&Empleado_Ident=" + EmpCCMSId + "&ConceptoId=" + ConConceptoIdent + "&ParametroConceptoMonto=" + ConParametroConceptoMonto + "&MotivosSolicitudId=" + ConMotivoIdent + "&conceptoMotivoId=" + conceptoMotivoId + "&responsableId=" + responsableId + "&periododOriginalId=" + periododOriginalId + "&AutorizadorNivel1=" + autorizadorNivel1 + "&AutorizadorNivel2=" + autorizadorNivel2 + "&AutorizadorNivel3=" + autorizadorNivel3 + "&AutorizadorNivel4=" + autorizadorNivel4 + "&AutorizadorNivel5=" + autorizadorNivel5 + "&AutorizadorNivel6=" + autorizadorNivel6 + "&AutorizadorNivel7=" + autorizadorNivel7 + "&AutorizadorNivel8=" + autorizadorNivel8 + "&AutorizadorNivel9=" + autorizadorNivel9 + "&Active=" + 1, function (data) {
//        //"&ConceptoId=" + ConceptoId + "@ParametroConceptoMonto=" + ParametroConceptoMonto                                      , int conceptoMotivoId, int responsableId, int periododOriginalId

//        FolioSolicitud = data.FolioSolicitud;

//        if (data.res == -2) {
//            var notification = $("#popupNotification").data("kendoNotification");
//            notification.show("Ya existe un registro con este Empleado y Concepto", "error");
//        }

//        $("#FolioSolicitud").data("kendoNumericTextBox").value(data.FolioSolicitud);
//        actualizaGrid();
//        //debugger;
//    });
//}

function autorizarSolicitud() {
    //console.log("Salvado");
    //debugger;
    //infoSolicitud();
    $.post(urlAutorizaSolicitud + "?FolioSolicitud=" + FolioSolicitud + "&Empleado_Ident=" + EmpCCMSId + "&ConceptoId=" + ConceptoId + "&NivelAutorizacion=" + NivelAutorizacion + "&Accion=" + 2, function (data) {

        FolioSolicitud = data.FolioSolicitud;

        if (data.res == -1) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("No se pudo procesar la Autorización ", "error");
        }
        else {
            //$("#AutorizarSolicitud").hide();
            //$("#RechazarSolicitud").hide();
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
    //debugger;
    //infoSolicitud();
    $.post(urlAutorizaSolicitud + "?FolioSolicitud=" + FolioSolicitud + "&Empleado_Ident=" + EmpCCMSId + "&ConceptoId=" + ConceptoId + "&NivelAutorizacion=" + NivelAutorizacion + "&Accion=" + 3, function (data) {

        FolioSolicitud = data.FolioSolicitud;

        if (data.res == -1) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("No se pudo procesar la Autorización ", "error");
        }
        else {
            //$("#AutorizarSolicitud").hide();
            //$("#RechazarSolicitud").hide();
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
    //debugger;
    //infoSolicitud();
    $.post(urlAutorizaSolicitud + "?FolioSolicitud=" + FolioSolicitud + "&Empleado_Ident=" + EmpCCMSId + "&ConceptoId=" + ConceptoId + "&NivelAutorizacion=" + NivelAutorizacion + "&Accion=" + 4, function (data) {

        FolioSolicitud = data.FolioSolicitud;

        if (data.res == -1) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("No se pudo procesar la Autorización ", "error");
        }
        else {
            //$("#AutorizarSolicitud").hide();
            //$("#RechazarSolicitud").hide();
            $("#CancelarSolicitud").hide();

            calculaEstatusSolicitud();
        }

        $("#FolioSolicitud").data("kendoNumericTextBox").value(data.FolioSolicitud);
        actualizaGrid();
        //debugger;
    });
}

//function enviarSolicitud() {
//    //console.log("Salvado");
//    //debugger;
//    //infoSolicitud();
//    $.post(urlEnviaSolicitud + "?FolioSolicitud=" + FolioSolicitud, function (data) {
//        //"&ConceptoId=" + ConceptoId + "@ParametroConceptoMonto=" + ParametroConceptoMonto                                      , int conceptoMotivoId, int responsableId, int periododOriginalId
//        //debugger;

//        if (data.res == -1) {
//            var notification = $("#popupNotification").data("kendoNotification");
//            notification.show("Error al Enviar Solicitud", "error");
//        }

//        //$("#FolioSolicitud").data("kendoNumericTextBox").value(data.FolioSolicitud);
//        calculaEstatusSolicitud();
//        deshabilitaControlesEdicion();
//        actualizaGrid();
//        //debugger;
//    });
//}

function calculaEstatusSolicitud() {
    //debugger;
    $.post(urlConsultarEstatusSolicitud + "?FolioSolicitud=" + FolioSolicitud, function (data) {
        //"&ConceptoId=" + ConceptoId + "@ParametroConceptoMonto=" + ParametroConceptoMonto                                      , int conceptoMotivoId, int responsableId, int periododOriginalId
        //debugger;

        if (data.res == -1) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Error al Calcular Estatus", "error");
        }
        //debugger;
        $("#Estatus").val(data[0].Descripcion);
        //debugger;
    });
}

function habilitaControlesEdicion() {
    var autorizadores = $("div[name='nivel']");
    //debugger;
    $(autorizadores).each(function (nivel) {
        //console.log(index + ": " + $(this).text());
        //console.log("ssss");
        if (this.id <= nivelAutorizador) {
            //debugger;
            $(this).show();
        }
        if (this.id > nivelAutorizador) {
            //debugger;
            $(this).hide();
        }
    });
}

function deshabilitaControlesEdicion() {
    //debugger;

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

    //debugger;
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
    //debugger;
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
    ConParametroConceptoMonto = dataItem.Monto;

    // Activar botones Autorizar, Rechazar y Cancelar Solicitud
    //if (dataItem.BtnAutorizarBorrar==1) {
    //    $("#AutorizarSolicitud").show();
    //    $("#RechazarSolicitud").show();
    //}
    //else {
    //    $("#AutorizarSolicitud").hide();
    //    $("#RechazarSolicitud").hide();
    //}
    
    //$("#CancelarSolicitud").show();

    // Se actualiza comboBox de Conceptos
    $("#Conceptos").data("kendoDropDownList").dataSource.read(getIdent);
    $("#Conceptos").data("kendoDropDownList").refresh();

    //debugger;
    $("#CCMSIDSolicitado").data('kendoNumericTextBox').value(dataItem.Ident);
    //$("#CCMSIDSolicitado").data('kendoNumericTextBox').text(dataItem.Ident);
    $('#CCMSIDSolicitado').data('kendoNumericTextBox').trigger('change');

    $("#Conceptos").data('kendoDropDownList').value(dataItem.ConceptoId);
    $('#Conceptos').data('kendoDropDownList').trigger('change');
    //debugger;
    $("#Parametro").data('kendoNumericTextBox').value(dataItem.Monto);
    $('#Parametro').data('kendoNumericTextBox').trigger('change');

    $("#Motivo").data('kendoDropDownList').value(dataItem.MotivosSolicitudId);
    $('#Motivo').data('kendoDropDownList').trigger('change');

    $("#ConceptoMotivo").data('kendoDropDownList').value(dataItem.ConceptoMotivoId);
    $('#ConceptoMotivo').data('kendoDropDownList').trigger('change');

    $("#PeriodoIncidente").data('kendoDropDownList').value(dataItem.PeriodoOriginalId);
    $('#PeriodoIncidente').data('kendoDropDownList').trigger('change');

    //debugger;
    $("#CCMSIDIncidente").data('kendoNumericTextBox').value(dataItem.ResponsableId);
    $('#CCMSIDIncidente').data('kendoNumericTextBox').trigger('change');

    ////debugger;
    //var rowIndex = $(e.currentTarget).closest("tr").index();
    //var grid = $("#gridAutorizacion").data("kendoGrid");
    //grid.select("tr:eq(" + rowIndex + ")");
}

//function borrarEmpleadoSolicitud(e) {
//    //debugger;

//    if (confirm("Desea eliminar este registro?")) {

//        e.preventDefault(); // sho J
//        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
//        //debugger;
//        var Solicitud_Ident = dataItem.FolioSolicitud;
//        var Empleado_Ident = dataItem.Ident;
//        var ConceptoId = dataItem.ConceptoId;
//        //Se ejecuta Update con Active=false para eliminar el acceso respondiendo al botón Borrar
//        var Active = false;

//        //int Perfil_Ident, int Ident, bool Active
//        $.post(urlUpdateEmpleadoSolicitud + "/?FolioSolicitud=" + Solicitud_Ident + "&Empleado_Ident=" + Empleado_Ident + "&ConceptoId=" + ConceptoId + "&Activo=" + Active, function (data) {
//            //debugger;

//            var grid = $("#gridAutorizacion").data("kendoGrid");
//            var selectedRows = grid.select();

//            actualizaGrid();

//            //grid.select("tr:eq(" + selectedRows(0) + ")");

//        }).fail(function (ex) {
//            console.log("fail" + ex);
//        });
//    }
//}

function onChangeFolioSolicitud() {
    //debugger;

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

                //debugger;
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

            //debugger;

            
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

    if ($("#Conceptos").val().length > 0 || ConceptoId.toString().length > 0) {
        //$('#grid').data('kendoGrid').dataSource.data([]);

        ConConceptoIdent = "";
        ConConceptoNombre = "";
        ConParametroId = "";
        ConParametroNombre = "";
        ConNivelesAutorizacion = "";

        ConConceptoIdent = $("#Conceptos").val().length > 0 ? $("#Conceptos").val() : ConceptoId;
        //debugger;

        //rellenaPerfilTipoAcceso();

        $.post(urlConceptoParametroConcepto + "/?conceptoIdent=" + ConConceptoIdent + "&eid=" + $("#CCMSIDSolicitado").val(), function (data) {
            //debugger;
            ConConceptoIdent = data[0].ConceptoId;
            ConConceptoNombre = data[0].DescripcionConcepto;
            ConParametroId = data[0].TipoconceptoId;
            ConParametroNombre = ConParametroConceptoMonto + " " +  data[0].DescripcionParametroConcepto;
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
    //debugger;

    if ($("#ConceptoMotivo").data('kendoDropDownList').text().length > 0) {
        ConConceptoMotivo = "";
        conceptoMotivoId = 0;

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
        ConPeriodoIncidente = "";
        periododOriginalId = -1;

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
        ConConceptoMotivo = "";
        ConParametroConceptoValor = 0;
        ConParametroConceptoMonto = 0;

        //ConConceptoMotivo = $("#Motivo.value").text();
        ConConceptoMotivo = $("#Parametro").val() + ' ' + ConParametroNombre;
        ConParametroConceptoMonto = $("#Parametro").val();
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

function onChange(e) {
    //var selected = $.map(this.select(), function (item) {
    //    //return $(item).text();
    //    return $(item).context.outerText;
    //});

    //var numberPattern = /\d+/g;
    ////var n = str.match(numberPattern);
    ////var f = String(n).split(",");

    //$.each(selected, function (index, value) {
    //    //alert(index + ": " + value);
    //    console.log(index + ": " + value);
    //    var f = String(value.match(numberPattern)).split(",");

    //    console.log(f[0]);
    //    console.log(f[1]);
    //    console.log(f[2]);
    //});

    //console.log("Selected: " + selected.length + " item(s), [" + selected.join(", ") + "]");

    //$(item).context.outerText


    var grid = $("#gridAutorizacion").data("kendoGrid");
    var rowss = $("#gridAutorizacion").data("kendoGrid").tbody.children();
    
    for (var j = 0; j < rowss.length; j++) {
        var row = $(rowss[j]);
        var dataItem = $("#gridAutorizacion").data("kendoGrid").dataItem(row);

        // Disable the checkbox if the location isn't set
        if (dataItem.get("Autorizador_Ident") != usuarioCCMSID || dataItem.get("EstatusId") == "R") {
            //row.css('background-color', '#FFFFCF');
            // What goes here?
            //grid.table.find("tr").find("td:first input").attr("checked", true);
            //row.context.cells[0].firstElementChild.setAttribute("disabled", "disabled");
            //row.context.cells[0].firstElementChild.remove();
            //row.context.cells[0].firstElementChild.remove();
            //console.log(row.context.cells[0].firstElementChild.attributes["disabled"]);
            //console.log(row.context.cells[0].firstElementChild.attributes["disabled"] == undefined);

            if (row.context.cells[0].firstElementChild.attributes["disabled"] != undefined) {
                row.context.cells[0].firstElementChild.checked = false;
                row.context.cells[0].firstElementChild.parentElement.parentElement.classList.remove("k-state-selected");
            } else {
                checkboxActivos++;
            }
        }
    }

    var rows = e.sender.select();

    //var countador = $("#gridAutorizacion").data("kendoGrid").tbody.find("input:checked").closest("tr").length;

    //if (countador > 0) {
    if (rows.length > 0) {
        //rows.each(function (e) {
        //    var grid = $("#gridAutorizacion").data("kendoGrid");
        //    var dataItem = grid.dataItem(this);

        //    console.log(dataItem.FolioSolicitud);
        //    console.log(dataItem.Ident);
        //    console.log(dataItem.ConceptoId);
        //});
        $("#AutorizarSolicitudALL").show();
        $("#RechazarSolicitudALL").show();
    }
    else {
        this.element.find("input")[0].checked = false;
        $("#AutorizarSolicitudALL").hide();
        $("#RechazarSolicitudALL").hide();
        //console.log(rows.length);
    }


    //console.log("The selected product ids are: [" + this.selectedKeyNames().join(", ") + "]");
}

function ocultaCheckbox(e) {
    if (estatusId == 'PA') {
        var grid = e.sender;
        var rows = e.sender.tbody.children();
        var checkboxActivos = 0;
        //var x = 0;
        for (var j = 0; j < rows.length; j++) {
            var row = $(rows[j]);
            var dataItem = e.sender.dataItem(row);

            // Disable the checkbox if the location isn't set
            if (dataItem.get("Autorizador_Ident") != usuarioCCMSID || dataItem.get("EstatusId") == "R") {
                //row.css('background-color', '#FFFFCF');
                // What goes here?
                //grid.table.find("tr").find("td:first input").attr("checked", true);
                //if (j == x) {
                row.context.cells[0].firstElementChild.setAttribute("disabled", "disabled");
                //row.context.cells[0].firstElementChild.remove();
                //row.context.cells[0].firstElementChild.remove();
                //}

                //if (row.context.cells[0].firstElementChild.attributes["disabled"] == undefined) {
                //    //row.context.cells[0].firstElementChild.checked = false;
                //    //row.context.cells[0].firstElementChild.parentElement.parentElement.classList.remove("k-state-selected");
                //    //checkboxActivos++;
                //}

                //row.context.cells[0].firstElementChild.remove();
                //row.context.cells[0].firstElementChild.remove();
            }
            else if (dataItem.get("Autorizador_Ident") == usuarioCCMSID) {
                checkboxActivos++;
            }
        }

        if (checkboxActivos == 0) {
            grid.hideColumn(0);
        }
        else {
            grid.showColumn(0);
        }
    }
    else {
        //FolioSolicitud
        var grid = e.sender;
        grid.hideColumn("FolioSolicitud");
    }
}

function autorizarSolicitudALL() {

    //$("#gridAutorizacion").data("kendoGrid").dataItem($("#gridAutorizacion").data("kendoGrid").select()[0])
    //console.log($("#gridAutorizacion").data("kendoGrid").dataItem($("#gridAutorizacion").data("kendoGrid").select()));

    var rows = $("#gridAutorizacion").data("kendoGrid").select();

    if (rows.length > 0) {
        //rows.each(function (e) {
        //    var dataItem = $("#gridAutorizacion").data("kendoGrid").dataItem(this);

        //    console.log(dataItem.FolioSolicitud);
        //    console.log(dataItem.Ident);
        //    console.log(dataItem.ConceptoId);
        //    console.log(dataItem.NivelAutorizacion);
        //});

        var listaA = [];

        rows.each(function (e) {
            var dataItem = $("#gridAutorizacion").data("kendoGrid").dataItem(this);

            var algo = {
                FolioSolicitud : dataItem.FolioSolicitud,
                Empleado_Ident: dataItem.Ident,
                ConceptoId : dataItem.ConceptoId,
                NivelAutorizacion: dataItem.NivelAutorizacion,
                Accion : 2
            };

            listaA.push(algo);
        });

        var listones = JSON.stringify({ 'liston': listaA });

        $.when(
            $.ajax({
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                type: 'POST',
                url: urlAutorizaSolicitud,
                data: listones,
                success: function () {
                    //$('#result').html('"PassThings()" successfully called.');
                    //console.log("todo bien");
                },
                failure: function (response) {
                    //$('#result').html(response);
                    //console.log("algo paso");
                }
            }) 
        ).done(function () {
            //console.log("finito_A");
            var grid = $("#gridAutorizacion").data("kendoGrid");
            grid._selectedIds = {};
            grid.clearSelection();
            calculaEstatusSolicitud();
            actualizaGrid();
        });

        //$.when(rows.each(function (e) {
        //    //var grid = $("#gridAutorizacion").data("kendoGrid");
        //    var dataItem = $("#gridAutorizacion").data("kendoGrid").dataItem(this);

        //    //console.log(dataItem.FolioSolicitud);
        //    //console.log(dataItem.Ident);
        //    //console.log(dataItem.ConceptoId);
        //    //console.log(dataItem.NivelAutorizacion);

        //    $.when(autorizarSolicitudALLx(dataItem.FolioSolicitud, dataItem.Ident, dataItem.ConceptoId, dataItem.NivelAutorizacion), calculaEstatusSolicitudALL(dataItem.FolioSolicitud)).done(function () {
        //        console.log("done_" + dataItem.FolioSolicitud + "_" + dataItem.Ident + "_" + dataItem.ConceptoId + "_" + dataItem.NivelAutorizacion);
        //    });
        //})).done(function () {
        //    console.log("finito_A");

        //    var grid = $("#gridAutorizacion").data("kendoGrid");
        //    grid._selectedIds = {};
        //    grid.clearSelection();
        //    actualizaGrid();
        //});

        //console.log($("#gridAutorizacion").data("kendoGrid").dataItem($("#gridAutorizacion").data("kendoGrid").select()) + "_A");
    }
}

function rechazarSolicitudALL() {

    //$("#gridAutorizacion").data("kendoGrid").dataItem($("#gridAutorizacion").data("kendoGrid").select()[0])
    //console.log($("#gridAutorizacion").data("kendoGrid").dataItem($("#gridAutorizacion").data("kendoGrid").select()));

    //rechazarSolicitudALLx($("#gridAutorizacion").data("kendoGrid").select());

    var rows = $("#gridAutorizacion").data("kendoGrid").select();

    if (rows.length > 0) {
        //rows.each(function (e) {
        //    var dataItem = $("#gridAutorizacion").data("kendoGrid").dataItem(this);

        //    console.log(dataItem.FolioSolicitud);
        //    console.log(dataItem.Ident);
        //    console.log(dataItem.ConceptoId);
        //    console.log(dataItem.NivelAutorizacion);
        //});

        var listaR = [];

        rows.each(function (e) {
            var dataItem = $("#gridAutorizacion").data("kendoGrid").dataItem(this);

            var algo = {
                FolioSolicitud: dataItem.FolioSolicitud,
                Empleado_Ident: dataItem.Ident,
                ConceptoId: dataItem.ConceptoId,
                NivelAutorizacion: dataItem.NivelAutorizacion,
                Accion: 3
            };

            listaR.push(algo);
        });

        var listones = JSON.stringify({ 'liston': listaR });

        $.when(
            $.ajax({
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                type: 'POST',
                url: urlAutorizaSolicitud,
                data: listones,
                success: function () {
                    //$('#result').html('"PassThings()" successfully called.');
                    //console.log("todo bien");
                },
                failure: function (response) {
                    //$('#result').html(response);
                    //console.log("algo paso");
                }
            })
        ).done(function () {
            //console.log("finito_R");
            var grid = $("#gridAutorizacion").data("kendoGrid");
            grid._selectedIds = {};
            grid.clearSelection();
            calculaEstatusSolicitud();
            actualizaGrid();
        });

        //$.when(rows.each(function (e) {
        //    //var grid = $("#gridAutorizacion").data("kendoGrid");
        //    var dataItem = $("#gridAutorizacion").data("kendoGrid").dataItem(this);

        //    $.when(rechazarSolicitudALLx(dataItem.FolioSolicitud, dataItem.Ident, dataItem.ConceptoId, dataItem.NivelAutorizacion), calculaEstatusSolicitudALL(dataItem.FolioSolicitud)).done(function () {
        //        console.log("done_" + dataItem.FolioSolicitud + "_" + dataItem.Ident + "_" + dataItem.ConceptoId + "_" + dataItem.NivelAutorizacion);
        //    });
        //})).done(function () {
        //    console.log("finito_R");

        //    var grid = $("#gridAutorizacion").data("kendoGrid");
        //    grid._selectedIds = {};
        //    grid.clearSelection();
        //    actualizaGrid();
        //});

        //console.log($("#gridAutorizacion").data("kendoGrid").dataItem($("#gridAutorizacion").data("kendoGrid").select()) + "_R");
    }
}

//function autorizarSolicitudALLx(folioid,eid,conId,nivId) {

//    $.post(urlAutorizaSolicitud + "?FolioSolicitud=" + folioid + "&Empleado_Ident=" + eid + "&ConceptoId=" + conId + "&NivelAutorizacion=" + nivId + "&Accion=" + 2, function (data) {

//        FolioSolicitud = data.FolioSolicitud;

//        if (data.res == -1) {
//            var notification = $("#popupNotification").data("kendoNotification");
//            notification.show("No se pudo procesar la Autorización ", "error");
//        }
//        else {
//            //$("#AutorizarSolicitud").hide();
//            //$("#RechazarSolicitud").hide();
//            $("#CancelarSolicitud").hide();

//            //calculaEstatusSolicitud();
//        }

//        $("#FolioSolicitud").data("kendoNumericTextBox").value(data.FolioSolicitud);
//        //actualizaGrid();
//        //debugger;
//    });

//    //console.log(folioid + "_" + eid + "_" + conId + "_" + nivId + "_A");

//}

//function rechazarSolicitudALLx(folioid, eid, conId, nivId) {

//    $.post(urlAutorizaSolicitud + "?FolioSolicitud=" + folioid + "&Empleado_Ident=" + eid + "&ConceptoId=" + conId + "&NivelAutorizacion=" + nivId + "&Accion=" + 3, function (data) {

//        FolioSolicitud = data.FolioSolicitud;

//        if (data.res == -1) {
//            var notification = $("#popupNotification").data("kendoNotification");
//            notification.show("No se pudo procesar la Autorización ", "error");
//        }
//        else {
//            //$("#AutorizarSolicitud").hide();
//            //$("#RechazarSolicitud").hide();
//            $("#CancelarSolicitud").hide();

//            //calculaEstatusSolicitud();
//        }

//        $("#FolioSolicitud").data("kendoNumericTextBox").value(data.FolioSolicitud);
//        //actualizaGrid();
//        //debugger;
//    });

//    //console.log(folioid + "_" + eid + "_" + conId + "_" + nivId + "_R");
//}


function calculaEstatusSolicitudALL(folioId) {
    
    $.post(urlConsultarEstatusSolicitud + "?FolioSolicitud=" + folioId, function (data) {
        //"&ConceptoId=" + ConceptoId + "@ParametroConceptoMonto=" + ParametroConceptoMonto                                      , int conceptoMotivoId, int responsableId, int periododOriginalId
        if (data.res == -1) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Error al Calcular Estatus", "error");
        }
        $("#Estatus").val(data[0].Descripcion);
    });

    //console.log("calculastatus_" + folioId);
}