var editando = 0;

function edit(e) {
    var anios = $("#AnioId").data("kendoDropDownList");
    var meses = $("#MesId").data("kendoDropDownList");
    var tipoPerio = $("#PeriodicidadNominaId").data("kendoDropDownList");

    var validator = e.container.data('kendoValidator');

    $('input[name="AnioId"]').change(function () {
        validator.validateInput(this);
    });

    $('input[name="MesId"]').change(function () {
        validator.validateInput(this);
    });

    $('input[name="PeriodicidadNominaId"]').change(function () {
        validator.validateInput(this);
    });

    $('input[name="ConsecutivoId"]').change(function () {
        validator.validateInput(this);
    });

    if (e.model.isNew() === false) {
        anios.enable(false);
        meses.enable(false);
        tipoPerio.enable(false);

        editando = 1;

        $("#FechaInicio").attr("disabled", "disabled");
        $("#FechaCierre").attr("disabled", "disabled");
        $("#FechaInicioMes").attr("disabled", "disabled");
        $("#FechaCierreMes").attr("disabled", "disabled");
        e.container.kendoWindow("title", "Editar");
    }
    else {
        anios.enable(true);
        meses.enable(true);
        tipoPerio.enable(true);

        editando = 0;

        $("#FechaInicio").attr("disabled", "disabled");
        $("#FechaCierre").attr("disabled", "disabled");
        $("#FechaInicioMes").attr("disabled", "disabled");
        $("#FechaCierreMes").attr("disabled", "disabled");
        $("#Active").attr("disabled", "disabled");
        e.container.kendoWindow("title", "Nuevo");


        var fechaInicio = $("#FechaInicio").data("kendoDatePicker");
        var fechaCierre = $("#FechaCierre").data("kendoDatePicker");
        //datePicker.value("2019-03-01");
        fechaCierre.value(formatDate(new Date()));
        fechaInicio.value(formatDate(new Date()));
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

function hola(e) {
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
        return item.dirty;
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

function tipoPerio() {
    return {
        perid: $("#PeriodicidadNominaId").val()
    };
}

function fechasValor() {
    return {
        fechainicio: $("#FechaInicio").val(),
        fechacierre: $("#FechaCierre").val()
    };
}

function Anio() {
    return {
        anioId: $("#AnioId").val()
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

function rellenaFechasMes() {
    var anioId = 0;
    var mesId = 0;

    anioId = $("#AnioId").val();
    mesId = $("#MesId").val();

    if (anioId != 0 && mesId != 0) {
        $.post(urlFechasMes + "/?mesId=" + mesId + "&anioId=" + anioId, function (data) {
            //console.log(data);
            $("#FechaInicioMes").val(data[0].FechaInicio);
            $("#FechaCierreMes").val(data[0].FechaCierre);

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
                //datePicker.value("2019-03-01");
                fechaCierre.value(data[0].FechaCierre);
                fechaInicio.value(data[0].FechaInicio);
            }

        }).fail(function (ex) {
            console.log("fail" + ex);
        });
    }
}