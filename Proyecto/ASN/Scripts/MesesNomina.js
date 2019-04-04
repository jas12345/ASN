﻿var editando = 0;

function edit(e) {
    if (e.model.isNew() === false) {
        $("#AnioId").attr("disabled", "disabled");
        $("#MesId").attr("disabled", "disabled");

        var mes = $("#MesId").data("kendoDropDownList");
        mes.enable(false);
        e.container.kendoWindow("title", "Editar");
    }
    else {
        $("#AnioId").removeAttr("disabled");
        $("#MesId").removeAttr("disabled");
        $("#Active").attr("disabled", "disabled");
        e.container.kendoWindow("title", "Nuevo");

    }
}

function hola(e) {
    if ((e.type === "create" || e.type === "update")) {
        $('#grid').data('kendoGrid').dataSource.data([]);
        $('#grid').data('kendoGrid').dataSource.read();
        $('#grid').data('kendoGrid').refresh();

        if (e.response.Errors === null) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Saved", "success");
        }
    }
}

function errorsote(args) {

    if (args.errors) {

        $(document).ready(function () {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show(args.errors.error.errors[0], "error");
        });

    }
}

function onSave(e) {
    var hayCambios = false;
    var sonNuevos = false;
    jQuery.grep(e.sender._data, function (item) {

        if (item.dirty || item.id <= 0) {
            hayCambios = true;
        }

        if (item.id <= 0) {
            sonNuevos = true;
        }

    });

    if (hayCambios) {
        //$.blockUI({ message: null });
        if (sonNuevos) {
            handleSaveChanges(e, this);
        }
        else {
            handleEditChanges(e, this);
        }
    }
}


function handleEditChanges(e, grid) {
    var valid = true;
    var rows = grid.tbody.find("tr");
    var objeto = jQuery.grep(grid._data, function (item) {
        return (item.dirty);
    });

    for (var i = 0; i < objeto.length; i++) {

        var cols = $(rows[i]).find("td");
        //var disposition = objeto[i].Disposition;
        var displayname = objeto[i].Mercado;

    }

    if (!valid) {
        e.preventDefault(true);
        //setTimeout($.unblockUI, 1000);
    }
}

function handleSaveChanges(e, grid) {
    var valid = true;
    var rows = grid.tbody.find("tr");
    for (var i = 0; i < rows.length; i++) {

        var model = grid.dataItem(rows[i]);

        var cols = $(rows[i]).find("td");
        var displaynameObj = $(cols[0]);
        //var dispositionObj = $(cols[1]);

        if (model && model.id <= 0 && valid) {

            //if (dispositionObj.text() == "") {
            //    var notification = $("#popupNotification").data("kendoNotification");
            //    notification.show("Invalid disposition name", "error");
            //    grid.editCell(dispositionObj);
            //    e.preventDefault(true);
            //    valid = false;
            //    //setTimeout($.unblockUI, 1000);
            //    return false;
            //}

            //if (ValidaDisplayNameVal(displaynameObj.text()) != 0) {
            //    var notification = $("#popupNotification").data("kendoNotification");
            //    notification.show("Invalid disposition values", "error");
            //    grid.editCell(displaynameObj);
            //    e.preventDefault(true);
            //    valid = false;
            //    //setTimeout($.unblockUI, 1000);
            //    return false;
            //}

        }
        else {
            break;
        }
    }

    if (!valid) {
        e.preventDefault(true);
        //setTimeout($.unblockUI, 1000);
    }
}

function FechaInicioOpen(e) {
    DelimitaFechaFin();
    if ($("#FechaInicio").data("kendoDatePicker")._oldText.length == 0) {
        OcultaSave();
    }
    else {
        MuestraSave()
    }
}

function FechaCierreOpen(e) {
    DelimitaFechaInicio();
    if ($("#FechaCierre").data("kendoDatePicker")._oldText.length == 0) {
        OcultaSave();
    }
    else {
        MuestraSave()
    }
}

function DelimitaFechaInicio() {
    var fechaInicio = $("#FechaInicio").data("kendoDatePicker");
    var dtFInicio = new Date($("#FechaCierre").val() + " 00:00");
    dtFInicio.setDate(dtFInicio.getDate());
    fechaInicio.setOptions({
        max: new Date(dtFInicio)
    });
}

function DelimitaFechaFin() {
    var fechafin = $("#FechaCierre").data("kendoDatePicker");
    var dtFFin = new Date($("#FechaInicio").val() + " 00:00");
    dtFFin.setDate(dtFFin.getDate());
    fechafin.setOptions({
        min: new Date(dtFFin)
    });
    $("#FechaCierre").val($("#FechaInicio").val());
}

function AnioNominaChange(e) {
    $("#FechaInicioAnio").val
}

function OcultaSave() {
    $(".k-grid-update").css("display", "none");
}

function MuestraSave() {
    $(".k-grid-update").css("display", "");
}

(function ($, kendo) {
    $.extend(true, kendo.ui.validator, {
        rules: { // custom rules
            productnamevalidation: function (input, params) {

                return true;
            }
        },
        messages: { //custom rules messages
            productnamevalidation: function (input) {
                // return the message text
                return input.attr("data-val-number");
            }
        }
    });
})(jQuery, kendo);


function ValidaDisplayNameVal(obj) {
    //if (obj == "" || (obj.length > 150 || obj.length < 3) || obj.match(/^[a-z A-Z0-9 ñáéíóú\)\(]*$/) == null) {
    //    return "El nombre del Mercado debe ser entre 3 y 150 caracteres y solo se aceptan numeros,letras y parentesis.";
    //}
    //else {
    //    return 0;
    //}
}

function accionado() {
    return {
        fechaInicio: $("#FechaInicio").val(), fechaCierre: $("#FechaCierre").val()
    };
}

function dateFilter(e) {
    e.element.kendoDatePicker({
        format: "yyyy-MM-dd",
    });
}

function validandoCatMeses() {
    var AnioId = $("#AnioId").data("kendoDropDownList");
    if (editando === 1) {
        AnioId.enable(false);
    } else {
        AnioId.enable(true);
    }
}

function Anio() {
    return {
        anioId: $("#AnioId").val()
    };
}


function rellenaFechasAnio() {
    var anioId = 0;

    anioId = $("#AnioId").val();

    if (anioId != 0) {
        $.post(urlFechasAnio + "/?anioId=" + anioId, function (data) {
            $("#FechaInicioAnio").val(data[0].FechaInicio);
            $("#FechaCierreAnio").val(data[0].FechaCierre);

            var FInicio = $("#FechaInicio").data("kendoDatePicker");
            var FCierre = $("#FechaCierre").data("kendoDatePicker");

            FInicio.setOptions({
                max: new Date(data[0].FechaCierre + " 23:55"),
                min: new Date(data[0].FechaInicio + " 00:00")
            });

            FCierre.setOptions({
                max: new Date(data[0].FechaCierre + " 23:55"),
                min: new Date(data[0].FechaInicio+" 00:00")
            });

            if (editando === 0) {
                var fechaInicio = $("#FechaInicio").data("kendoDatePicker");
                var fechaCierre = $("#FechaCierre").data("kendoDatePicker");
                fechaCierre.value(data[0].FechaCierre);
                fechaInicio.value(data[0].FechaInicio);
            }

        }).fail(function (ex) {
            console.log("fail" + ex);
        });
    }
}