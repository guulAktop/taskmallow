const functions = require('firebase-functions');
const admin = require("firebase-admin")
const nodemailer = require('nodemailer');

admin.initializeApp()

exports.sendVerificationCode = functions.https.onCall((data, context) => {

    const transporter = nodemailer.createTransport({
        service: 'hotmail',
        host: 'smtp-mail.outlook.com',
        port: 587,
        auth: {
            user: 'email@gmail.com',
            pass: 'password'
        },
        from: 'email@gmail.com',
    });

    const mailOptions = {
        from: 'Taskmallow <email@gmail.com>',
        to: data.to,
        subject: 'Taskmallow Verification Code',
        html: `
        <!DOCTYPE html>
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>Taskmallow Verification Code</title>
        <style type="text/css" rel="stylesheet" media="all">
            *:not(br):not(tr):not(html) {
            font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif;
            -webkit-box-sizing: border-box;
            box-sizing: border-box;
            }
            body {
            width: 100% !important;
            height: 100%;
            margin: 0;
            line-height: 1.4;
            background-color: #F5F7F9;
            color: #839197;
            -webkit-text-size-adjust: none;
            }
            a {
            color: #414EF9;
            }

            .email-wrapper {
            width: 100%;
            margin: 0;
            padding: 0;
            background-color: #F5F7F9;
            }
            .email-content {
            width: 100%;
            margin: 0;
            padding: 0;
            }

            .email-masthead {
            padding: 25px 0;
            text-align: center;
            }
            .email-masthead_logo {
            max-width: 400px;
            border: 0;
            }
            .email-masthead_name {
            font-size: 16px;
            font-weight: bold;
            color: #839197;
            text-decoration: none;
            text-shadow: 0 1px 0 white;
            }
            .email-body {
            width: 100%;
            margin: 0;
            padding: 0;
            border-top: 1px solid #E7EAEC;
            border-bottom: 1px solid #E7EAEC;
            background-color: #FFFFFF;
            }
            .email-body_inner {
            width: 570px;
            margin: 0 auto;
            padding: 0;
            }
            .email-footer {
            width: 570px;
            margin: 0 auto;
            padding: 0;
            text-align: center;
            }
            .email-footer p {
            color: #839197;
            }
            .body-action {
            width: 100%;
            margin: 30px auto;
            padding: 0;
            text-align: center;
            }
            .body-sub {
            margin-top: 25px;
            padding-top: 25px;
            border-top: 1px solid #E7EAEC;
            }
            .content-cell {
            padding: 35px;
            }
            .align-right {
            text-align: right;
            }
            h1 {
            margin-top: 0;
            color: #292E31;
            font-size: 19px;
            font-weight: bold;
            text-align: left;
            }
            h2 {
            margin-top: 0;
            color: #292E31;
            font-size: 16px;
            font-weight: bold;
            text-align: left;
            }
            h3 {
            margin-top: 0;
            color: #292E31;
            font-size: 14px;
            font-weight: bold;
            text-align: left;
            }
            p {
            margin-top: 0;
            color: #839197;
            font-size: 16px;
            line-height: 1.5em;
            text-align: left;
            }
            p.sub {
            font-size: 12px;
            }
            p.center {
            text-align: center;
            }

            @media only screen and (max-width: 600px) {
            .email-body_inner,
            .email-footer {
                width: 100% !important;
            }
            }
            @media only screen and (max-width: 500px) {
            .button {
                width: 100% !important;
            }
            }
        </style>
        </head>
        <body>
        <table class="email-wrapper" width="100%" cellpadding="0" cellspacing="0">
            <tr>
            <td align="center">
                <table class="email-content" width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="email-masthead">
                    <img src="https://firebasestorage.googleapis.com/v0/b/taskmallow-app.appspot.com/o/app_images%2Ftaskmallow_email.gif?alt=media&token=25c885ba-9abe-4b13-bb66-2107a6bc2057" alt="Taskmallow" style="width: 30%;">
                    </td>
                </tr>
                <tr>
                    <td class="email-body" width="100%">
                    <table class="email-body_inner" align="center" width="570" cellpadding="0" cellspacing="0">
                        <tr>
                            <td class="content-cell">
                                <p style="font-size: 14px;">Please enter the verification code below correctly in the required field in the app.</p>
                                <br>
                                <h2>Verification Code:</h2>
                                <br>
                                <center>
                                    <div style="display: inline-block">
                                        <p style="background-color: #0079ff; padding: 5px 20px; border-radius: 10px; color: #e6f2ff; font-size: 30px;">${data.code}</p>
                                    </div>
                                </center>
                            </td>
                        </tr>
                    </table>
                    </td>
                </tr>
                </table>
            </td>
            </tr>
        </table>
        </body>
        </html>
        `
    };


    return transporter.sendMail(mailOptions, (error, data) => {
        if (error) {
            return context.send(error.toString());
        }
        var data = JSON.stringify(data)
        return context.send(`Sent! ${data}`);
    });
});
