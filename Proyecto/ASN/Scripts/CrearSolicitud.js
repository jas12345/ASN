
function edit(e) {
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

        //var paises = e.model.CountryIdents.split(',');
        //lstCountryIdents.value(paises);

        $("#FechaInicio").val(e.model.FechaInicio);
        $("#FechaFin").val(e.model.FechaFin);
        $("#FechaCaptura").val(e.model.FechaCaptura);
        $("#FechaCierre").val(e.model.FechaCierre);

        nombrePeriodo = e.model.NombrePeriodo;

        editando = 1;
    }
    else {
        e.container.kendoWindow("title", "Nuevo");
        editando = 0;
    }
}


function valida(e) {
    if (e.type === "create" || e.type === "update") {
        $('#grid').data('kendoGrid').dataSource.data([]);
        $('#grid').data('kendoGrid').dataSource.read();
        $('#grid').data('kendoGrid').refresh();
        debugger;
        if (e.response.Errors === null) {
            continuaAccion = true;
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Saved", "success");
        }
    }
}

function errorsote(args) {
    debugger;
    if (args.errors) {

        $(document).ready(function () {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show(args.errors.error.errors[0], "error");
        });

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


function GetInformacionPerfil() {

    $(".infoPerfil").hide();
    //$("div#Formulario input#FechaSolicitud").removeAttr("disabled");
    //$("#Formulario #paisName").removeAttr("disabled");
    //$("#Formulario #siteName").removeAttr("disabled");
    //$("Formulario #clienteName").removeAttr("disabled");
    //$("#Formulario input#programaName").removeAttr("disabled");

    $.ajax({
        url: '/Solicitudes/GetPerfil?perfilId=' + $("#Perfil_Ident").val(),
        contentType: 'application/json; charset=utf-8',
        type: 'POST',
        dataType: 'JSON'
    })
        .success(function (result) {

            if (result !== "") {
                var pais = (result.City_Name == "-1" || result.City_Name === null ? "TODOS" : result.City_Name);
                var site = (result.Location_Name == "-1" || result.Location_Name === null ? "TODOS" : result.Location_Name);
                var cliente = (result.Client_Name === "-1" || result.Client_Name === null ? "TODOS" : result.Client_Name);
                var programa = (result.Program_Name === '-1' || result.Program_Name === null ? "TODOS" : result.Program_Name);


                $("#Formulario input#FechaSolicitud").val();
                $("#Formulario #paisName").val(pais);
                $("#Formulario #siteName").val(site);
                $("#Formulario #clienteName").val(cliente);
                $("#Formulario input#programaName").val(programa);

                $("#Formulario input#FechaSolicitud").attr("disabled", "disabled");
                $("#Formulario #paisName").attr("disabled", "disabled");
                $("#Formulario #siteName").attr("disabled", "disabled");
                $("#Formulario #clienteName").attr("disabled", "disabled");
                $("#Formulario input#programaName").attr("disabled", "disabled");

                $(".infoPerfil").show();
            } else {
                $(".infoPerfil").hide();
            }

        })
        .error(function (xhr, status) {
            alert(status);
        })
}

function SaveSolicitud() {
    var modelo = {
        FolioSolicitud: $("#FolioSolicitud").val(),
        Perfil_Ident: $("#Perfil_Ident").val(),
        PeriodoNominaMes_Id: $("#PeriodoNominaMes_Id").val(),
        ConceptoId: $("#ConceptoId").val(),
        MotivoId: $("#MotivoId").val(),
        Justficacion: $("#Justficacion").val()
    };

    var myWindow = $("#windowNotifica").data("kendoWindow");
    

    var formdata = new FormData($('#Formulario').get(0));
    debugger;
    $.ajax({
        type: "POST",
        url: '/Solicitudes/CreateSolicitud',
        data: formdata,
        dataType: "json",
        processData: false, 
        contentType: false,
        success: function (response) {
            debugger;
            //myWindow.close();
            var contenido = "";
            if (response.status === "0") {
                if (response.listaEmpleados !== null && response.listaEmpleados.length >0) {
                    contenido += "<table border='1'><tr><td>CCMS ID</td><td>Resultado Acción</td></tr>"
                    for (var i = 0; i < response.listaEmpleados.length; i++) {
                        contenido += "<tr><td>" + response.listaEmpleados[i].catEmployeeId + "</td><td>" + response.listaEmpleados[i].estatus.replace("-1_", "").replace("-2_","") + "</td></tr>";
                    }
                    contenido += "</table>";

                }
                $("#windowNotifica").html(contenido);

                myWindow.center().open();
                
                //window.location.href = response.url;
            }
            else {
                var notification = $("#popupNotification").data("kendoNotification");
                notification.show(response.responseError.Errors, "error");
            }
        }
    });

}

function OnSuccess(response) {
    debugger;
    //var message = "Person Id: " + response.PersonId;
    //message += "\nName: " + response.Name;
    //message += "\nGender: " + response.Gender;
    //message += "\nCity: " + response.City;
    alert("EXITOSO");
}

function OnFailure(response) {
    debugger;
    alert("Error occured.");
}