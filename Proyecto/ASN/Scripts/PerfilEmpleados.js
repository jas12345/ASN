function edit(e) {
    //var nombrePerfilEmpleados = $("#NombrePerfilEmpleados").data("kendoTextBox");
    var country = $("#Country_Ident").data("kendoDropDownList");
    var city = $("#City_Ident").data("kendoDropDownList");
    //var company = $("#Company_Ident").data("kendoDropDownList");
    var location = $("#Location_Ident").data("kendoDropDownList");
    var client = $("#Client_Ident").data("kendoDropDownList");
    var program = $("#Program_Ident").data("kendoDropDownList");
    var contract_Type = $("#Contract_Type_Ident").data("kendoDropDownList");
    var tipoAccesoId = $("#TipoAccesoId").data("kendoDropDownList");
    var conceptoId = $("#ConceptoId").data("kendoDropDownList");

    
    if (e.model.isNew() === false) {

        $("#City_Ident").val(e.model.City_Ident).change();
        //debugger;
        //nombrePerfilEmpleados.enable(false);
        country.enable(false);
        city.enable(false);
        //company.enable(false);
        location.enable(false);
        client.enable(false);
        program.enable(false);
        contract_Type.enable(false);
        tipoAccesoId.enable(false);
        conceptoId.enable(false);

        if (e.model.ConceptoId === "-1") {
            conceptoId.select(0);
        }
        
        $("#Pais").attr("disabled", "disabled");
        //$("#MesId").attr("disabled", "disabled");
        e.container.kendoWindow("title", "Editar");
    }
    else {
        var valorDefault = "-1";

        country.value(valorDefault);
        city.value(valorDefault);
        //company.value(valorDefault);
        location.value(valorDefault);
        client.value(valorDefault);
        program.value(valorDefault);
        contract_Type.value(valorDefault);

        //country.trigger("change");
        //city.trigger("change");
        //company.trigger("change");
        //location.trigger("change");
        //client.trigger("change");
        //program.trigger("change");
        //contract_Type.trigger("change");

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
            notification.show("Guardado", "success");
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
        }
        else {
            break;
        }
    }

    if (!valid) {
        e.preventDefault(true);
    }
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
}

function accionado() {
    return {
        fechaInicio: $("#FechaInicio").val(), fechaCierre: $("#FechaCierre").val()
    };
}



