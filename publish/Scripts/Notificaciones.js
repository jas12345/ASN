$(document).ready(function () {
    
});

function Notificaciones() {
    $("#NotificionesManualesBtn").attr("disabled", "disabled");

    kendo.ui.progress($("#loader"), true);

    $.ajax({
        type: "POST",
        url: urlNotificacionesSel,
        dataType: "json",
        success: function (response) {
            var notification = $("#popupNotification").data("kendoNotification");

            var elements = notification.getNotifications();

            // remove the two messages from the DOM
            elements.each(function () {
                $(this).parent().remove();
            });

            if (response.status == 0) {
                notification.show(" <b>Se enviaron correos a los Solicitantes y a los autorizadores que tienen solicitudes pendientes por autorizar.</b>", "success");
            }
            else if (response.status === "-1") {
                var errorMsg = response.mensaje;
                notification.show(errorMsg, "error");
            }

            $("#NotificionesManualesBtn").removeAttr("disabled");
            kendo.ui.progress($("#loader"), false);
        },
        error: function (response) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Ocurrio un problema durante el proceso. Intente de nuevo más tarde.", "error");
        }
    });
}