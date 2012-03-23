var Slapme = {
  renderSlapImage: function(url){
    var output = '<a href="' + url + '">' + '<img src="' + url + '"></a>';
    output += '<a class="image" href="' + url + '">' + url + '</a>';
    return output;
  },
  renderErrors: function(errors) {
    return '<p>&raquo; ' + errors.join('</p><p>&raquo; ') + '</p>';
  },
  handleSuccess: function(data){
    $('.errors').hide();
    $('.output').html(Slapme.renderSlapImage(data.url)).show().ScrollTo();
  },
  handleError: function(error){
    $('.output').hide();
    var errors_elem = $('.errors');
    errors_elem.empty();
    if(error.status == 422) {
     var errors = $.parseJSON(error.responseText)['errors'];
    } else {
     var errors = ['An error occurred while trying to slap Robin!'];
    }
    errors_elem.append(Slapme.renderErrors(errors));
    errors_elem.show();
  },
  setupForm: function(){
    $('form').submit(function(e){
      e.preventDefault();

      var form = $(this);
      var submit = form.find('input[type=submit]');
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