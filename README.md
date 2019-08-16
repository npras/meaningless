# README

## Scratchpad
confirmation module.

Only confirmed user can login and do any action.

When user signs up, save it in `unconfirmed_email` col, and send email with a link with confirm token.
If the user clicks it, we find the user with this token. If we can find it, then we move the email from unconfirmed field.
