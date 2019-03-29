﻿
var editando = 0;
var lstCountry = 0;
var dtFechaInicio = "";
var dtFechaFinal = "";

function edit(e) {
    //debugger;
    var validator = e.container.data('kendoValidator');

    $('input[name="NombrePeriodo"]').blur(function () {
        validator.validateInput(this);
    });

    $('input[name="TipoPeriodo"]').change(function () {
        validator.validateInput(this);
    });

    var lstCountryIdents = $("#LstCountryIdents").data("kendoMultiSelect");

    $("#FechaCaptura").attr("readonly", true);
    $("#FechaCierre").attr("readonly", true);

    if (e.model.isNew() === false) {
        e.container.kendoWindow("title", "Editar");

        var paises = e.model.CountryIdents.split(',');
        lstCountryIdents.value(paises);

        $("#FechaInicio").val(e.model.FechaInicio);
        $("#FechaFin").val(e.model.FechaFin);
        $("#FechaCaptura").val(e.model.FechaCaptura);
        $("#FechaCierre").val(e.model.FechaCierre);

        var anios = $("#AnioId").data("kendoDropDownList");
        var Periodo = $("#PeriodicidadNominaId").data("kendoDropDownList");
        var tipoperiodo = $("#TipoPeriodo").data("kendoDropDownList");

        anios.enable(false);
        Periodo.enable(false);
        tipoperiodo.enable(false);
        
        editando = 1;
    }
    else {
        e.container.kendoWindow("title", "Nuevo");
    }

}

function valida(e) {
    if (e.type === "create" || e.type === "update") {
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
    debugger;
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
        if (sonNuevos) {
            handleSaveChanges(e, this);
        }
        else {
            handleEditChanges(e, this);
        }
    }
}


function handleEditChanges(e, grid) {
    debugger;
    var valid = true;
    var rows = grid.tbody.find("tr");
    var objeto = jQuery.grep(grid._data, function (item) {
        return item.dirty;
    });

    for (var i = 0; i < objeto.length; i++) {

        var cols = $(rows[i]).find("td");
        //var disposition = objeto[i].Disposition;
        var displayname = objeto[i].Mercado;
    }
    debugger;
    if (!valid) {
        e.preventDefault(true);
        //setTimeout($.unblockUI, 1000);
    }
}

function handleSaveChanges(e, grid) {
    debugger;
    var valid = true;
    var rows = grid.tbody.find("tr");
    for (var i = 0; i < rows.length; i++) {

        var model = grid.dataItem(rows[i]);

        var cols = $(rows[i]).find("td");
        var displaynameObj = $(cols[0]);
        //var dispositionObj = $(cols[1]);
        debugger;
        if (model && model.id <= 0 && valid) {

            //nothing
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


(function ($, kendo) {
    //var endDate = $("#FechaFin").data("kendoDatePicker");
    //var today = new Date();
    //today = new Date(today);
    //today.setDate(today.getDate() + 1);
    //endDate.Value(today);

    $.extend(true, kendo.ui.validator, {
        rules: { // custom rules
            customRule1: function (input, params) {
                if (input.is("[name=NombrePeriodo]") && input.val().trim() === "") {
                    return false;
                }
                return true;
            },
            productnamevalidation: function (input, params) {
                return true;
            }
        },
        messages: { //custom rules messages
            customRule1: function (input) {

                // return the message text
                return input.attr("data-val-required");
                //"Ingrese una descripción"
            },
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

function rellenaFechasMes() {
    var anioId = 0;
    var mesId = 0;

    anioId = $("#AnioId").val();
    mesId = $("#MesId").val();

    if (anioId != 0 && mesId != 0) {
        $.post(urlFechasMes + "/?mesId=" + mesId + "&anioId=" + anioId, function (data) {
            //console.log(data);
            $("#FechaInicio").val(data[0].FechaInicio);
            $("#FechaFin").val(data[0].FechaCierre);

            dtFechaInicio = data[0].FechaInicio;
            dtFechaFinal = data[0].FechaCierre;
            var FInicio = $("#FechaInicio").data("kendoDatePicker");
            var FFin = $("#FechaFin").data("kendoDatePicker");

            FInicio.setOptions({
                max: data[0].FechaCierre,
                min: data[0].FechaInicio
            });

            FFin.setOptions({
                max: data[0].FechaCierre,
                min: data[0].FechaInicio
            });

            if (editando === 0) {
                var fechaInicio = $("#FechaInicio").data("kendoDatePicker");
                var FechaFin = $("#FechaFin").data("kendoDatePicker");
                FechaFin.value(data[0].FechaCierre);
                fechaInicio.value(data[0].FechaInicio);

                validaRango();

            } else {
                var FCaptura = $("#FechaCaptura").data("kendoDateTimePicker");
                var FCierre = $("#FechaCierre").data("kendoDateTimePicker");

                var meses = $("#MesId").data("kendoDropDownList");
                var cnsecutivo = $("#ConsecutivoId").data("kendoDropDownList");

                meses.enable(false);
                cnsecutivo.enable(false);

                dtFInicio = new Date($("#FechaCaptura").val());
                dtFInicio.setDate(dtFInicio.getDate() + 1);

                FInicio.setOptions({
                    max: new Date(dtFechaFinal),
                    min: dtFInicio
                });
            }

        }).fail(function (ex) {
            console.log("fail" + ex);
        });
    }
}

function validando() {
    if (editando === 1) {
        var consecutivos = $("#ConsecutivoId").data("kendoDropDownList");
        var mesesId = $("#MesId").data("kendoDropDownList");
        consecutivos.enable(false);
        mesesId.enable(false);
    }
}

function validaRango() {
    debugger;
    var FInicio = $("#FechaCaptura").data("kendoDateTimePicker");
    var FFin = $("#FechaCierre").data("kendoDateTimePicker");

    var dtFInicio = "";

    if ($("#FechaCaptura").val() === "") {

        dtFInicio = new Date(dtFechaInicio);
        dtFInicio.setDate(dtFInicio.getDate() + 1);

        FInicio.setOptions({
            max: new Date(dtFechaFinal),
            min: dtFInicio
        });
    } 

    if ($("#FechaCaptura").val() !== "") {

        dtFInicio = new Date($("#FechaCaptura").val());
        dtFInicio.setDate(dtFInicio.getDate() + 1);

        FInicio.setOptions({
            max: new Date(dtFechaFinal),
            min: dtFInicio
        });

        //FFin.setOptions({
        //    max: new Date(dtFechaFinal),
        //    min: dtFInicio
        //});
    }

    if ($("#FechaCierre").val() === "" && $("#FechaCaptura").val() === "") {
        FFin.setOptions({
            max: new Date(dtFechaFinal),
            min: dtFInicio
        });
    }
}

function tipoPerio() {
    return {
        perid: $("#PeriodicidadNominaId").val()
    };
}

function Anio() {
    return {
        anioId: $("#AnioId").val()
    };
}

function onChangeCountry(e) {
    if ("kendoConsole" in window) {
        var dataItem = e.dataItem;
        // kendoConsole.log("event :: select (" + dataItem.Text + " : " + dataItem.Value + ")");
        $("#CountryIdents").val(dataItem.Value);
        alert(dataItem.Value);
    }

}

function fechasValor() {
    return {
        fechainicio: $("#FechaInicio").val(),
        fechaFin: $("#FechaFin").val(),
        fechaCaptura: $("#FechaCaptura").val(),
        fechaCierre: $("#FechaCierre").val()
    };
}

function formatDate(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;

    return [year, month, day].join('-');
}

function getName() {
    var anioVl = $("#AnioId").val();
    var mesVl = $("#MesId").val();
    var periodisidadVl = $("#PeriodicidadNominaId").val();
    var consecutivoVl = $("#ConsecutivoId").val();
    var tipoPeriodoVl = $("#TipoPeriodo").val();
    mesVl = mesVl >= 1 && mesVl < 10 ? ("0" + mesVl) : mesVl;
    var propuesto = anioVl + "_" + mesVl + "_" + periodisidadVl + "_" + consecutivoVl + "_" + tipoPeriodoVl;
    var nombrePeriodo = $("#NombrePeriodo").data("TextBox");

    $("#NombrePeriodo").val(propuesto).change();
}