﻿var editando = 0;

function edit(e) {
    var validator = e.container.data('kendoValidator');
    var anio = $("#AnioId").data("kendoDropDownList");
    var mes = $("#MesId").data("kendoDropDownList");

    $('input[name="AnioId"]').change(function () {
        validator.validateInput(this);
    });

    if (e.model.isNew() === false) {
        debugger;
        anio.enable(false);
        mes.enable(false);
        editando = 1;
        
        $("#FechaInicio").val(e.model.FechaInicio);
        $("#FechaCierre").val(e.model.FechaCierre);

        e.container.kendoWindow("title", "Editar");
        debugger;
    }
    else {
        debugger;
        anio.enable(true);
        mes.enable(true);
        $("#Active").attr("disabled", "disabled");
        editando = 0;
        e.container.kendoWindow("title", "Nuevo");
        debugger;
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
    DelimitaFechaInicio();
    if ($("#FechaInicio").data("kendoDatePicker")._oldText.length == 0) {
        debugger;
        OcultaSave();
    }
    else {
        debugger;
        MuestraSave()
    }
}

function FechaCierreOpen(e) {
    DelimitaFechaCierre();
    if ($("#FechaCierre").data("kendoDatePicker")._oldText.length == 0) {
        debugger;
        OcultaSave();
    }
    else {
        debugger;
        MuestraSave()
    }
}

function DelimitaFechaInicio() {
    var fechaInicio = $("#FechaInicio").data("kendoDatePicker");

    var dtFInicioAnio = new Date($("#FechaInicioAnio").val() + " 00:00");
    var dtFCierreAnio = new Date($("#FechaCierreAnio").val() + " 00:00");

    debugger;

    //dtFInicio.setDate(dtFInicio.getDate());
    fechaInicio.setOptions({
        min: new Date(dtFInicioAnio),
        max: new Date(dtFCierreAnio)
    });
}

function DelimitaFechaCierre() {
    var fechaCierre = $("#FechaCierre").data("kendoDatePicker");

    var dtFInicioAnio = new Date($("#FechaInicioAnio").val() + " 00:00");
    var dtFCierreAnio = new Date($("#FechaCierreAnio").val() + " 00:00");

    debugger;

    //dtFFin.setDate(dtFFin.getDate());
    fechaCierre.setOptions({
        min: new Date(dtFInicioAnio),
        max: new Date(dtFCierreAnio)
    });
    //$("#FechaCierre").val($("#FechaInicio").val());
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
    if (editando === 1) {
        var AnioId = $("#AnioId").data("kendoDropDownList");
        debugger;
        AnioId.enable(false);
        rellenaFechasAnio();
    //} else {
    //    AnioId.enable(true);
    }
}

function Anio() {
    return {
        anioId: $("#AnioId").val()
    };
}


function rellenaFechasAnio() {
    var anioId = 0;
    debugger;

    anioId = $("#AnioId").val();

    if (anioId != 0) {
        $.post(urlFechasAnio + "/?anioId=" + anioId, function (data) {
            $("#FechaInicioAnio").val(data[0].FechaInicio);
            $("#FechaCierreAnio").val(data[0].FechaCierre);
            debugger;
            var FInicioAnio = $("#FechaInicio").data("kendoDatePicker");
            var FCierreAnio = $("#FechaCierre").data("kendoDatePicker");

            FInicioAnio.setOptions({
                max: data[0].FechaCierre,
                min: data[0].FechaInicio
            });

            FCierreAnio.setOptions({
                max: data[0].FechaCierre,
                min: data[0].FechaInicio
            });

            debugger;

            if (editando === 0) {
                var fechaInicio = $("#FechaInicio").data("kendoDatePicker");
                var fechaCierre = $("#FechaCierre").data("kendoDatePicker");
                fechaInicio.value(data[0].FechaInicio);
                fechaCierre.value(data[0].FechaCierre);
            }

        }).fail(function (ex) {
            console.log("fail" + ex);
        });
    }
}