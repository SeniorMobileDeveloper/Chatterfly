var Mailgun = require('mailgun');
Mailgun.initialize('sandbox6c94954c683b43d7b91e1881b3a15b23.mailgun.org', 'key-974a00bdfa6440533c51052d3e11ce0b');
Parse.Cloud.define("sendEmail", function(request, response) {
	var title = request.params.mail_title;
	var message = request.params.mail_message;
	var type = request.params.mail_type;
	var fromUser = request.params.mail_fromUser;
  Mailgun.sendEmail({
    to: " rockstar7star@hotmail.com",
    from: fromUser,
    subject: title,
    text: message
    
    }, {
    success: function(httpResponse) {
      console.log(httpResponse);
      response.success(fromUser + title);
    },
    error: function(httpResponse) {
      console.error(httpResponse);
      response.error("Uh oh, something went wrong");
    }
  });
});