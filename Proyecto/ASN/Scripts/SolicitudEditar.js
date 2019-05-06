$(document).ready(function () {
    $("#CargaMasiva").change(function () {
        if ($(this).is(":checked")) {
            $("#seccionCargaMasiva").show();
        } else {
            var upload = $("#files2").data("kendoUpload");
            upload.clearAllFiles();
            upload.removeAllFiles();
            $("#seccionCargaMasiva").hide();
        }
    });
});

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

                $("#Formulario input#FechaSolicitud").val(formattedDate());
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

function SaveSolicitud(accion) {

    var validator = $("#Formulario").kendoValidator().data("kendoValidator"), status = $(".status");
    debugger;

    if ($("#FolioSolicitud").val() !== "0") {

        if (validator.validate()) {

            var myWindow = $("#windowNotifica").data("kendoWindow");
            kendo.ui.progress($(".chart-loading"), true);
            var formdata = new FormData($('#Formulario').get(0));
            var solicitud = 0;

            //$.ajax({ url: urlSolicitud, data: formdata, contentType: 'application/json; charset=utf-8', type: 'POST', dataType: 'JSON' }).success(function (response) {
            $.ajax({
                type: "POST",
                url: urlEdita,
                data: formdata,
                dataType: "json",
                processData: false,
                contentType: false,
                success: function (response) {
                    debugger;
                    myWindow.close();
                    var contenido = "";

                    kendo.ui.progress($(".chart-loading"), false);

                    if (response.status === "0") {

                        contenido += "<b>Se actualizo correctamente la solicitud.</b><br>";
                        solicitud = response.Id;
                        contenido += "<br /><div style='float:right;margin-right:5px;margin-top:15px;'><button type='button' class='k-button k-state-default' onclick='cierraModal();'>Cerrar</button><button type='button' class='k-button k-state-default' style='margin-left:5px;' onclick='cargaEmpleados(" + accion + "," + solicitud + "," + $("#Perfil_Ident").val() + ");'>Continuar</button></div>";
                        
                        $("#windowNotifica").html(contenido);
                        myWindow.center().open();
                    }
                    else {
                        var notification = $("#popupNotification").data("kendoNotification");
                        notification.show(response.responseError.Errors, "error");
                    }
                },
                failure: function (response) {
                    alert(response.responseText);
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
        }
    }

}

function OnSuccess(response) {
    debugger;
    alert("EXITOSO");
}

function OnFailure(response) {
    debugger;
    alert("Error occured.");
}

function cargaEmpleados(accion, solicitud, perfil) {
    if (accion === 1) {
        window.location.href = "/Solicitudes/Index";
    } else if (accion === 2) {
        window.location.href = urlSeleccionaPersonal + "?id=" + solicitud + "&perfil=" + perfil;
    }
}

function cierraModal() {
    var myWindow = $("#windowNotifica").data("kendoWindow");
    myWindow.close();
}

function displayLoading(target) {
    var element = $(target);
    kendo.ui.progress(element, true);
    setTimeout(function () {
        kendo.ui.progress(element, false);
    }, 2000);
}

function formattedDate(d = new Date) {
    return [d.getDate(), d.getMonth() + 1, d.getFullYear()]
        .map(n => n < 10 ? `0${n}` : `${n}`).join('-');
}