$(document).ready(function () {

    jQuery.extend(jQuery.validator.messages, {
        required: "Este campo es requerido.",
        remote: "Please fix this field.",
        email: "Please enter a valid email address.",
        url: "Please enter a valid URL.",
        date: "Please enter a valid date.",
        dateISO: "Please enter a valid date (ISO).",
        number: "Please enter a valid number.",
        digits: "Please enter only digits.",
        creditcard: "Please enter a valid credit card number.",
        equalTo: "Please enter the same value again.",
        accept: "Please enter a value with a valid extension.",
        maxlength: jQuery.validator.format("M&aacuteximo {0} caracteres."),
        minlength: jQuery.validator.format("M&iacutenimo {0} caracteres."),
        rangelength: jQuery.validator.format("Please enter a value between {0} and {1} characters long."),
        range: jQuery.validator.format("Please enter a value between {0} and {1}."),
        max: jQuery.validator.format("Please enter a value less than or equal to {0}."),
        min: jQuery.validator.format("Please enter a value greater than or equal to {0}.")
    });

    //^[a-zA-Z]+(\.)\d{1,5}$
    ///^[a-z A-Z]+(\.)?\d*$/

    $.validator.addMethod("regx", function (value, element, regexpr) {
        return regexpr.test(value);
    }, "Usuario invalido.");

    $('#form1').validate({
        lang: 'es',
    rules: {
      username: {
        //minlength: 3,
        maxlength: 20,
        required: true,
        regx: /^[a-zA-Z]+(\.)\d{1,5}$/
      },
      password: {
        minlength: 5,
        required: true
      }
    },
    highlight: function(element) {
      $(element).closest('.form-group').removeClass('has-success').addClass('has-error')
      $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
    },
    unhighlight: function(element) {
      $(element).closest('.form-group').removeClass('has-error').addClass('has-success');
    }
  });

  $('#form1').formAnimation({ animatedClass: 'shake' });

  // $('#form1').on('invalid-form.validate', function(e) {
  //   $(this).addClass('animated jello');
  // });
  //
  // $('.submit input').click(function() {
  //   $('#form1.animated').removeClass('animated jello');
  // });
});
