//var _perfil = 0;

$(document).ready(function () {
    //debugger;
    FolioSolicitud = $("#FolioSolicitud").val();
    calculaEstatusSolicitud();
    actualizaGrid();

    habilitaCombosAutorizadores(1);
    deshabilitaControlesEdicion()

    // Activar / Desactivar botón Enviar Solicitud
    if (FolioSolicitud == '-1') {
        $("#EnviarSolicitud").hide();
    }
    else {
        $("#EnviarSolicitud").show();
    }

    // Activar / Desactivar botón Cancelar
    if (ClaveEstatusEmpleadoSolicitud == 'R') {
        $("#CancelarEmpleadoSolicitud").show();
    }
    else {
        $("#CancelarEmpleadoSolicitud").hide();
    }

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
    return {
        //folioid: FolioSolicitud,
        FolioSolicitud: $("#FolioSolicitud").val(),
        //FolioSolicitud;
    };
}

function agregarSolicitud() {
    //console.log("Salvado");
    //debugger;
    //infoSolicitud();
    $.post(urlCrearSolicitud + "?FolioSolicitud=" + FolioSolicitud + "&Empleado_Ident=" + EmpCCMSId + "&ConceptoId=" + ConConceptoIdent + "&PeriodoNomina_Id=" + $("#PeriodoNomina_Id").val() + "&ParametroConceptoMonto=" + ConParametroConceptoMonto + "&MotivosSolicitudId=" + ConMotivoIdent + "&conceptoMotivoId=" + conceptoMotivoId + "&responsableId=" + responsableId + "&periododOriginalId=" + periododOriginalId + "&AutorizadorNivel1=" + autorizadorNivel1 + "&AutorizadorNivel2=" + autorizadorNivel2 + "&AutorizadorNivel3=" + autorizadorNivel3 + "&AutorizadorNivel4=" + autorizadorNivel4 + "&AutorizadorNivel5=" + autorizadorNivel5 + "&AutorizadorNivel6=" + autorizadorNivel6 + "&AutorizadorNivel7=" + autorizadorNivel7 + "&AutorizadorNivel8=" + autorizadorNivel8 + "&AutorizadorNivel9=" + autorizadorNivel9, function (data) {
        //"&ConceptoId=" + ConceptoId + "@ParametroConceptoMonto=" + ParametroConceptoMonto                                      , int conceptoMotivoId, int responsableId, int periododOriginalId

        FolioSolicitud = data.FolioSolicitud;

        if (data.res == -2) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Ya existe un registro con este Empleado y Concepto", "error");
        }

        //if (ClaveEstatusEmpleadoSolicitud == "EB" || ClaveEstatusEmpleadoSolicitud == "R") {
        //    $("#AgregarSolicitud").html('<span class="k-icon k-i-add"></span>Guardar');
        //} else {
        $("#AgregarSolicitud").html('<span class="k-icon k-i-add"></span>Agregar');
        //}

        $("#FolioSolicitud").data("kendoNumericTextBox").value(data.FolioSolicitud);
        actualizaGrid();
        //debugger;
    });
}

function enviarSolicitud() {
    //console.log("Salvado");
    //debugger;
    //infoSolicitud();
    $.post(urlEnviaSolicitud + "?FolioSolicitud=" + FolioSolicitud, function (data) {
        //"&ConceptoId=" + ConceptoId + "@ParametroConceptoMonto=" + ParametroConceptoMonto                                      , int conceptoMotivoId, int responsableId, int periododOriginalId
        //debugger;

        if (data.res == -1) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Error al Enviar Solicitud", "error");
        }

        //$("#FolioSolicitud").data("kendoNumericTextBox").value(data.FolioSolicitud);
        actualizaGrid();
        //debugger;

        window.location.href = '../MisSolicitudes/Index';
    });
}

function cancelarSolicitud() {
    ////console.log("Salvado");
    //debugger;
    ////infoSolicitud();
    //$.post(urlCancelaSolicitud + "?FolioSolicitud=" + FolioSolicitud, function (data) {
    //    //"&ConceptoId=" + ConceptoId + "@ParametroConceptoMonto=" + ParametroConceptoMonto                                      , int conceptoMotivoId, int responsableId, int periododOriginalId
    //    debugger;

    //    if (data.res == -1) {
    //        var notification = $("#popupNotification").data("kendoNotification");
    //        notification.show("Error al Cancelar Solicitud", "error");
    //    }

    //    //$("#FolioSolicitud").data("kendoNumericTextBox").value(data.FolioSolicitud);
    //    actualizaGrid();
    //    debugger;
        
    //});

    $("#dialog").data("kendoDialog").open();
}

function cancelarEmpleadoSolicitud() {
    //console.log("Salvado");
    //debugger;
    //infoSolicitud();

    $.post(urlCancelaEmpleadoSolicitud + "?FolioSolicitud=" + FolioSolicitud + "&Empleado_Ident=" + EmpCCMSId + "&ConceptoId=" + ConConceptoIdent, function (data) {
        //"&ConceptoId=" + ConceptoId + "@ParametroConceptoMonto=" + ParametroConceptoMonto                                      , int conceptoMotivoId, int responsableId, int periododOriginalId
        //debugger;

        if (data.res == -1) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Error al Cancelar Solicitud", "error");
        }

        //$("#FolioSolicitud").data("kendoNumericTextBox").value(data.FolioSolicitud);
        actualizaGrid();
        //debugger;
    });
}

function calculaEstatusSolicitud() {
    //debugger;
    if (FolioSolicitud != -1) {
        $.post(urlConsultarEstatusSolicitud + "?FolioSolicitud=" + FolioSolicitud, function (data) {
            //debugger;

            var grid = $("#gridSolicitud").data("kendoGrid");

            if (data.res == -1) {
                var notification = $("#popupNotification").data("kendoNotification");
                notification.show("Error al Calcular Estatus", "error");
            }
            //debugger;

            DescripcionEstatusSolicitud = data[0].Descripcion;
            ClaveEstatusSolicitud = data[0].EstatusSolicitudId;

            // Ocultar el botón Rechazar
            $("#CancelarEmpleadoSolicitud").hide();

            if (ClaveEstatusSolicitud == 'EB') {
                $("#EnviarSolicitud").show();
                $("#Conceptos").data("kendoDropDownList").enable(true);
                $("#CancelarSolicitud").show();
                grid.hideColumn(2);
                grid.hideColumn(3);
                
                //$("#EnviarSolicitud").enable(true);
            }
            else {
                $("#EnviarSolicitud").hide();
                $("#Conceptos").data("kendoDropDownList").enable(false);
                //$("#EnviarSolicitud").attr("disabled", "disabled");
                //$("#EnviarSolicitud").enable(false);
           }

            if (ClaveEstatusSolicitud == 'C' || ClaveEstatusSolicitud == 'A') {
                //$("#EnviarSolicitud").enable(false);
                $("#AgregarSolicitud").hide();
                $("#CancelarSolicitud").hide();
                deshabilitaControlesEdicion();
                grid.hideColumn(0);
                grid.hideColumn(1);
            }

            if (ClaveEstatusSolicitud == 'CE') {
                //$("#EnviarSolicitud").enable(false);
                $("#AgregarSolicitud").hide();
                $("#CancelarSolicitud").hide();
                deshabilitaControlesEdicion();
                grid.hideColumn(0);
                grid.hideColumn(1);
            }

            if (ClaveEstatusSolicitud == 'PA') {
                //$("#EnviarSolicitud").enable(false);
                $("#AgregarSolicitud").hide();
                grid.hideColumn(0);
                grid.hideColumn(1);
            }

            if (ClaveEstatusSolicitud == 'A') {
                //$("#EnviarSolicitud").enable(false);
                $("#AgregarSolicitud").hide();
                grid.hideColumn(0);
                grid.hideColumn(1);
            }

            // Activar / Desactivar botón Rechazar
            if (ClaveEstatusSolicitud == 'R') {
                //$("#CancelarEmpleadoSolicitud").data("kendoButton").enable(false);
                //$("#CancelarEmpleadoSolicitud").data("kendoButton").enable(true);
                //$("#CancelarEmpleadoSolicitud").hide();
                grid.hideColumn(1);
                $("#AgregarSolicitud").hide();
                $("#CCMSIDSolicitado").data("kendoNumericTextBox").enable(false);
                $("#Conceptos").data("kendoDropDownList").enable(false);
                
                $("#mensajeroConceptos").on("click", function () {
                    if ($("#CCMSIDSolicitado").val().length > 0) {
                        //console.log("conceptosMOD");
                        let notificationWidget = $("#popupNotification").data("kendoNotification");
                        var elements = notificationWidget.getNotifications();

                        // remove the two messages from the DOM
                        elements.each(function () {
                            $(this).parent().remove();
                        });

                        notificationWidget.show("El concepto no puede ser modificado, porque es un dato usado como referencia al mismo registro.", "error");
                    }
                });

                $("#mensajeroCCMSIDSolicitado").on("click", function () {
                    if ($("#CCMSIDSolicitado").val().length > 0) {
                        //console.log("conceptosMOD");
                        let notificationWidget = $("#popupNotification").data("kendoNotification");
                        var elements = notificationWidget.getNotifications();

                        // remove the two messages from the DOM
                        elements.each(function () {
                            $(this).parent().remove();
                        });

                        notificationWidget.show("El CCMSID no puede ser modificado, porque es un dato usado como referencia al mismo registro.", "error");
                    }
                });

            }
            else {
                //$("#CancelarEmpleadoSolicitud").hide();
                //$("#CancelarSolicitud").attr("disabled", "disabled");
                //$("#Conceptos").data("kendoDropDownList").enable(true);
            }

            $("#Estatus").val(data[0].Descripcion);
            //debugger;
        });
    }
}

function habilitaControlesEdicion() {

    tempDL = $("#Motivo").data("kendoDropDownList");
    tempDL.enable(true);

    tempDL = $("#ConceptoMotivo").data("kendoDropDownList");
    tempDL.enable(true);

    tempDL = $("#PeriodoIncidente").data("kendoDropDownList");
    tempDL.enable(true);

    var Parametro = $("#Parametro").data("kendoNumericTextBox");
    Parametro.enable(true);

    var CCMSIDIncidente = $("#CCMSIDIncidente").data("kendoNumericTextBox");
    CCMSIDIncidente.enable(true);

}

function deshabilitaControlesEdicion() {

    tempDL = $("#Motivo").data("kendoDropDownList");
    tempDL.enable(false);

    tempDL = $("#ConceptoMotivo").data("kendoDropDownList");
    tempDL.enable(false);

    tempDL = $("#PeriodoIncidente").data("kendoDropDownList");
    tempDL.enable(false);

    var Parametro = $("#Parametro").data("kendoNumericTextBox");
    Parametro.enable(false);

    var CCMSIDIncidente = $("#CCMSIDIncidente").data("kendoNumericTextBox");
    CCMSIDIncidente.enable(false);

}

function habilitaControlesLlave() {

    //var tempDL = $("#Conceptos").data("kendoDropDownList");
    //tempDL.enable(true);
    $("#CCMSIDSolicitado").data("kendoNumericTextBox").enable(true);
    $("#Conceptos").data("kendoDropDownList").enable(true);
}

function deshabilitaControlesLlave() {

    //var tempDL = $("#Conceptos").data("kendoDropDownList");
    //tempDL.enable(false);

    $("#CCMSIDSolicitado").data("kendoNumericTextBox").enable(false);
    $("#Conceptos").data("kendoDropDownList").enable(false);
}

function verEmpleadoSolicitud(e) {
    //debugger;
    e.preventDefault(); // sho J
    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));

    //Calcular los valores que retorna dataItem
    dataItem_FolioSolicitud = dataItem.FolioSolicitud;
    dataItem_Ident = dataItem.Ident;
    dataItem_Nombre = dataItem.Nombre;
    dataItem_ConceptoId = dataItem.ConceptoId;
    //dataItem_ConceptoDesc = dataItem.
    dataItem_Monto = dataItem.Monto;
    dataItem_MotivosSolicitudId = dataItem.MotivosSolicitudId;
    //dataItem_MotivosSolicitudDesc = dataItem.
    dataItem_ConceptoMotivoId = dataItem.ConceptoMotivoId;
    //dataItem_ConceptoMotivoDesc = dataItem.
    dataItem_ResponsableId = dataItem.ResponsableId;
    //dataItem_NombreResponsable = dataItem.
    dataItem_PeriodoOriginalId = dataItem.PeriodoOriginalId;
    dataItem_EstatusId = dataItem.EstatusId;
    //dataItem_EstatusSolicitud = dataItem.

    if (dataItem_EstatusId == "EB" || dataItem_EstatusId == "R") {
        $("#AgregarSolicitud").html('<span class="k-icon k-i-add"></span>Guardar');
        //} else if (dataItem_EstatusId == "CE") {
        //    deshabilitaControlesEdicion();
    } else {
        $("#AgregarSolicitud").html('<span class="k-icon k-i-add"></span>Agregar');
    }

    $.when($("#CCMSIDSolicitado").data('kendoNumericTextBox').value(dataItem_Ident),
        $('#CCMSIDSolicitado').data('kendoNumericTextBox').trigger('change')
    ).done(function () {
        console.log("CCMSID Change");
        $.when(
            $("#CCMSIDIncidente").data('kendoNumericTextBox').value(dataItem_ResponsableId),
            $('#CCMSIDIncidente').data('kendoNumericTextBox').trigger('change')
        ).done(function () {
            console.log("CCMSIdIncidente Change");
            $.when(

                $("#Conceptos").data("kendoDropDownList").dataSource.read(),
                $("#Conceptos").data("kendoDropDownList").refresh(),

            ).done(function () {
                console.log("Conceptos Fill");
                $.when(
                    $("#Conceptos").data('kendoDropDownList').value(dataItem_ConceptoId),
                    $('#Conceptos').data('kendoDropDownList').trigger('change'),
                    conceptoParametroConcepto(dataItem_ConceptoId, dataItem_Monto)
                ).done(function () {
                    console.log("Conceptos Change");
                    $.when(
                        inicializaAutorizadores(dataItem_Ident, dataItem_ConceptoId)
                        //solicitudAutorizantes()
                    ).done(function () {
                        console.log("Solicitud Autorizantes Change");
                        $.when(
                            //inicializaAutorizadores(dataItem_Ident, dataItem_ConceptoId)
                            solicitudAutorizantes()
                        ).done(function () {
                            console.log("Inicializa Autorizantes");
                        });
                    });

                });
            });
        });

        //deshabilitaControlesEdicion();

    });

    if (dataItem_EstatusId == "EB" || dataItem_EstatusId == "") {

        habilitaControlesLave();
        habilitaControlesEdicion();

    }
    else {

        deshabilitaControlesLave();

   }

    // Procesar el estatus de EmpleadoSolicitud
    // Activar / Desactivar botón Rechazar
    if (dataItem_EstatusId == 'R') {
        $("#AgregarSolicitud").show();
        $("#CancelarEmpleadoSolicitud").show();
    }
    else if (dataItem_EstatusId == 'EB') {
        $("#AgregarSolicitud").show();
        $("#EnviarSolicitud").show();
        $("#CancelarEmpleadoSolicitud").hide();
    }
    else {
        $("#AgregarSolicitud").hide();
        $("#EnviarSolicitud").hide();
        $("#CancelarEmpleadoSolicitud").hide();
    }

    //debugger;
    $("#Parametro").data('kendoNumericTextBox').value(dataItem_Monto);
    $('#Parametro').data('kendoNumericTextBox').trigger('change');

    $("#Motivo").data('kendoDropDownList').value(dataItem_MotivosSolicitudId);
    $('#Motivo').data('kendoDropDownList').trigger('change');

    $("#ConceptoMotivo").data('kendoDropDownList').value(dataItem_ConceptoMotivoId);
    $('#ConceptoMotivo').data('kendoDropDownList').trigger('change');

    $("#PeriodoIncidente").data('kendoDropDownList').value(dataItem_PeriodoOriginalId);
    $('#PeriodoIncidente').data('kendoDropDownList').trigger('change');

    $("#AutorizadorNivel1").data('kendoDropDownList').value(dataItem_AutorizadorNivel1);

    $("#AutorizadorNivel2").data('kendoDropDownList').value(dataItem_AutorizadorNivel2);

    $("#AutorizadorNivel3").data('kendoDropDownList').value(dataItem_AutorizadorNivel3);

    $("#AutorizadorNivel4").data('kendoDropDownList').value(dataItem_AutorizadorNivel4);

    $("#AutorizadorNivel5").data('kendoDropDownList').value(dataItem_AutorizadorNivel5);

    $("#AutorizadorNivel6").data('kendoDropDownList').value(dataItem_AutorizadorNivel6);

    $("#AutorizadorNivel7").data('kendoDropDownList').value(dataItem_AutorizadorNivel7);

    $("#AutorizadorNivel8").data('kendoDropDownList').value(dataItem_AutorizadorNivel8);

    $("#AutorizadorNivel9").data('kendoDropDownList').value(dataItem_AutorizadorNivel9);

    //debugger;
    var rowIndex = $(e.currentTarget).closest("tr").index();
    var grid = $("#gridSolicitud").data("kendoGrid");
    grid.select("tr:eq(" + rowIndex + ")");    

    //Al final se desactiva la edición de los controles 
    //deshabilitaControlesEdicion();
}

function actualizaGrid() {
    $("#gridSolicitud").data("kendoGrid").dataSource.read();
    $("#gridSolicitud").data("kendoGrid").refresh();
    $("#Estatus").value = calculaEstatusSolicitud();
    //debugger;
}

function editarEmpleadoSolicitud(e) {
    //debugger;
    e.preventDefault(); // sho J
    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));

    //Calcular los valores que retorna dataItem
    dataItem_FolioSolicitud = dataItem.FolioSolicitud;
    dataItem_Ident = dataItem.Ident;
    dataItem_Nombre = dataItem.Nombre;
    dataItem_ConceptoId = dataItem.ConceptoId;
    //dataItem_ConceptoDesc = dataItem.
    dataItem_Monto = dataItem.Monto;
    dataItem_MotivosSolicitudId = dataItem.MotivosSolicitudId;
    //dataItem_MotivosSolicitudDesc = dataItem.
    dataItem_ConceptoMotivoId = dataItem.ConceptoMotivoId;
    //dataItem_ConceptoMotivoDesc = dataItem.
    dataItem_ResponsableId = dataItem.ResponsableId;
    //dataItem_NombreResponsable = dataItem.
    dataItem_PeriodoOriginalId = dataItem.PeriodoOriginalId;
    dataItem_EstatusId = dataItem.EstatusId;
    //dataItem_EstatusSolicitud = dataItem.
    ////dataItem_NivelAutorizacion1 = dataItem.
    //dataItem_AutorizadorNivel1 = dataItem.AutorizadorNivel1;
    ////dataItem_NivelAutorizacion2 = dataItem.
    //dataItem_AutorizadorNivel2 = dataItem.AutorizadorNivel2;
    ////dataItem_NivelAutorizacion3 = dataItem.
    //dataItem_AutorizadorNivel3 = dataItem.AutorizadorNivel3;
    ////dataItem_NivelAutorizacion4 = dataItem.
    //dataItem_AutorizadorNivel4 = dataItem.AutorizadorNivel4;
    ////dataItem_NivelAutorizacion5 = dataItem.
    //dataItem_AutorizadorNivel5 = dataItem.AutorizadorNivel5;
    ////dataItem_NivelAutorizacion6 = dataItem.
    //dataItem_AutorizadorNivel6 = dataItem.AutorizadorNivel6;
    ////dataItem_NivelAutorizacion7 = dataItem.
    //dataItem_AutorizadorNivel7 = dataItem.AutorizadorNivel7;
    ////dataItem_NivelAutorizacion8 = dataItem.
    //dataItem_AutorizadorNivel8 = dataItem.AutorizadorNivel8;
    ////dataItem_NivelAutorizacion9 = dataItem.
    //dataItem_AutorizadorNivel9 = dataItem.AutorizadorNivel9;
    //dataItem_Active = dataItem.

    if (dataItem_EstatusId == 'EB') {
        habilitaControlesLlave();
        habilitaControlesEdicion();
    }
    else if (dataItem_EstatusId == 'R') {
        deshabilitaControlesLlave();
        habilitaControlesEdicion();
    }
    else {
        deshabilitaControlesLlave();
        deshabilitaControlesEdicion();
    }

    if (dataItem_EstatusId == "EB" || dataItem_EstatusId == "R") {
        $("#AgregarSolicitud").html('<span class="k-icon k-i-add"></span>Guardar');
    //} else if (dataItem_EstatusId == "CE") {
    //    deshabilitaControlesEdicion();
    } else {
        $("#AgregarSolicitud").html('<span class="k-icon k-i-add"></span>Agregar');
    }

    $.when($("#CCMSIDSolicitado").data('kendoNumericTextBox').value(dataItem_Ident),
        $('#CCMSIDSolicitado').data('kendoNumericTextBox').trigger('change')
    ).done(function () {
        console.log("CCMSID Change");
        $.when(
            $("#CCMSIDIncidente").data('kendoNumericTextBox').value(dataItem_ResponsableId),
            $('#CCMSIDIncidente').data('kendoNumericTextBox').trigger('change')
        ).done(function () {
            console.log("CCMSIdIncidente Change");
            $.when(

                $("#Conceptos").data("kendoDropDownList").dataSource.read(),
                $("#Conceptos").data("kendoDropDownList").refresh(),

            ).done(function () {
                console.log("Conceptos Fill");
                $.when(
                    $("#Conceptos").data('kendoDropDownList').value(dataItem_ConceptoId),
                    $('#Conceptos').data('kendoDropDownList').trigger('change'),
                    conceptoParametroConcepto(dataItem_ConceptoId, dataItem_Monto)
                ).done(function () {
                    console.log("Conceptos Change");
                    $.when(
                        inicializaAutorizadores(dataItem_Ident, dataItem_ConceptoId)
                        //solicitudAutorizantes()
                    ).done(function () {
                        console.log("Solicitud Autorizantes Change");
                        $.when(
                            //inicializaAutorizadores(dataItem_Ident, dataItem_ConceptoId)
                            solicitudAutorizantes()
                        ).done(function () {
                            console.log("Inicializa Autorizantes");
                        });
                    });

                });
            });            
        });
    });


    //conceptoParametroConcepto

    //Llenar controles

    //Carga combos:



    // Se actualiza comboBox de Conceptos
    //$("#Conceptos").data("kendoDropDownList").dataSource.read();
    //$("#Conceptos").data("kendoDropDownList").refresh();

    // Se actualizan combos de Autorizadores
    //$('#AutorizadorNivel1').data('kendoDropDownList').dataSource.read();
    //$("#AutorizadorNivel1").data("kendoDropDownList").refresh();

    //$('#AutorizadorNivel2').data('kendoDropDownList').dataSource.read();
    //$("#AutorizadorNivel2").data("kendoDropDownList").refresh();

    //$('#AutorizadorNivel3').data('kendoDropDownList').dataSource.read();
    //$("#AutorizadorNivel3").data("kendoDropDownList").refresh();

    //$('#AutorizadorNivel4').data('kendoDropDownList').dataSource.read();
    //$("#AutorizadorNivel4").data("kendoDropDownList").refresh();

    //$('#AutorizadorNivel5').data('kendoDropDownList').dataSource.read();
    //$("#AutorizadorNivel5").data("kendoDropDownList").refresh();

    //$('#AutorizadorNivel6').data('kendoDropDownList').dataSource.read();
    //$("#AutorizadorNivel6").data("kendoDropDownList").refresh();

    //$('#AutorizadorNivel7').data('kendoDropDownList').dataSource.read();
    //$("#AutorizadorNivel7").data("kendoDropDownList").refresh();

    //$('#AutorizadorNivel8').data('kendoDropDownList').dataSource.read();
    //$("#AutorizadorNivel8").data("kendoDropDownList").refresh();

    //$('#AutorizadorNivel9').data('kendoDropDownList').dataSource.read();
    //$("#AutorizadorNivel9").data("kendoDropDownList").refresh();


    //CCMSIdResponsable = dataItem.ResponsableId;
    //ConConceptoIdent = dataItem.ConceptoId;
    //ClaveEstatusEmpleadoSolicitud = dataItem.EstatusId;

    // Procesar el estatus de EmpleadoSolicitud
    // Activar / Desactivar botón Rechazar
    if (dataItem_EstatusId == 'R') {
        $("#AgregarSolicitud").show();
        $("#CancelarEmpleadoSolicitud").show();
    }
    else if (dataItem_EstatusId == 'EB') {
        $("#AgregarSolicitud").show();
        $("#EnviarSolicitud").show();
        $("#CancelarEmpleadoSolicitud").hide();
    }
    //else if (dataItem_EstatusId == 'CE') {
    //    $("#AgregarSolicitud").hide();
    //    $("#EnviarSolicitud").hide();
    //    $("#CancelarEmpleadoSolicitud").hide();
    //    deshabilitaControlesEdicion();
    //}
    else {
        $("#AgregarSolicitud").hide();
        $("#EnviarSolicitud").hide();
        $("#CancelarEmpleadoSolicitud").hide();
    }

    //// Procesar el estatus de EmpleadoSolicitud
    //// Activar / Desactivar botón Rechazar
    //if (ClaveEstatusEmpleadoSolicitud == 'R') {
    //    $("#CancelarEmpleadoSolicitud").show();
    //}
    //else {
    //    $("#CancelarEmpleadoSolicitud").hide();
    //}

    //debugger;
    //$("#CCMSIDSolicitado").data('kendoNumericTextBox').value(dataItem_Ident);
    //$('#CCMSIDSolicitado').data('kendoNumericTextBox').trigger('change');

    // Se actualiza comboBox de Conceptos
    //$("#Conceptos").data("kendoDropDownList").dataSource.read();
    //$("#Conceptos").data("kendoDropDownList").refresh();

    //$("#Conceptos").data('kendoDropDownList').value(dataItem_ConceptoId);
    //$('#Conceptos').data('kendoDropDownList').trigger('change');
    //debugger;
    $("#Parametro").data('kendoNumericTextBox').value(dataItem_Monto);
    $('#Parametro').data('kendoNumericTextBox').trigger('change');

    $("#Motivo").data('kendoDropDownList').value(dataItem_MotivosSolicitudId);
    $('#Motivo').data('kendoDropDownList').trigger('change');

    $("#ConceptoMotivo").data('kendoDropDownList').value(dataItem_ConceptoMotivoId);
    $('#ConceptoMotivo').data('kendoDropDownList').trigger('change');

    $("#PeriodoIncidente").data('kendoDropDownList').value(dataItem_PeriodoOriginalId);
    $('#PeriodoIncidente').data('kendoDropDownList').trigger('change');

    $("#AutorizadorNivel1").data('kendoDropDownList').value(dataItem_AutorizadorNivel1);

    $("#AutorizadorNivel2").data('kendoDropDownList').value(dataItem_AutorizadorNivel2);

    $("#AutorizadorNivel3").data('kendoDropDownList').value(dataItem_AutorizadorNivel3);

    $("#AutorizadorNivel4").data('kendoDropDownList').value(dataItem_AutorizadorNivel4);

    $("#AutorizadorNivel5").data('kendoDropDownList').value(dataItem_AutorizadorNivel5);

    $("#AutorizadorNivel6").data('kendoDropDownList').value(dataItem_AutorizadorNivel6);

    $("#AutorizadorNivel7").data('kendoDropDownList').value(dataItem_AutorizadorNivel7);

    $("#AutorizadorNivel8").data('kendoDropDownList').value(dataItem_AutorizadorNivel8);

    $("#AutorizadorNivel9").data('kendoDropDownList').value(dataItem_AutorizadorNivel9);

    //debugger;
    //Carga de valor de responsable
    //$("#CCMSIdIncidente").data('kendoNumericTextBox').value(dataItem_ResponsableId);
    //$('#CCMSIdIncidente').data('kendoNumericTextBox').trigger('change');

    //debugger;
    var rowIndex = $(e.currentTarget).closest("tr").index();
    var grid = $("#gridSolicitud").data("kendoGrid");
    grid.select("tr:eq(" + rowIndex + ")");
}

function solicitudAutorizantes() {
    $.post(urlSolicitudAutorizantes + "/?FolioSolicitud=" + dataItem_FolioSolicitud + "&ConceptoId=" + dataItem_ConceptoId + "&Empleado_Ident=" + dataItem_Ident, function (data) {
        //debugger;

        ////Se actualizan combos de Autorizadores
        //$('#AutorizadorNivel1').data('kendoDropDownList').dataSource.read();
        //$("#AutorizadorNivel1").data("kendoDropDownList").refresh();

        //$('#AutorizadorNivel2').data('kendoDropDownList').dataSource.read();
        //$("#AutorizadorNivel2").data("kendoDropDownList").refresh();

        //$('#AutorizadorNivel3').data('kendoDropDownList').dataSource.read();
        //$("#AutorizadorNivel3").data("kendoDropDownList").refresh();

        //$('#AutorizadorNivel4').data('kendoDropDownList').dataSource.read();
        //$("#AutorizadorNivel4").data("kendoDropDownList").refresh();

        //$('#AutorizadorNivel5').data('kendoDropDownList').dataSource.read();
        //$("#AutorizadorNivel5").data("kendoDropDownList").refresh();

        //$('#AutorizadorNivel6').data('kendoDropDownList').dataSource.read();
        //$("#AutorizadorNivel6").data("kendoDropDownList").refresh();

        //$('#AutorizadorNivel7').data('kendoDropDownList').dataSource.read();
        //$("#AutorizadorNivel7").data("kendoDropDownList").refresh();

        //$('#AutorizadorNivel8').data('kendoDropDownList').dataSource.read();
        //$("#AutorizadorNivel8").data("kendoDropDownList").refresh();

        //$('#AutorizadorNivel9').data('kendoDropDownList').dataSource.read();
        //$("#AutorizadorNivel9").data("kendoDropDownList").refresh();


        var lista = data;

        var autorizadores = $("div[name='nivel']");

        for (index = 0; index < lista.length; index++) {
            //debugger;

            $(autorizadores).each(function (nivel) {

                if (this.id = (index + 1)) {
                    //debugger;
                    $("#AutorizadorNivel" + this.id).data('kendoDropDownList').value(lista[index].Autorizador_Ident);

                    var autorizadorNivel = "autorizadorNivel" + this.id;
                    window[autorizadorNivel] = lista[index].Autorizador_Ident;

                    //this["autorizadorNivel" + this.id] = lista[index].Autorizador_Ident;

                    //$("#autorizadorNivel" + this.id) = lista[index].Autorizador_Ident;                    
                }
            });
        }

        //data[0].FolioSolicitud
        //18
        //data.length
        //4


        //var grid = $("#gridSolicitud").data("kendoGrid");
        //var selectedRows = grid.select();

        //actualizaGrid();

        //grid.select("tr:eq(" + selectedRows(0) + ")");

    }).fail(function (ex) {
        console.log("fail" + ex);
    });
}

function borrarEmpleadoSolicitud(e) {
    //debugger;

    if (confirm("Desea eliminar este registro?")) {

        e.preventDefault(); // sho J
        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
        //debugger;
        var Solicitud_Ident = dataItem.FolioSolicitud;
        var Empleado_Ident = dataItem.Ident;
        var ConceptoId = dataItem.ConceptoId;
        //Se ejecuta Update con Active=false para eliminar el acceso respondiendo al botón Borrar
        var Active = false;

        //int Perfil_Ident, int Ident, bool Active
        $.post(urlUpdateEmpleadoSolicitud + "/?FolioSolicitud=" + Solicitud_Ident + "&Empleado_Ident=" + Empleado_Ident + "&ConceptoId=" + ConceptoId + "&Activo=" + Active, function (data) {
            //debugger;

            var grid = $("#gridSolicitud").data("kendoGrid");
            var selectedRows = grid.select();

            actualizaGrid();

            //grid.select("tr:eq(" + selectedRows(0) + ")");

        }).fail(function (ex) {
            console.log("fail" + ex);
        });
    }
}

function onDataBound(e) {
    var grid = $("#gridSolicitud").data("kendoGrid");
    var gridData = grid.dataSource.view();

    //debugger;

    for (var i = 0; i < gridData.length; i++) {
        var currentUid = gridData[i].uid;
        var currenRow = grid.table.find("tr[data-uid='" + currentUid + "']");
        var EditButton = $(currenRow).find(".k-grid-Editar");
        var ViewButton = $(currenRow).find(".k-grid-Ver");
        var DeleteButton = $(currenRow).find(".k-grid-Borrar");
        var ComentariosButton = $(currenRow).find(".comentarioss");

        if (gridData[i].EstatusId == "EB") {
            EditButton.show();
            DeleteButton.show();
            ViewButton.hide();
            ComentariosButton.hide();
        }
        else if (gridData[i].EstatusId == "R") {
            EditButton.show();
            DeleteButton.hide();
            ViewButton.hide();
            ComentariosButton.show();
        }
        else {
            EditButton.hide();
            DeleteButton.hide();
            ViewButton.show();
            ComentariosButton.show();
        }

        //if (gridData[i].UPLOAD == 0) {
        //    UplButton.show();
        //    ViwButton.hide();
        //}
        //else if (gridData[i].UPLOAD == 1) {
        //    UplButton.show();
        //    ViwButton.show();
        //}
        //else {
        //    UplButton.hide();
        //    ViwButton.hide();
        //}
    }
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

function onChangeFolioSolicitud() {
   // debugger;

    //FolioSolicitud = data.FolioSolicitud;
    //FolioSolicitud: $("#FolioSolicitud").val();

    actualizaGrid();
}

function getIdent() {
    var Ident = -1;
    CCMSId = "";
    //debugger;
    CCMSId = $("#CCMSIDSolicitado").val();

    if (CCMSId.length > 0) {
        Ident = CCMSId;
    }
    else {
        Ident = -1;
    }

    return {
        Ident: Ident,
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
            responsableSugeridoId = data[0].IdentManager;
            NombreResponsableIncidente = data[0].NombreManager;

            Active = data[0].Active;

            if (EmpCCMSId > 0) {
                $("#CCMSIDX").val(EmpCCMSId);
                $("#CCMSIDX").text(EmpCCMSId);

                //debugger;
                $("#Conceptos").data("kendoDropDownList").dataSource.read(parametrosConceptos);
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
            if (responsableSugeridoId !== dataItem_ResponsableId) {
                $("#CCMSIDIncidente").data("kendoNumericTextBox").value(responsableSugeridoId);
                $("#CCMSIDIncidente").data("kendoNumericTextBox").trigger('change');
                 // Sugerencia de responsable de incidente es el Manager del empleado
                $("#ResponsableCCMSIDX").val(responsableId);
                $("#ResponsableCCMSIDX").text(responsableId);
                $("#NombreRespoX").val(NombreResponsableIncidente);
                $("#NombreRespoX").text(NombreResponsableIncidente);
                //dataItem_ResponsableId = 0;
            }
            //debugger;
            if (dataItem_EstatusId == 'EB' || dataItem_EstatusId == '') {
                habilitaControlesLlave();
                habilitaControlesEdicion();
            }
            else if (dataItem_EstatusId == 'R') {
                deshabilitaControlesLlave();
                habilitaControlesEdicion();
            }
            else {
                deshabilitaControlesLlave();
                deshabilitaControlesEdicion();
            }

            if (EmpCCMSId == -1) {
                $("#AgregarSolicitud").kendoButton({enable: false});

                var notification = $("#popupNotification").data("kendoNotification");
                notification.show("No tiene permiso para crear una solicitud a este empleado.", "error");
                deshabilitaControlesEdicion();
            }

            if (EmpCCMSId == -2) {
                $("#AgregarSolicitud").kendoButton({ enable: false });

                var notification = $("#popupNotification").data("kendoNotification");
                notification.show("Este empleado no existe o no está activo.", "error");
                deshabilitaControlesEdicion();
            }

            if (EmpCCMSId > 0) {
                //$("#AgregarSolicitud").kendoButton({ enable: true });
                $("#AgregarSolicitud").data("kendoButton").enable(true);
            //habilitaControlesEdicion();
            }

            //if ($("#Estatus").val() == "Cerrada" || $("#Estatus").val() == "Cancelada") {
            //    deshabilitaControlesEdicion();
            //}

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

function onChangeConceptos(e) {
    //debugger;

    if ($("#Conceptos").val().length > 0) {
        //$('#grid').data('kendoGrid').dataSource.data([]);

        ConConceptoIdent = ""
        ConConceptoNombre = ""
        ConParametroId = ""
        ConParametroNombre = ""
        ConNivelesAutorizacion = ""

        ConConceptoIdent = $("#Conceptos").val();
        //debugger;

        //rellenaPerfilTipoAcceso();

        $('#AutorizadorNivel1').data('kendoDropDownList').dataSource.read();
        $("#AutorizadorNivel1").data("kendoDropDownList").refresh();
        $("#AutorizadorNivel1").data("kendoDropDownList").value(-1);
        $('#AutorizadorNivel2').data('kendoDropDownList').dataSource.read();
        $("#AutorizadorNivel2").data("kendoDropDownList").refresh();
        $("#AutorizadorNivel2").data("kendoDropDownList").value(-1);
        $('#AutorizadorNivel3').data('kendoDropDownList').dataSource.read();
        $("#AutorizadorNivel3").data("kendoDropDownList").refresh();
        $("#AutorizadorNivel3").data("kendoDropDownList").value(-1);
        $('#AutorizadorNivel4').data('kendoDropDownList').dataSource.read();
        $("#AutorizadorNivel4").data("kendoDropDownList").refresh();
        $("#AutorizadorNivel4").data("kendoDropDownList").value(-1);
        $('#AutorizadorNivel5').data('kendoDropDownList').dataSource.read();
        $("#AutorizadorNivel5").data("kendoDropDownList").refresh();
        $("#AutorizadorNivel5").data("kendoDropDownList").value(-1);
        $('#AutorizadorNivel6').data('kendoDropDownList').dataSource.read();
        $("#AutorizadorNivel6").data("kendoDropDownList").refresh();
        $("#AutorizadorNivel6").data("kendoDropDownList").value(-1);
        $('#AutorizadorNivel7').data('kendoDropDownList').dataSource.read();
        $("#AutorizadorNivel7").data("kendoDropDownList").refresh();
        $("#AutorizadorNivel7").data("kendoDropDownList").value(-1);
        $('#AutorizadorNivel8').data('kendoDropDownList').dataSource.read();
        $("#AutorizadorNivel8").data("kendoDropDownList").refresh();
        $("#AutorizadorNivel8").data("kendoDropDownList").value(-1);
        $('#AutorizadorNivel9').data('kendoDropDownList').dataSource.read();
        $("#AutorizadorNivel9").data("kendoDropDownList").refresh();
        $("#AutorizadorNivel9").data("kendoDropDownList").value(-1);

        $.when(conceptoParametroConcepto(ConConceptoIdent, ConParametroNombre))
            .done(function () {
                inicializaAutorizadores(CCMSId, ConConceptoIdent);
            });

        //$.post(urlConceptoParametroConcepto + "/?conceptoIdent=" + ConConceptoIdent, function (data) {
        //    debugger;
        //    ConConceptoIdent = data[0].ConceptoId;
        //    ConConceptoNombre = data[0].DescripcionConcepto;
        //    ConParametroId = data[0].TipoconceptoId;
        //    ConParametroNombre = data[0].DescripcionParametroConcepto;
        //    ConNivelesAutorizacion = data[0].NivelesAutorizacion;

        //    $("#ConceptoX").val(ConConceptoNombre);
        //    $("#ConceptoX").text(ConConceptoNombre);    
        //    $("#ParametroX").val(ConParametroNombre);
        //    $("#ParametroX").text(ConParametroNombre);

        //    habilitaCombosAutorizadores(ConNivelesAutorizacion);
        //    //debugger;


        //}).fail(function (ex) {
        //    //debugger;
        //    console.log("fail" + ex);
        //});

    }
    else {

        $("#ConceptoX").val("");
        $("#ConceptoX").text("");
        $("#ParametroX").val("");
        $("#ParametroX").text("");
    }
}


function inicializaAutorizadores(empleadoIdent, conceptoId) {
    $.post(urlNivelesAutorizacionxEmpleadoxConcepto + "/?EmpleadoIdent=" + empleadoIdent + "&ConceptoId=" + conceptoId + "&folioId=" + $("#FolioSolicitud").val(), function (data) {
        //debugger;

        var lista = data;
        var autorizadores = $("div[name='nivel']");

        $(autorizadores).each(function (nivel) {
            //$("#AutorizadorNivel" + (nivel + 1)).val() = 0

            var autorizadorNivel = "autorizadorNivel" + nivel;
            window[autorizadorNivel] = null;

        });


        for (index = 0; index < lista.length; index++) {
            //debugger;

            if (lista[index].Nivel < 10) {
                $("#AutorizadorNivel" + lista[index].Nivel).data('kendoDropDownList').value(lista[index].Id);

                var autorizadorNivel = "autorizadorNivel" + lista[index].Nivel;
                window[autorizadorNivel] = lista[index].Id;
            }
            //else {
            //    var autorizadorNivel = "autorizadorNivel" + lista[index].Nivel;
            //    window[autorizadorNivel] = 0;
            //}
        }

        //if (this.id = (index + 1)) {
        //    debugger;
            //$("#AutorizadorNivel" + this.id).data('kendoDropDownList').value(lista[index].Autorizador_Ident);

            //var autorizadorNivel = "autorizadorNivel" + this.id;
            //window[autorizadorNivel] = lista[index].Autorizador_Ident;

            //this["autorizadorNivel" + this.id] = lista[index].Autorizador_Ident;

            //$("#autorizadorNivel" + this.id) = lista[index].Autorizador_Ident;                    
        //}

        //debugger;

    }).fail(function (ex) {
        //debugger;
        console.log("fail" + ex);
    });
}

function conceptoParametroConcepto(conceptoIdent) {
    $.post(urlConceptoParametroConcepto + "/?conceptoIdent=" + conceptoIdent + "&eid=" + $("#CCMSIDSolicitado").val(), function (data) {
        //debugger;
        ConConceptoIdent = data[0].ConceptoId;
        ConConceptoNombre = data[0].DescripcionConcepto;
        ConParametroId = data[0].TipoconceptoId;
        ConParametroNombre = ConParametroConceptoMonto + ' ' + data[0].DescripcionParametroConcepto;//(monto.length <= 0 ? ConParametroConceptoMonto : monto) + " " + data[0].DescripcionParametroConcepto;
        ConNivelesAutorizacion = data[0].NivelesAutorizacion;

        $("#ConceptoX").val(ConConceptoNombre);
        $("#ConceptoX").text(ConConceptoNombre);
        $("#ParametroX").val(ConParametroNombre);
        $("#ParametroX").text(ConParametroNombre);

        habilitaCombosAutorizadores(ConNivelesAutorizacion);
        //debugger;


    }).fail(function (ex) {
        //debugger;
        console.log("fail" + ex);
    });

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

    if ($("#Motivo").data('kendoDropDownList').text() == 'N/A') {
        $("#ConceptoMotivo").data('kendoDropDownList').value('-1');
        $("#ConceptoMotivo").data('kendoDropDownList').enable(false);
        $("#ConceptoMotivoX").val("");
        $("#ConceptoMotivoX").text("");
    }
    else {
        $("#ConceptoMotivo").data('kendoDropDownList').enable(true);
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
    //debugger;

    if ($("#Parametro").val().length > 0) {
        //debugger;
        ConConceptoMotivo = "";
        ConParametroConceptoValor = 0;
        ConParametroConceptoMonto = 0;

        //ConConceptoMotivo = $("#Motivo.value").text();
        ConConceptoMotivo = $("#Parametro").val(); // + ' ' + ConParametro;
        ConParametroConceptoMonto = $("#Parametro").val();
        //debugger;

        //rellenaPerfilTipoAcceso();

        var valor = $("#Parametro").val() + " " + ConParametroNombre.substring(ConParametroNombre.indexOf(" ") + 1);

        $("#ParametroX").val(valor);
        $("#ParametroX").text(valor);
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

function validaAutorizador(valor) {
    var autorizadores = $("div[name='nivel']");
    var igualesTotales = 0;
    //debugger;
    $(autorizadores).each(function (nivel) {

        if ($("#AutorizadorNivel" + (nivel + 1)).val() == valor) {

            igualesTotales++;
        }        
    });

    if (igualesTotales == 1) {
        return true;
    }
    else {
        return false;
    }
}

function habilitaConceptoMotivoPeriodoOriginal() {

    $("#ConceptoMotivo").data("kendoDropDownList").enable(true);
    $("#PeriodoIncidente").data("kendoDropDownList").enable(true);

}

function deshabilitaConceptoMotivoPeriodoOriginal() {

    $("#ConceptoMotivo").data("kendoDropDownList").enable(false);
    $("#PeriodoIncidente").data("kendoDropDownList").enable(false);

}

function habilitaCombosAutorizadores(nivelAutorizador) {
    var autorizadores = $("div[name='nivel']");
    //debugger;
    $(autorizadores).each(function (nivel) {
        //console.log(index + ": " + $(this).text());
        //console.log("ssss");
        if (nivel < nivelAutorizador) {
            //debugger;
            $(this).show();
        }
        if (nivel >= nivelAutorizador) {
            //debugger;
            $(this).hide();
        }
    });
}

function onChangeAutorizadorNivel1() {
    //debugger;

    if ($("#AutorizadorNivel1").data('kendoDropDownList').text().length > 0) {

        autorizadorNivel1 = "";
        //debugger;

        autorizadorNivel1 = $("#AutorizadorNivel1").val();
    }

    if (autorizadorNivel1 !== "") {

        if (!validaAutorizador(autorizadorNivel1)) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Este autorizador ya está asignado a otro nivel.", "error");
            $("#AutorizadorNivel1").data("kendoDropDownList").value(0);
            $("#AutorizadorNivel1").data("kendoDropDownList").text("");
            autorizadorNivel1 = "";
        }
    }
}

function onChangeAutorizadorNivel2() {
    //debugger;

    if ($("#AutorizadorNivel2").data('kendoDropDownList').text().length > 0) {

        autorizadorNivel2 = "";
        //debugger;

        autorizadorNivel2 = $("#AutorizadorNivel2").val();
    }

    if (autorizadorNivel2 !== "") {

        if (!validaAutorizador(autorizadorNivel2)) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Este autorizador ya está asignado a otro nivel.", "error");
            $("#AutorizadorNivel2").data("kendoDropDownList").value(0);
            $("#AutorizadorNivel2").data("kendoDropDownList").text("");
            autorizadorNivel2 = "";
        }
    }
}

function onChangeAutorizadorNivel3() {
    //debugger;

    if ($("#AutorizadorNivel3").data('kendoDropDownList').text().length > 0) {

        autorizadorNivel3 = "";
        //debugger;

        autorizadorNivel3 = $("#AutorizadorNivel3").val();
    }

    if (autorizadorNivel3 !== "") {

        if (!validaAutorizador(autorizadorNivel3)) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Este autorizador ya está asignado a otro nivel.", "error");
            $("#AutorizadorNivel3").data("kendoDropDownList").value(0);
            $("#AutorizadorNivel3").data("kendoDropDownList").text("");
            autorizadorNivel3 = "";
        }
    }
}

function onChangeAutorizadorNivel4() {
    //debugger;

    if ($("#AutorizadorNivel4").data('kendoDropDownList').text().length > 0) {

        autorizadorNivel4 = "";
        //debugger;

        autorizadorNivel4 = $("#AutorizadorNivel4").val();
    }

    if (autorizadorNivel4 !== "") {

        if (!validaAutorizador(autorizadorNivel4)) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Este autorizador ya está asignado a otro nivel.", "error");
            $("#AutorizadorNivel4").data("kendoDropDownList").value(0);
            $("#AutorizadorNivel4").data("kendoDropDownList").text("");
            autorizadorNivel4 = "";
        }
    }

}

function onChangeAutorizadorNivel5() {
    //debugger;

    if ($("#AutorizadorNivel5").data('kendoDropDownList').text().length > 0) {

        autorizadorNivel5 = "";

        autorizadorNivel5 = $("#AutorizadorNivel5").val();
    }

    if (autorizadorNivel5 !== "") {

        if (!validaAutorizador(autorizadorNivel5)) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Este autorizador ya está asignado a otro nivel.", "error");
            $("#AutorizadorNivel5").data("kendoDropDownList").value(0);
            $("#AutorizadorNivel5").data("kendoDropDownList").text("");
            autorizadorNivel5 = "";
        }
    }
}

function onChangeAutorizadorNivel6() {
    //debugger;

    if ($("#AutorizadorNivel6").data('kendoDropDownList').text().length > 0) {

        autorizadorNivel6 = "";

        autorizadorNivel6 = $("#AutorizadorNivel6").val();
    }

    if (autorizadorNivel6 !== "") {

        if (!validaAutorizador(autorizadorNivel6)) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Este autorizador ya está asignado a otro nivel.", "error");
            $("#AutorizadorNivel6").data("kendoDropDownList").value(0);
            $("#AutorizadorNivel6").data("kendoDropDownList").text("");
            autorizadorNivel6 = "";
        }
    }
}

function onChangeAutorizadorNivel7() {
    //debugger;

    if ($("#AutorizadorNivel7").data('kendoDropDownList').text().length > 0) {

        autorizadorNivel7 = "";

        autorizadorNivel7 = $("#AutorizadorNivel7").val();
    }

    if (autorizadorNivel7 !== "") {

        if (!validaAutorizador(autorizadorNivel7)) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Este autorizador ya está asignado a otro nivel.", "error");
            $("#AutorizadorNivel7").data("kendoDropDownList").value(0);
            $("#AutorizadorNivel7").data("kendoDropDownList").text("");
            autorizadorNivel7 = "";
        }
    }
}

function onChangeAutorizadorNivel8() {
    //debugger;

    if ($("#AutorizadorNivel8").data('kendoDropDownList').text().length > 0) {

        autorizadorNivel8 = "";

        autorizadorNivel8 = $("#AutorizadorNivel8").val();
    }

    if (autorizadorNivel8 !== "") {

        if (!validaAutorizador(autorizadorNivel8)) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Este autorizador ya está asignado a otro nivel.", "error");
            $("#AutorizadorNivel8").data("kendoDropDownList").value(0);
            $("#AutorizadorNivel8").data("kendoDropDownList").text("");
            autorizadorNivel8 = "";
        }
    }
}

function onChangeAutorizadorNivel9() {
    //debugger;

    if ($("#AutorizadorNivel9").data('kendoDropDownList').text().length > 0) {

        autorizadorNivel9 = "";

        autorizadorNivel9 = $("#AutorizadorNivel9").val();
    }

    if (autorizadorNivel9 !== "") {

        if (!validaAutorizador(autorizadorNivel9)) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Este autorizador ya está asignado a otro nivel.", "error");
            $("#AutorizadorNivel9").data("kendoDropDownList").value(0);
            $("#AutorizadorNivel9").data("kendoDropDownList").text("");
            autorizadorNivel9 = "";
        }
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

function parametrosAutorizadores() {
    //var Empleado = $("#CCMSIDSolicitado").val();
    //var Concepto = $("#CCMSIDSolicitado").val();
    var Empleado = dataItem_Ident;
    var Concepto = dataItem_ConceptoId;

    if (Empleado == "") {
        Empleado = $("#CCMSIDSolicitado").val();
    }

    if (Concepto == "") {
        Concepto = $("#Conceptos").val();
    }

    return {
        EmpleadoIdent: Empleado,
        ConceptoId: Concepto
    };
}

function parametrosConceptos() {
    CCMSId = $("#CCMSIDSolicitado").val();
    var ValorCCMS = 0;

    if (CCMSId !== "") {
        ValorCCMS = CCMSId;
    }
    else
    {
        ValorCCMS = dataItem_Ident;
    }

    return {
        Ident: ValorCCMS,
    };
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

        //@Html.Label("lblPerfilNombre", ",", new { id = "lblPerfilNombre", style = "font-weight:normal" })
        //@Html.Label("lblAccesosNombre", ",", new { id = "lblAccesosNombre", style = "font-weight:normal" })

    })
        .fail(function (ex) {
            console.log("fail" + ex);
        });
}

function onCancel(e) {
    //kendoConsole.log("action :: Cancel");
    //console.log("cancel");
}

function onOK(e) {
    //kendoConsole.log("action :: OK");

    $.post(urlCancelaSolicitud + "?FolioSolicitud=" + FolioSolicitud, function (data) {
        //"&ConceptoId=" + ConceptoId + "@ParametroConceptoMonto=" + ParametroConceptoMonto                                      , int conceptoMotivoId, int responsableId, int periododOriginalId
        //debugger;

        if (data.res == -1) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Error al Cancelar Solicitud", "error");
        }

        //$("#FolioSolicitud").data("kendoNumericTextBox").value(data.FolioSolicitud);
        //actualizaGrid();
        //debugger;

        window.location.href = urlMisSolicitudes;

        //console.log("ok");
    });

    //window.location.href = urlMisSolicitudes;
}