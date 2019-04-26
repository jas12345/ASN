var editandoElemento = 0;
function edit(e) {
    if (e.model.isNew() === false) {
        $("#AnioId").attr("disabled", "disabled");
        e.container.kendoWindow("title", "Editar");
        editandoElemento = 1;
    }
    else {
        $("#Active").attr("disabled", "disabled");
        editandoElemento = 0;
        var fecha = new Date();
        $("#AnioId").val(fecha.getFullYear());

        e.container.kendoWindow("title", "Nuevo");

    }
}

function validaAccion(e) {
    if ((e.type === "create" || e.type === "update")) {
        $('#grid').data('kendoGrid').dataSource.data([]);
        $('#grid').data('kendoGrid').dataSource.read();
        $('#grid').data('kendoGrid').refresh();

        if (e.response.Errors === null) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Procesado correctamente", "success");
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
    var dtFFin = new Date($("#FechaInicio").val()+" 00:00");
    dtFFin.setDate(dtFFin.getDate());
    fechafin.setOptions({
        min: new Date(dtFFin)
    });
    $("#FechaCierre").val($("#FechaInicio").val());
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
            customRule1: function (input, params) {
                
                var fechaPasada = new Date();
                var fechaFutura = new Date();
                var anioFuturo = fechaFutura.getFullYear() + 5;
                var anioAnterior = fechaPasada.getFullYear() - 5;
                
                if (input.is("[name=AnioId]") && input.val().trim() === "" || (input.val().trim() < anioAnterior || input.val().trim() > anioFuturo)) {
                    $("input[name=AnioId]").attr("validationMessage", "La fecha no puede ser menor ó mayor a 5 años de la fecha actual");
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
                return input.attr("data-val-required");
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

function rellenaFechasAnio() {
    var anioId = 0;
    var mesId = 0;

    anioId = $("#AnioId").val();
    mesId = $("#MesId").val();

    if (anioId != 0 && mesId != 0) {
        $.post(urlFechasMes + "/?mesId=" + mesId + "&anioId=" + anioId, function (data) {
            $("#FechaInicioAnio").val(data[0].FechaInicio);
            $("#FechaCierreAnio").val(data[0].FechaCierre);

            var FInicio = $("#FechaInicio").data("kendoDatePicker");
            var FCierre = $("#FechaCierre").data("kendoDatePicker");

            FInicio.setOptions({
                max: data[0].FechaCierre,
                min: data[0].FechaInicio
            });

            FCierre.setOptions({
                max: data[0].FechaCierre,
                min: data[0].FechaInicio
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