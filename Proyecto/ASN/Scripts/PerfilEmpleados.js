﻿function resizeGrid() {
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
var editandoClientes = 0;
var editandoConceptos = 0;

function edit(e) {
    //var nombrePerfilEmpleados = $("#NombrePerfilEmpleados").data("kendoTextBox");
    var country = $("#Country_Ident").data("kendoDropDownList");
    var city = $("#City_Ident").data("kendoDropDownList");
    //var company = $("#Company_Ident").data("kendoDropDownList");
    var location = $("#Location_Ident").data("kendoDropDownList");
    //var client = $("#Client_Ident").data("kendoDropDownList");
    var MultiCliente = $("#Cliente").data("kendoMultiSelect");
    //var c = $("#Cliente").data("kendoMultiSelect");
    var program = $("#Program_Ident").data("kendoDropDownList");
    var contract_Type = $("#Contract_Type_Ident").data("kendoDropDownList");
    var tipoAccesoId = $("#TipoAccesoId").data("kendoDropDownList");
    //var conceptoId = $("#ConceptoId").data("kendoDropDownList");
    var MultiConcepto = $("#Concepto").data("kendoMultiSelect");
    //var f = $("#Concepto").data("kendoMultiSelect");
    
    if (e.model.isNew() === false) {

        $("#City_Ident").val(e.model.City_Ident).change();
        //debugger;
        //////////nombrePerfilEmpleados.enable(false);
        ////////country.enable(false);
        ////////city.enable(false);
        //////////company.enable(false);
        ////////location.enable(false);
        ////////client.enable(false);
        ////////program.enable(false);
        ////////contract_Type.enable(false);
        ////////tipoAccesoId.enable(false);
        //////////conceptoId.enable(false);
        //$("#ConceptoId").closest(".k-widget").hide();
        //MultiConcepto.enable(false);

        //if (e.model.ConceptoId === "-1") {
        //    conceptoId.select(0);
        //}

        var clientes = e.model.Client_Ident.split(',');
        editandoClientes = clientes;
        MultiCliente.value(clientes);

        var conceptos = e.model.ConceptoId.split(',');
        editandoConceptos = conceptos;
        MultiConcepto.value(conceptos);

        $("#Pais").attr("disabled", "disabled");
        //$("#MesId").attr("disabled", "disabled");
        e.container.kendoWindow("title", "Editar");

        editando = 1;
    }
    else {
        var valorDefault = "-1";

        //country.value(e.model.pais);
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
        //client.enable(false);
        MultiCliente.enable(false);
        program.enable(false);
        contract_Type.enable(false);
        //conceptoId.enable(false);
        //$("#ConceptoId").closest(".k-widget").hide();
        MultiConcepto.enable(false);

        $("#Active").attr("disabled", "disabled");
        e.container.kendoWindow("title", "Nuevo");

        editando = 0;
        editandoClientes = 0;
        editandoConceptos = 0;
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

function MultiClientes() {

    var multiselectCli = $("#Cliente").data("kendoMultiSelect");

    // get data items for the selected options.
    var dataItemsCli = multiselectCli.dataItems();

    var clientes = "";

    if (dataItemsCli.length > 0) {
        dataItemsCli.forEach(function (dataItem) {
            clientes += dataItem.Id + ",";
        });
    }

    //foreach(var dataIdent in dataItemsCli)
    //{ 
    //    clientes += dataIdent.Ident + ",";
    //}

    if (clientes.length > 1) {
        clientes = clientes.substring(0, clientes.length - 1);
    }

    return {
        client_Ident: clientes
    }; 
}

function MultiConceptos() {

    var multiselectCon = $("#Concepto").data("kendoMultiSelect");

    // get data items for the selected options.
    var dataItemsCon = multiselectCon.dataItems();

    var conceptos = "";

    if (dataItemsCon.length > 0) {
        dataItemsCon.forEach(function (dataItem) {
            conceptos += dataItem.Ident + ",";
        });
    }

    //foreach(var dataIdent in dataItemsCon)
    //{ 
    //    conceptos += dataIdent.Ident + ","; 
    //}

    if (conceptos.length > 1) {
        conceptos = conceptos.substring(0, conceptos.length - 1);
    }

    return {
        conceptoId: conceptos
    };
}

function MultiClientesMultiConceptos() {

    var multiselectCli = $("#Cliente").data("kendoMultiSelect");

    // get data items for the selected options.
    var dataItemsCli = multiselectCli.dataItems();

    var clientes = "";

    if (dataItemsCli.length > 0) {
        dataItemsCli.forEach(function (dataItem) {
            clientes += dataItem.Id + ",";
        });
    }

    //foreach(var dataIdent in dataItemsCli)
    //{ 
    //    clientes += dataIdent.Ident + ",";
    //}

    if (clientes.length > 1) {
        clientes = clientes.substring(0, clientes.length - 1);
    }

    if (clientes.length == 0) {
        clientes = "-1";
    }

    var multiselectCon = $("#Concepto").data("kendoMultiSelect");

    // get data items for the selected options.
    var dataItemsCon = multiselectCon.dataItems();

    var conceptos = "";

    if (dataItemsCon.length > 0) {
        dataItemsCon.forEach(function (dataItem) {
            conceptos += dataItem.Ident + ",";
        });
    }

    //foreach(var dataIdent in dataItemsCon)
    //{ 
    //    conceptos += dataIdent.Ident + ","; 
    //}

    if (conceptos.length > 1) {
        conceptos = conceptos.substring(0, conceptos.length - 1);
    }

    return {
        client_Ident: clientes, conceptoId: conceptos
    };
}

//function ObtieneMultiClientes() {
//    var multiselect = $("#Client_Ident").data("kendoMultiSelect");

//    // get data items for the selected options.
//    var dataItems = multiselect.dataItems();

//    var clientes = "";

//    if (dataItems.length > 0) {
//        dataItems.forEach(function (dataItem) {
//            clientes += dataItem.Ident + ",";
//        });
//    }

//    //foreach(var dataIdent in dataItems) 
//    //{ 
//    //    clientes += dataIdent.Ident + ",";
//    //}

//    if (clientes.length > 1) {
//        clientes = v.substring(0, clientes.length - 1);
//    }

//    //clientes = clientes.TrimEnd(',');

//    return {
//        Client_Ident: clientes
//    };
//}

//function ObtieneMultiConceptos() {
//    var multiselect = $("#Concepto").data("kendoMultiSelect");

//    // get data items for the selected options.
//    var dataItems = multiselect.dataItems();

//    var conceptos = "";

//    if (dataItems.length > 0) {
//        dataItems.forEach(function (dataItem) {
//            conceptos += dataItem.Ident + ",";
//        });
//    }

//        //foreach(var dataIdent in dataItems) 
//        //{ 
//        //    conceptos += dataIdent.Ident + ","; 
//        //}

//    if (conceptos.length > 1) {
//        conceptos = conceptos.substring(0, conceptos.length - 1);
//    }

//    //conceptos = conceptos.TrimEnd(',');

//    return {
//        ConceptoId: conceptos
//    };
//}

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
    //var cliente = $("#Client_Ident").data("kendoDropDownList");
    var Multicliente = $("#Clientes").data("kendoMultiSelect");
    var programa = $("#Program_Ident").data("kendoDropDownList");
    var contrato = $("#Contract_Type_Ident").data("kendoDropDownList");
    //var concepto = $("#ConceptoId").data("kendoDropDownList");
    var Multiconcepto = $("#Conceptos").data("kendoMultiSelect");

    //concepto.dataSource.read();
    //concepto.refresh();

    Multicliente.dataSource.read();
    Multicliente.refresh();
    Multicliente.value(editandoClientes);

    Multiconcepto.dataSource.read();
    Multiconcepto.refresh();
    Multiconcepto.value(editandoConceptos);

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
        
    ////////site.enable(false);
    site.value("-1");

    ////////cliente.enable(false);
    cliente.value("-1");

    ////////programa.enable(false);
    programa.value("-1");

    ////////contrato.enable(false);
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
    //var cliente = $("#Client_Ident").data("kendoDropDownList");
    var Multicliente = $("#Clientes").data("kendoMultiSelect");
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

    ////////cliente.enable(false);
    cliente.value("-1");

    ////////programa.enable(false);
    programa.value("-1");

    ////////contrato.enable(false);
    contrato.value("-1");

    site.enable(true);
    site.dataSource.read();
    site.refresh();
    site.value("-1");
}

function copiarPerfilEmpleados() {

    Perfil_Ident = "";
    NombrePerfilEmpleados = "";

    Perfil_Ident = $("#PerfilUsuarioId").val();
    NombrePerfilEmpleados = $("#NombrePerfilEmpleados").val();

    if (confirm("¿Desea copiar este pefil de empleado?")) {

        $.post(urlCopyPerfilEmpleados + "/?Perfil_Ident=" + Perfil_Ident + "&NombrePerfilEmpleados=" + NombrePerfilEmpleados + "&Estatus=" + 0, function (data) {
            //debugger;

            var notification = $("#popupNotification").data("kendoNotification");
            notification.show(data, "success");

            actualizaGrid();

            //grid.select("tr:eq(" + selectedRows(0) + ")");

        }).fail(function (ex) {
            console.log("fail" + ex);
        });
    }
}

function actualizaGrid() {
    $("#grid").data("kendoGrid").dataSource.read();
    $("#grid").data("kendoGrid").refresh();
}

function filterSite() {
    return {
        country: $("#Country_Ident").val(),
        city: $("#City_Ident").val(),
        //site: $("#Location_Ident").valMulticliente.enable(true)
        //client: $("#Client_Ident").val(),
        //program: $("#Program_Ident").val(),
        //contract: $("#Contract_Type_Ident").val()
    };
}

function CargaCliente() {
    var pais = $("#Country_Ident").data("kendoDropDownList");
    var ciudad = $("#City_Ident").data("kendoDropDownList");
    var site = $("#Location_Ident").data("kendoDropDownList");
    //var cliente = $("#Client_Ident").data("kendoDropDownList");
    var Multicliente = $("#Cliente").data("kendoMultiSelect");
    //var programa = $("#Program_Ident").data("kendoDropDownList");
    //var contrato = $("#Contract_Type_Ident").data("kendoDropDownList");
    
   
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
    ////////programa.enable(false);
    //programa.value("-1");

    ////////contrato.enable(false);
    //contrato.value("-1");

    //client.enable(true);
    //cliente.dataSource.read();
    //cliente.refresh();
    //cliente.value("-1");

    Multicliente.enable(true);
    //Multicliente.dataSource.read(filterClient());
    Multicliente.dataSource.read(filterClient());
    Multicliente.refresh();
    //Multicliente.value(-1)
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

function filterClient2() {
    return {
        country: $("#Country_Ident").val(),
        city: $("#City_Ident").val(),
        site: $("#Location_Ident").val(),
    };
}

function CargaPrograma() {
    var pais = $("#Country_Ident").data("kendoDropDownList");
    var ciudad = $("#City_Ident").data("kendoDropDownList");
    var site = $("#Location_Ident").data("kendoDropDownList");

    var programa = $("#Program_Ident").data("kendoDropDownList");
    var contrato = $("#Contract_Type_Ident").data("kendoDropDownList");
    //var concepto = $("#ConceptoId").data("kendoDropDownList");

    $("#Concepto").data("kendoMultiSelect").dataSource.read();
    $("#Concepto").data("kendoMultiSelect").enable(true);

    programa.enable(true);
    programa.dataSource.read(filterProgram());
    programa.refresh();
    //programa.value("-1");
}

function filterProgram(country, city, site, clientes) {
	
    return {
        country: country,
        city: city,
        site: site,
        client: clientes
    };
}

function CargaContrato() {    
    
    var pais = $("#Country_Ident").data("kendoDropDownList");
    var ciudad = $("#City_Ident").data("kendoDropDownList");
    var site = $("#Location_Ident").data("kendoDropDownList");
    //var cliente = $("#Client_Ident").data("kendoDropDownList");
    var Multicliente = $("#Cliente").data("kendoMultiSelect");
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

    //var Multiconcepto = $("#Concepto").data("kendoMultiSelect");
    //Multiconcepto.dataSource.read();
    //Multiconcepto.refresh();
    //if (contrato.value() == -1) {        
    //    contrato.value("-1");
    //}
    
}

function filterContract(clientes, programa) {
    return {
        country: $("#Country_Ident").val(),
        city: $("#City_Ident").val(),
        site: $("#Location_Ident").val(),
        client: clientes, //$("#Client_Ident").val(),
        program: programa,
        //contract: $("#Contract_Type_Ident").val()
    };
}

////////function filterConcepto(pais, clientes) {
////////    return {
////////        country: pais,
////////        client: clientes, //$("#Client_Ident").val(),
////////        program: programa,
////////    };
////////}

function CargaCascada() {

    var pais = $("#Country_Ident").data("kendoDropDownList");
    var ciudad = $("#City_Ident").data("kendoDropDownList");
    var site = $("#Location_Ident").data("kendoDropDownList");
    //var cliente = $("#Client_Ident").data("kendoDropDownList");
    var Multicliente = $("#Clientes").data("kendoMultiSelect");
    var programa = $("#Program_Ident").data("kendoDropDownList");
    var contrato = $("#Contract_Type_Ident").data("kendoDropDownList");
    //var concepto = $("#ConceptoId").data("kendoDropDownList");

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

function CargaPerfilEmpleado() {
    var pais = $("#Country_Ident").data("kendoDropDownList");
    var ciudad = $("#City_Ident").data("kendoDropDownList");
    var site = $("#Location_Ident").data("kendoDropDownList");
    //var cliente = $("#Client_Ident").data("kendoDropDownList");
    var Multicliente = $("#Clientes").data("kendoMultiSelect");
    var programa = $("#Program_Ident").data("kendoDropDownList");
    var contrato = $("#Contract_Type_Ident").data("kendoDropDownList");

}

function filterConcepto(pais, clientes) {
    return {
        country: pais,
        client: clientes
    };
}

function filterConcepto2() {
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
        //var cliente = $("#Client_Ident").data("kendoDropDownList");
        var MultiCliente = $("#Cliente").data("kendoMultiSelect");
        ////////////////MultiCliente.value(editandoClientes);
        //MultiCliente.value = editandoClientes;
        var programa = $("#Program_Ident").data("kendoDropDownList");
        var contrato = $("#Contract_Type_Ident").data("kendoDropDownList");
        //var concepto = $("#ConceptoId").data("kendoDropDownList");
        var MultiConcepto = $("#Concepto").data("kendoMultiSelect");
        ////////////////MultiConcepto.value(editandoConceptos);
        //MultiConcepto.value = editandoConceptos;

        ////////pais.enable(false);
        ////////ciudad.enable(false);
        ////////site.enable(false);
        ////////cliente.enable(false);
        ////////programa.enable(false);
        ////////contrato.enable(false);
        ////////MultiConcepto.enable(false);
        //concepto.enable(false);
        //$("#ConceptoId").closest(".k-widget").hide();
    }
}

function selectAllClientes(e) {
    //var multiselect = $("#Client_Ident").data("kendoMultiSelect");
    var multiselect = $("#Cliente").data("kendoMultiSelect");
    var selectedValues = [];

    if (e.dataItem.Id == -1) {
        for (var i = 0; i < multiselect.dataSource.data().length; i++) {
            var item = multiselect.dataSource.data()[i];
            var data = multiselect.dataSource.data();
            if (data[i].Ident > 0) {
                selectedValues.push(data[i].Ident);
            }
        }
    } else {
        selectedValues.push(e.dataItem.Id)
    }

    //multiselect.value(selectedValues);
    multiselect.close();
}

function selectCliente(e) {
    //var multiselect = $("#Client_Ident").data("kendoMultiSelect");
    var multiselect = $("#Cliente").data("kendoMultiSelect");
    var programa = $("#Program_Ident").data("kendoDropDownList");
    var multiConceptos = $("#Concepto").data("kendoMultiSelect"); 
    var selectedValues = $("#Cliente").data("kendoMultiSelect").value();
    //var selectedValues = [];

    var data = multiselect.dataSource.data();

    if (e.dataItem.Id == -1) {

        selectedValues = []

        for (var i = 0; i < multiselect.dataSource.data().length; i++) {
            var item = multiselect.dataSource.data()[i];
            if (item.Id > 0) {
                selectedValues.push(item.Id);
            }
        }
    }
    else {
        selectedValues.push(e.dataItem.Id)
    }

    ////////////multiselect.value(selectedValues);

    var texto = "";
    for (i = 0; i < selectedValues.length; i++) {
        texto += selectedValues[i] + ",";
    }

    if (texto.length > 1) {
        texto = texto.substring(0, texto.length - 1);
    }

    var country = $("#Country_Ident").val();
    var city = $("#City_Ident").val();
    var site = $("#Location_Ident").val();
    var clientes = texto; //selectedValues

    programa.enable(true);
    programa.dataSource.read(filterProgram(country, city, site, clientes));
    programa.refresh();
    //programa.value("-1");

    multiConceptos.enable(true);
    multiConceptos.dataSource.read(filterConcepto(country, clientes));
    multiConceptos.refresh();
}

function selectPrograma(e) {
    //var multiselect = $("#Client_Ident").data("kendoMultiSelect");
    var multiselect = $("#Cliente").data("kendoMultiSelect");
    var programa = e.dataItem.Id
    var contrato = $("#Contract_Type_Ident").data("kendoDropDownList");
    var selectedValues = multiselect.value();

    var clientes = "";
    for (i = 0; i < selectedValues.length; i++) {
        clientes += selectedValues[i] + ",";
    }

    if (clientes.length > 1) {
        clientes = clientes.substring(0, clientes.length - 1);
    }

    //var program = programa.value();

    contrato.enable(true);
    contrato.dataSource.read(filterContract(clientes, programa));
    contrato.refresh();
    //programa.value("-1");
}

function selectConcepto(e) {
    //var multiselect = $("#Client_Ident").data("kendoMultiSelect");
    var multiselect = $("#Cliente").data("kendoMultiSelect");
    var programa = e.dataItem.Id
    var concepto = $("#Contract_Type_Ident").data("kendoDropDownList");
    var selectedValues = multiselect.value();

    var clientes = "";
    for (i = 0; i < selectedValues.length; i++) {
        clientes += selectedValues[i] + ",";
    }

    if (clientes.length > 1) {
        clientes = clientes.substring(0, clientes.length - 1);
    }

    //var program = programa.value();

    concepto.enable(true);
    concepto.dataSource.read(filterContract(clientes, programa));
    concepto.refresh();
    //programa.value("-1");
}

function selectAllConceptos() {
    var multiSelect = $("#Concepto").data("kendoMultiSelect");
    var selectedValues = [];

    if (editandoConceptos == 0 && multiSelect.value().indexOf(-1) > -1) {
        for (var i = 0; i < multiSelect.dataSource.data().length; i++) {
            var item = multiSelect.dataSource.data()[i];
            var data = multiSelect.dataSource.data();
            if (data[i].Ident > 0) {
                selectedValues.push(data[i].Ident);
            }
        }
        multiSelect.value(selectedValues);
        multiSelect.close();
    }
}

function selectContrato(e) {
    //var multiselect = $("#Client_Ident").data("kendoMultiSelect");
    var multiselect = $("#Contract_Type_Ident").data("kendoMultiSelect");    
    var multiConceptos = $("#Concepto").data("kendoMultiSelect");
    var selectedValues = $("#Contract_Type_Ident").data("kendoMultiSelect").value();
    //var selectedValues = [];

    var data = multiselect.dataSource.data();

    if (e.dataItem.Id == -1) {

        selectedValues = []

        for (var i = 0; i < multiselect.dataSource.data().length; i++) {
            var item = multiselect.dataSource.data()[i];
            if (item.Id > 0) {
                selectedValues.push(item.Id);
            }
        }
    }
    else {
        selectedValues.push(e.dataItem.Id)
    }

    ////////////multiselect.value(selectedValues);

    var texto = "";
    for (i = 0; i < selectedValues.length; i++) {
        texto += selectedValues[i] + ",";
    }

    if (texto.length > 1) {
        texto = texto.substring(0, texto.length - 1);
    }

    var country = $("#Country_Ident").val();   
    var clientes = texto; //selectedValues

    //multiConceptos.enable(true);
    //multiConceptos.dataSource.read(filterConcepto(country, clientes));
    //multiConceptos.refresh();
}


//function selectAllContratos(e) {
//    //var multiselect = $("#Client_Ident").data("kendoMultiSelect");
//    var multiselect = $("#Contract_Type_Ident").data("kendoMultiSelect");
//    var selectedValues = [];

//    if (e.dataItem.Id == -1) {
//        for (var i = 0; i < multiselect.dataSource.data().length; i++) {
//            var item = multiselect.dataSource.data()[i];
//            var data = multiselect.dataSource.data();
//            if (data[i].Ident > 0) {
//                selectedValues.push(data[i].Ident);
//            }
//        }
//    } else {
//        selectedValues.push(e.dataItem.Id)
//    }

//    //multiselect.value(selectedValues);
//    multiselect.close();
//}