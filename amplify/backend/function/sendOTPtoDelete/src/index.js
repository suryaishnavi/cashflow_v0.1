/* Amplify Params - DO NOT EDIT
    ENV
    REGION
Amplify Params - DO NOT EDIT */
const AWS = require("aws-sdk");
AWS.config.region = process.env.AWS_REGION;

const ses = new AWS.SES({ apiVersion: "2010-12-01" });
/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
exports.handler = async (event, context) => {
    // TODO implement - send OTP to delete account
    // Generate 6 digit OTP and send to user
    function generateOTP() {
        // Declare a digits variable
        // which stores all digits
        var digits = '0123456789';
        let OTP = '';
        for (let i = 0; i < 6; i++) {
            OTP += digits[Math.floor(Math.random() * 10)];
        }
        return OTP;
    }
    const username = event["identity"]["claims"]["name"];
    const emailTo = event["identity"]["claims"]["email"];
    const OTP = generateOTP();

    // send OTP to user email
    //     const eParams = {
    //         Destination: {
    //             ToAddresses: [emailTo]
    //         },
    //         Message: {
    //             Body: {
    //                 Text: {
    //                     Data: `Hello ${username},

    // We received a request to permanently delete data associated with your account in our system. To ensure this action is authorized by you, we have generated a One-Time Password (OTP) for verification purposes.

    // Please find your OTP below:

    // OTP: ${OTP}

    // Before you proceed, please be aware of the following:

    // **Warning: Data Deletion is Irreversible**

    // Once you confirm the deletion using this OTP, your data will be permanently removed from our system, and it cannot be restored. Please ensure that this is your intended action.

    // To proceed with the irreversible data deletion, enter this OTP in the app as prompted. Please keep this OTP confidential and do not share it with anyone.

    // If you did not initiate this data deletion request or have any concerns, please contact our support team immediately.

    // Thank you for using our service.

    // Best regards,
    // Cashflow App Team
    // `
    //                 }
    //             },
    //             Subject: {
    //                 Data: "OTP for deleting data from cashflow App"
    //             }
    //         },
    //         Source: "raisingstar72@gmail.com",
    //     };

    // await ses.sendEmail(eParams).promise();
    // return OTP;

    return {
        statusCode: 200,
        //  Uncomment below to enable CORS requests
        //  headers: {
        //      "Access-Control-Allow-Origin": "*",
        //      "Access-Control-Allow-Headers": "*"
        //  },
        body: JSON.stringify(OTP),
    };

}