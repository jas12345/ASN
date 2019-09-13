function resizeGrid() {
    var gridElement = $("#grid"),
        dataArea = gridElement.find(".k-grid-content"),
        gridHeight = gridElement.innerHeight(),
        otherElements = gridElement.children().not(".k-grid-content"),
        otherElementsHeight = 0;
    otherElements.each(function () {
        otherElementsHeight += $(this).outerHeight();
    });
    dataArea.height(gridHeight - otherElementsHeight);
}

function resizeWrapper() {
    $("#parent").height(document.body.offsetHeight - 140);
}

$(window).resize(function () {
    resizeWrapper();
    resizeGrid();
});

$(document).ready(function () {
    $(window).trigger("resize");
});

function adjustDropDownWidth(e) {
    var listContainer = e.sender.list.closest(".k-list-container");
    listContainer.width(listContainer.width() + kendo.support.scrollbar());
}

var editando = 0;

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

        editando = 1;
    }
    else {
        var valorDefault = "-1";

        //country.value(valorDefault);
        //city.value(valorDefault);
        ////company.value(valorDefault);
        //location.value(valorDefault);
        //client.value(valorDefault);
        //program.value(valorDefault);
        //contract_Type.value(valorDefault);

        //country.trigger("change");
        //city.trigger("change");
        //company.trigger("change");
        //location.trigger("change");
        //client.trigger("change");
        //program.trigger("change");
        //contract_Type.trigger("change");

        city.enable(false);
        location.enable(false);
        client.enable(false);
        program.enable(false);
        contract_Type.enable(false);
        

        $("#Active").attr("disabled", "disabled");
        e.container.kendoWindow("title", "Nuevo");

        editando = 0;
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

//function onSave(e) {
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
//        //$.blockUI({ message: null });
//        if (sonNuevos) {
//            handleSaveChanges(e, this);
//        }
//        else {
//            handleEditChanges(e, this);
//        }
//    }
//}


//function handleEditChanges(e, grid) {
//    var valid = true;
//    var rows = grid.tbody.find("tr");
//    var objeto = jQuery.grep(grid._data, function (item) {
//        return (item.dirty);
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
//        }
//        else {
//            break;
//        }
//    }

//    if (!valid) {
//        e.preventDefault(true);
//    }
//}

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

function filterCountry() {
    return {
        country: $("#Country_Ident").val(),
        city: $("#City_Ident").val(),
        site: $("#Location_Ident").val(),
        client: $("#Client_Ident").val(),
        program: $("#Program_Ident").val(),
        contract: $("#Contract_Type_Ident").val()
    };
}

function CargaCiudad() {
    var pais = $("#Country_Ident").data("kendoDropDownList");
    var ciudad = $("#City_Ident").data("kendoDropDownList");
    var site = $("#Location_Ident").data("kendoDropDownList");
    var cliente = $("#Client_Ident").data("kendoDropDownList");
    var programa = $("#Program_Ident").data("kendoDropDownList");
    var contrato = $("#Contract_Type_Ident").data("kendoDropDownList");
    var concepto = $("#ConceptoId").data("kendoDropDownList");

    concepto.dataSource.read();
    concepto.refresh();

    //if (pais.value() == -1) {
    //    pais.dataSource.read();
    //    pais.refresh();
    //}

    //if (site.value() == -1) {
    //    site.dataSource.read();
    //    site.refresh();
    //}
    
    //if (cliente.value() == -1) {
    //    cliente.dataSource.read();
    //    cliente.refresh();
    //}

    //if (contrato.value() == -1) {
    //    contrato.dataSource.read();
    //    contrato.refresh();
    //}

    //if (programa.value() == -1) {
    //    programa.dataSource.read();
    //    programa.refresh();
    //}
        
    site.enable(false);
    site.value("-1");

    cliente.enable(false);
    cliente.value("-1");

    programa.enable(false);
    programa.value("-1");

    contrato.enable(false);
    contrato.value("-1");

    ciudad.enable(true);
    ciudad.dataSource.read();
    ciudad.refresh();
    ciudad.value("-1");

}

function filterCity() {
    return {
        country: $("#Country_Ident").val()
        //,city: $("#City_Ident").val(),
        //site: $("#Location_Ident").val(),
        //client: $("#Client_Ident").val(),
        //program: $("#Program_Ident").val(),
        //contract: $("#Contract_Type_Ident").val()
    };
}

function CargaSite() {
    var pais = $("#Country_Ident").data("kendoDropDownList");
    var ciudad = $("#City_Ident").data("kendoDropDownList");
    var site = $("#Location_Ident").data("kendoDropDownList");
    var cliente = $("#Client_Ident").data("kendoDropDownList");
    var programa = $("#Program_Ident").data("kendoDropDownList");
    var contrato = $("#Contract_Type_Ident").data("kendoDropDownList");
    
    //if (ciudad.value() == -1) {
    //    ciudad.dataSource.read();
    //    ciudad.refresh();
    //}

    //if (pais.value() == -1) {
    //    pais.dataSource.read();
    //    pais.refresh();
    //}

    
    //if (cliente.value() == -1) {
    //    cliente.dataSource.read();
    //    cliente.refresh();
    //}

    //if (contrato.value() == -1) {
    //    contrato.dataSource.read();
    //    contrato.refresh();
    //}

    //if (programa.value() == -1) {
    //    programa.dataSource.read();
    //    programa.refresh();
    //}    

    cliente.enable(false);
    cliente.value("-1");

    programa.enable(false);
    programa.value("-1");

    contrato.enable(false);
    contrato.value("-1");

    site.enable(true);
    site.dataSource.read();
    site.refresh();
    site.value("-1");
}

function filterSite() {
    return {
        country: $("#Country_Ident").val(),
        city: $("#City_Ident").val(),
        //site: $("#Location_Ident").val(),
        //client: $("#Client_Ident").val(),
        //program: $("#Program_Ident").val(),
        //contract: $("#Contract_Type_Ident").val()
    };
}

function CargaCliente() {
    var pais = $("#Country_Ident").data("kendoDropDownList");
    var ciudad = $("#City_Ident").data("kendoDropDownList");
    var site = $("#Location_Ident").data("kendoDropDownList");
    var cliente = $("#Client_Ident").data("kendoDropDownList");
    var programa = $("#Program_Ident").data("kendoDropDownList");
    var contrato = $("#Contract_Type_Ident").data("kendoDropDownList");
    
   
    //if (site.value() == -1) {
    //    site.dataSource.read();
    //    site.refresh();
    //}

    //if (ciudad.value() == -1) {
    //    ciudad.dataSource.read();
    //    ciudad.refresh();
    //}

    //if (pais.value() == -1) {
    //    pais.dataSource.read();
    //    pais.refresh();
    //}

    //if (contrato.value() == -1) {
    //    contrato.dataSource.read();
    //    contrato.refresh();
    //}

    //if (programa.value() == -1) {
    //    programa.dataSource.read();
    //    programa.refresh();
    //}
    programa.enable(false);
    programa.value("-1");

    contrato.enable(false);
    contrato.value("-1");

    cliente.enable(true);
    cliente.dataSource.read();
    cliente.refresh();
    cliente.value("-1");

}

function filterClient() {
    return {
        country: $("#Country_Ident").val(),
        city: $("#City_Ident").val(),
        site: $("#Location_Ident").val(),
        //client: $("#Client_Ident").val(),
        //program: $("#Program_Ident").val(),
        //contract: $("#Contract_Type_Ident").val()
    };
}

function CargaPrograma() {
    var pais = $("#Country_Ident").data("kendoDropDownList");
    var ciudad = $("#City_Ident").data("kendoDropDownList");
    var site = $("#Location_Ident").data("kendoDropDownList");
    var cliente = $("#Client_Ident").data("kendoDropDownList");
    var programa = $("#Program_Ident").data("kendoDropDownList");
    var contrato = $("#Contract_Type_Ident").data("kendoDropDownList");
    var concepto = $("#ConceptoId").data("kendoDropDownList");

    concepto.dataSource.read();
    concepto.refresh();

    //if (contrato.value() == -1) {
    //    contrato.dataSource.read();
    //    contrato.refresh();
    //}

    //if (cliente.value() == -1) {
    //    cliente.dataSource.read();
    //    cliente.refresh();
    //}

    //if (site.value() == -1) {
    //    site.dataSource.read();
    //    site.refresh();
    //}

    //if (ciudad.value() == -1) {
    //    ciudad.dataSource.read();
    //    ciudad.refresh();
    //}

    //if (pais.value() == -1) {
    //    pais.dataSource.read();
    //    pais.refresh();
    //}

    contrato.enable(false);
    contrato.value("-1");


    programa.enable(true);
    programa.dataSource.read();
    programa.refresh();
    programa.value("-1");
}

function filterProgram() {
    return {
        country: $("#Country_Ident").val(),
        city: $("#City_Ident").val(),
        site: $("#Location_Ident").val(),
        client: $("#Client_Ident").val(),
        //program: $("#Program_Ident").val(),
        //contract: $("#Contract_Type_Ident").val()
    };
}
function CargaContrato() {    
    
    var pais = $("#Country_Ident").data("kendoDropDownList");
    var ciudad = $("#City_Ident").data("kendoDropDownList");
    var site = $("#Location_Ident").data("kendoDropDownList");
    var cliente = $("#Client_Ident").data("kendoDropDownList");
    var programa = $("#Program_Ident").data("kendoDropDownList");
    var contrato = $("#Contract_Type_Ident").data("kendoDropDownList");

    //if (programa.value() == -1) {
    //    programa.dataSource.read();
    //    programa.refresh();
    //}

    //if (cliente.value() == -1) {
    //    cliente.dataSource.read();
    //    cliente.refresh();
    //}

    //if (site.value() == -1) {
    //    site.dataSource.read();
    //    site.refresh();
    //}

    //if (ciudad.value() == -1) {
    //    ciudad.dataSource.read();
    //    ciudad.refresh();
    //}

    //if (pais.value() == -1) {
    //    pais.dataSource.read();
    //    pais.refresh();
    //}

    contrato.enable(true);
    contrato.dataSource.read();
    contrato.refresh();
    contrato.value("-1");
    
    //if (contrato.value() == -1) {        
    //    contrato.value("-1");
    //}
    
}

function filterContract() {
    return {
        country: $("#Country_Ident").val(),
        city: $("#City_Ident").val(),
        site: $("#Location_Ident").val(),
        client: $("#Client_Ident").val(),
        program: $("#Program_Ident").val(),
        //contract: $("#Contract_Type_Ident").val()
    };
}

function CargaCascada() {

    var pais = $("#Country_Ident").data("kendoDropDownList");
    var ciudad = $("#City_Ident").data("kendoDropDownList");
    var site = $("#Location_Ident").data("kendoDropDownList");
    var cliente = $("#Client_Ident").data("kendoDropDownList");
    var programa = $("#Program_Ident").data("kendoDropDownList");
    var contrato = $("#Contract_Type_Ident").data("kendoDropDownList");

    //if (contrato.value() == -1) {
    //    contrato.dataSource.read();
    //    contrato.refresh();
    //}

    //if (programa.value() == -1) {
    //    programa.dataSource.read();
    //    programa.refresh();
    //}

    //if (cliente.value() == -1) {
    //    cliente.dataSource.read();
    //    cliente.refresh();
    //}

    //if (site.value() == -1) {
    //    site.dataSource.read();
    //    site.refresh();
    //}

    //if (ciudad.value() == -1) {
    //    ciudad.dataSource.read();
    //    ciudad.refresh();
    //}

    //if (pais.value() == -1) {
    //    pais.dataSource.read();
    //    pais.refresh();
    //}       
}

function filterConcepto() {
    return {
        country: $("#Country_Ident").val(),
        client: $("#Client_Ident").val()
    };
}

function validando() {
    if (editando === 1) {
        var pais = $("#Country_Ident").data("kendoDropDownList");
        var ciudad = $("#City_Ident").data("kendoDropDownList");
        var site = $("#Location_Ident").data("kendoDropDownList");
        var cliente = $("#Client_Ident").data("kendoDropDownList");
        var programa = $("#Program_Ident").data("kendoDropDownList");
        var contrato = $("#Contract_Type_Ident").data("kendoDropDownList");

        pais.enable(false);
        ciudad.enable(false);
        site.enable(false);
        cliente.enable(false);
        programa.enable(false);
        contrato.enable(false);
    }
}

