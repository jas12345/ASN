var editor = 0;
var valorVigencia = "";
var valorPeriodicidad = "";
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
        debugger;
        if (e.model.PagosFijos === true) {
            debugger;
            $("#PagosFijos").prop("checked", true);
            $("#PagosFijos").val(true);
            $("#PagosFijos input:checkbox").trigger("click");
            $("#PagosFijos").attr("checked", "checked");
            $("#PagosFijos input:checkbox").trigger("click");
            $("#PagosFijosNo").prop("checked", false);
            $("#PagosFijosNo").val(false);
            $("#PagosFijosNo").attr("checked", "nothing");

            editor = 1;
            valorVigencia = e.model.Vigencia;
            valorPeriodicidad = e.model.PeriodicidadNominaId;
            AdministraControles();
            GetPeriodicidad();
        }
        else {
            debugger;
            $("#PagosFijosNo").prop("checked", true);
            $("#PagosFijosNo").val(true);
            $("#PagosFijosNo").attr("checked", "checked");
            $("#PagosFijosNo input:checkbox").trigger("click");
            $("#PagosFijos").prop("checked", false);
            $("#PagosFijos").val(false);
            $("#PagosFijos").attr("checked", "nothing");

            editor = 1;
            valorVigencia = e.model.Vigencia;
            valorPeriodicidad = e.model.PeriodicidadNominaId;
            AdministraControles();
            GetPeriodicidad();

        }

        var periodicidad = $("#PeriodicidadNominaId").data("kendoDropDownList");
        periodicidad.value(e.model.PeriodicidadNominaId);
        e.container.kendoWindow("title", "Editar");
    }
    else {
        editor = 0;
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
    if ($("#Vigencia").val() === "Periodo nomina") {        
        $("#PeriodoNominaCnt").show();
        $("#PeriodoNomina").show();
    } else {        
        $("#PeriodoNomina").hide();
        $("#PeriodoNominaCnt").hide();
    }
    
}

function AdministraControles() {
    debugger;
    var valorSeleccionado = $("#PagosFijos").is(':checked');
    if (valorSeleccionado) {
        debugger;

        $("#PagosFijos").prop("checked", true);
        $("#PagosFijos").val(true);
        $("#PagosFijos input:checkbox").trigger("click");
        

        $("#PagosFijosNo").prop("checked", false);
        $("#PagosFijosNo").val(false);
        $("#PagosFijosNo").attr("checked", "nothing");

        $(".cntHidden").show();
        $("#Tope").attr("required", "required");
        $("#PeriodicidadNominaId").attr("required", "required");
        $("#FechaInicio").attr("required", "required");
    } else {
        debugger;
        $("#PagosFijos").prop(("checked", false);
        $("#PagosFijos").val(false);
        $("#PagosFijos input:checkbox").trigger("click");

        $("#PagosFijosNo").prop("checked", true);
        $("#PagosFijosNo").val(true);
        $("#PagosFijosNo").attr("checked", "checked");

        $("#Tope").removeAttr("required");
        $("#PeriodicidadNominaId").removeAttr("required");
        $("#FechaInicio").removeAttr("required");
        $(".cntHidden").hide();
    }
}

//function AdministraControlesNo() {
//    debugger;
//    var valorSeleccionado = $("#PagosFijosNo").is(':checked');
//    if (valorSeleccionado) {
//        debugger;

//        $("#PagosFijosNo").prop("checked", true);
//        $("#PagosFijosNo").val(true);

//        $("#PagosFijos").prop("checked", false);
//        $("#PagosFijos").val(false);
//        $("#PagosFijos").attr("checked", "nothing");
//        $("#Tope").removeAttr("required");
//        $("#PeriodicidadNominaId").removeAttr("required");
//        $("#FechaInicio").removeAttr("required");
//        $(".cntHidden").hide();
//    }
//    else {
//        debugger;

//        $("#PagosFijosNo").prop("checked", false);
//        $("#PagosFijosNo").val(false);

//        $("#PagosFijos").prop("checked", true);
//        $("#PagosFijos").val(true);
//        $("#PagosFijos").attr("checked", "checked");
//        $(".cntHidden").show();
//        $("#Tope").attr("required", "required");
//        $("#PeriodicidadNominaId").attr("required", "required");
//        $("#FechaInicio").attr("required", "required");
//    }
//}

function fechasValor() {
    return {
    fechaInicio: $("#FechaInicio").val(),
        fechaFin: $("#FechaFin").val()
    };
}

function GetPeriodicidad() {
    $("#PeriodicidadNominaId").data("kendoDropDownList").dataSource.read();
    $("#Vigencia").data("kendoDropDownList").dataSource.read();    
}

function GetPaises() {
    var paises = "";
    if ($("#Paises").val() !==null & $("#Paises").val() !== "") {
        var paiseslst = $("#Paises").val();
        for (key = 0; key < paiseslst.length; key++) {
            
            paises += $("#Paises").val()[key]+",";
        }
        paises = paises.substr(0, paises.length-1);
    }

    return {
        pais: paises
    }
}

function GetVigencia() {
    return { periodicidad: $("#PeriodicidadNominaId").val() }
}

function ValidaPeriodicidad() {    
    if (editor == 1) {
        var vigencias = $("#Vigencia").data("kendoDropDownList");
        var periodicidad = $("#PeriodicidadNominaId").data("kendoDropDownList");
        vigencias.value(valorVigencia);
        //periodicidad.value(valorPeriodicidad);
    }
    else {

        var selector = $("#PeriodicidadNominaId").val();

        if (selector === "Q") {
            var dropdownlist = $("#Vigencia").data("kendoDropDownList");
            dropdownlist.value("");
        }

        $("#Vigencia").data("kendoDropDownList").dataSource.read();
    }
}