﻿//(function ($, kendo) {

//    $.extend(true, kendo.ui.validator, {
//        rules: { // custom rules
//            customRule1: function (input, params) {
//                if (input.is("[name=NombrePeriodo]") && input.val().trim() === "") {
//                    return false;
//                }
//                return true;
//            },
//            productnamevalidation: function (input, params) {
//                return true;
//            }
//        },
//        messages: { //custom rules messages
//            customRule1: function (input) {

//                // return the message text
//                return input.attr("data-val-required");
//                //"Ingrese una descripción"
//            },
//            productnamevalidation: function (input) {
//                // return the message text
//                return input.attr("data-val-number");
//            }
//        }
//    });
//})(jQuery, kendo);

//$(document).ready(function () {
//    $("#ViewForm").bind("click", function () {
//        $("#window").data("kendoWindow").open();
//        $("#ViewForm").hide();
//    });
//});

//function GetSolicitudId() {
//    return {
//        SolicitudId: $("#idSolicitud").val()
//    };
//}

//function GetPerfil() {
//    return {
//        id: $("#idPerfil").val()
//    };
//}

//function GetParametros() {
//    return {
//        TTConceptoMotivoId: $("#TTConceptoMotivoId").is(':checked'),
//        TTManager_Ident: $("#TTManager_Ident").is(':checked'),
//        TTMonto: $("#TTMonto").is(':checked'),
//        TTDetalle: $("#TTDetalle").is(':checked'),
//        TTPeriodoNomina: $("#TTPeriodoNomina").is(':checked')
//    };
//}


//function valida(e) {
//    //debugger;
//    if (e.type === "create" || e.type === "update") {
//        $('#gridEmpleados').data('kendoGrid').dataSource.data([]);
//        $('#gridEmpleados').data('kendoGrid').dataSource.read();
//        $('#gridEmpleados').data('kendoGrid').refresh();

//        if (e.response.Errors === null) {
//            continuaAccion = true;
//            var notification = $("#popupNotification").data("kendoNotification");
//            notification.show("Guardado", "success");
//        }
//    }
//}

//function errorsote(args) {
//    //debugger;
//    if (args.errors) {

//        $(document).ready(function () {
//            var notification = $("#popupNotification").data("kendoNotification");
//            notification.show(args.errors.error.errors[0], "error");
//        });

//    }
//}

//function onSave(e) {
//    //debugger;
//    var hayCambios = false;
//    var sonNuevos = false;
//    jQuery.grep(e.sender._data, function (item) {

//        if (item.dirty || item.id <= 0) {
//            hayCambios = true;
//        }

//        if (item.id <= 0) {
//            sonNuevos = true;
//        }
//    });

//    if (hayCambios) {
//        if (sonNuevos) {
//            handleSaveChanges(e, this);
//        }
//        else {
//            handleEditChanges(e, this);
//        }
//    }
//}

//function handleEditChanges(e, grid) {
//    //debugger;
//    var valid = true;
//    var rows = grid.tbody.find("tr");
//    var objeto = jQuery.grep(grid._data, function (item) {
//        return item.dirty;
//    });

//    for (var i = 0; i < objeto.length; i++) {

//        var cols = $(rows[i]).find("td");
//        //var disposition = objeto[i].Disposition;
//        var displayname = objeto[i].Mercado;
//    }

//    if (!valid) {
//        e.preventDefault(true);
//        //setTimeout($.unblockUI, 1000);
//    }
//}

//function handleSaveChanges(e, grid) {

//    var valid = true;
//    var rows = grid.tbody.find("tr");
//    for (var i = 0; i < rows.length; i++) {

//        var model = grid.dataItem(rows[i]);

//        var cols = $(rows[i]).find("td");
//        var displaynameObj = $(cols[0]);
//        //var dispositionObj = $(cols[1]);

//        if (model && model.id <= 0 && valid) {

//            //nothing
//        }
//        else {
//            break;
//        }
//    }

//    if (!valid) {
//        e.preventDefault(true);
//        //setTimeout($.unblockUI, 1000);
//    }
//}


//function edit(e) {
//    //debugger;
//    var validator = e.container.data('kendoValidator');

//    //$('input[name="NombrePeriodo"]').blur(function () {
//    //    validator.validateInput(this);
//    //});

//    //$('input[name="TipoPeriodo"]').change(function () {
//    //    validator.validateInput(this);
//    //});

//    if (e.model.isNew() === false) {
//        e.container.kendoWindow("title", "Editar");
//    }
//    else {
//        e.container.kendoWindow("title", "Nuevo");
//    }
//}