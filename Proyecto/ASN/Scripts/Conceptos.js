

function edit(e) {

    var validator = e.container.data('kendoValidator');

    $('input[name="Descripcion"]').blur(function () {
        validator.validateInput(this);
    });

    $('input[name="TipoConcepto"]').change(function () {
        validator.validateInput(this);
    });
    
    if (e.model.isNew() === false) {

        var lstCountryIdents = $("#Paises").data("kendoMultiSelect");
        var paises = e.model.Paises.split(',');
        lstCountryIdents.value(paises);

        if (e.model.FechaInicio !== null) {
            var fInicio = formatDate(e.model.FechaInicio);
            $("#FechaInicio").val(fInicio);
            $("#FechaFin").val(formatDate(e.model.FechaFin));
        }

        $("#Vigencia").val(e.model.Vigencia);
        $("#PeriodicidadNominaId").val(e.model.PeriodicidadNominaId);
        var periodicidad = $("#PeriodicidadNominaId").data("kendoDropDownList");
        periodicidad.value(e.model.PeriodicidadNominaId);

        e.container.kendoWindow("title", "Editar");

        if (e.model.PagosFijos === true) {
            $("#PagosFijos").prop("checked", true);
            $("#PagosFijos input:checkbox").trigger("click");
            $("#PagosFijos").attr("checked", "checked");
            $("label[for=PagosFijos]").html("Sí");
            //$("#PagosFijos").click();
            AdministraControles();
        }
    }
    else {
        //$("#Active").attr("disabled", "disabled");
        $("label[for=PagosFijos]").html("No");
        e.container.kendoWindow("title", "Nuevo");
    }
}

function hola(e) {
    if (e.type === "create" || e.type === "update") {
        $('#grid').data('kendoGrid').dataSource.data([]);
        $('#grid').data('kendoGrid').dataSource.read();
        $('#grid').data('kendoGrid').refresh();

        if (e.response.Errors === null) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show(" Procesado correctamente", "success");
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

    debugger;
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
    debugger;

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
    debugger;
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
            customRule1: function (input, params) {
                if (input.is("[name=Descripcion]") && input.val().trim() === "") {
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

function formatDate(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;

    return [year, month, day].join('-');
}

function defaultValidate(e)
{
    if (typeof this.Descripcion) {
        var valor = $('input[name="Descripcion"]').val();
        if (valor !== undefined && valor.trim() !== "") {
            return true;
        } else {
            return false;
        }
    }
}

function MuestraMultiSelect() {
    if ($("#Vigencia").val() === "") {        
        $("#PeriodoNominaCnt").show();
        $("#PeriodoNomina").show();
    } else {        
        $("#PeriodoNomina").hide();
        $("#PeriodoNominaCnt").hide();
    }
    
}

function AdministraControles() {
    var valorSeleccionado = $("#PagosFijos").is(':checked');
    if (valorSeleccionado) {
        $("label[for=PagosFijos]").html("Sí");
        $(".cntHidden").show();
        $("#Tope").attr("required", "required");
        $("#PeriodicidadNominaId").attr("required", "required");
        $("#FechaInicio").attr("required", "required");
    } else {
        $("label[for=PagosFijos]").html("No");
        $("#Tope").removeAttr("required");
        $("#PeriodicidadNominaId").removeAttr("required");
        $("#FechaInicio").removeAttr("required");
        $(".cntHidden").hide();
    }
}

function fechasValor() {
    return {
    FechaInicio: $("#FechaInicio").val(),
        FechaFin: $("#FechaFin").val()
    };
}