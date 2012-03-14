var Slapme = {
  renderSlapImage: function(url){
    return '<img src="' + url + '">';
  },
  renderErrors: function(errors) {
    return '<p>' + errors.join('</p><p>') + '</p>';
  },
  handleSuccess: function(data){
    $('#errors').empty();
    $('#slap').html(Slapme.renderSlapImage(data.url));
  },
  handleError: function(error){
    $('#slap').empty();
    errors_elem = $('#errors')
    errors_elem.empty();
    if(error.status == 422) {
     errors = $.parseJSON(error.responseText)['errors'];
    } else {
     errors = ['An error occurred while trying to slap Robin!'];
    }
    errors_elem.append(Slapme.renderErrors(errors));
  },
  setupForm: function(){
    $('form').submit(function(e){
      e.preventDefault();

      form = $(this);
      submit = form.find('input[type=submit]');
      submit.attr('disabled','disabled');

      $.post(form.attr('action'), form.serialize())
       .success(function(data){
         Slapme.handleSuccess(data);
       })
       .error(function(error){
         Slapme.handleError(error);
       })
       .complete(function(){
         submit.removeAttr('disabled');
       });
    });
  }
};