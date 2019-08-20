$(document).ready(function () {

    $("#dale").bind("click", function () {
        $("#dale").prop('disabled', true);
        var regexp = /^[a-zA-Z0-9 áéíóúñ \n\-\?\.\,\¿\¡\!]+$/;
        var regexpEmpty = /^ *$/;
        var comentarista = $("#comentario").val();
        var tamanio = comentarista.length;
        var folioid = $("#IlusionDefinida").val();
        var eid = $("#IlusionDefinidaEID").val();
        var conid = $("#IlusionDefinidaConcept").val();
        var lblMsg = $("#labelWarning");
        var notification = parent.$("#popupNotificationCom").data("kendoNotification");
        var dialog = parent.$("#Comentarios").data("kendoWindow");

        if (regexp.test(comentarista) && !regexpEmpty.test(comentarista) && tamanio <= 150) {
            lblMsg.text("");
            //console.log(traRef);
            $.post(urlComGrab + '/?folioId=' + folioid + '&eid=' + eid + '&conceptoId=' + conid + '&comment=' + comentarista, function (data) {
                if (data == 1) {
                    notification.show("Comentario enviado", "success");
                    $("#popupNotification").attr("onclick", "sendItem();");
                    dialog.close();
                }
                else if (data == 2) {
                    notification.show("Solo se aceptan letras con y sin acentos, números y los caracteres .,-¿?¡!.", "error");
                    $("#popupNotification").attr("onclick", "sendItem();");
                    dialog.close();
                }
                else {
                    notification.show("Ocurrio un error y no se pudo mandar el comentario.", "error");
                    $("#popupNotification").attr("onclick", "sendItem();");
                    dialog.close();
                }

                $("#dale").prop('disabled', false);
            });
        }
        else {
            lblMsg.text('Solo se aceptan letras con y sin acentos, números y los caracteres .,-? y maximo 150 caracteres.');
            $("#dale").prop('disabled', false);
        }
    });
});
