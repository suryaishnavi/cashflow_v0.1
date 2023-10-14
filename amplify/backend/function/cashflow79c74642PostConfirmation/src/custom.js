const { Sha256 } = require("@aws-crypto/sha256-js");
const { defaultProvider } = require("@aws-sdk/credential-provider-node");
const { SignatureV4 } = require("@aws-sdk/signature-v4");
const { HttpRequest } = require("@aws-sdk/protocol-http");
const { default: fetch, Request } = require("node-fetch");

const GRAPHQL_ENDPOINT =
  "https://dm626u2fnve6lonhpmtzxkk2ju.appsync-api.ap-south-1.amazonaws.com/graphql";
const AWS_REGION = "ap-south-1";

const query = /* GraphQL */ `
  mutation CreateAppUser(
    $id: ID!
    $name: String!
    $owner: String!
    $email: AWSEmail!
    $phoneNumber: AWSPhone!
    $startDate: AWSDate!
    $endDate: AWSDate!
  ) {
    createAppUser(
      input: {
        id: $id
        name: $name
        owner: $owner
        emailId: $email
        phoneNumber: $phoneNumber
        appUserSubscriptionDetails: {
          startDate: $startDate
          endDate: $endDate
          isActive: true
          subscribed: false
        }
      }
    ) {
      id
    }
    createSubscriptionsDetails(
      input: {
        endDate: $endDate
        isActive: true
        startDate: $startDate
        appUser: $owner
      }
    ) {
      id
    }
  }
`;

/**
 *  @type {import('@types/aws-lambda').PostConfirmationTriggerHandler}
 */

exports.handler = async (event, context) => {
  console.log(`EVENT: ${JSON.stringify(event)}`);

  const today = new Date();
  const startDate = today.toISOString().split("T")[0];

  // Calculate the end date by adding 30 days to the start date
  const endDate = new Date(today.getTime() + 30 * 24 * 60 * 60 * 1000);
  const formattedEndDate = endDate.toISOString().split("T")[0];

  const variables = {
    id: event.request.userAttributes.sub,
    name: event.request.userAttributes.name,
    owner: `${event.request.userAttributes.sub}::${event.request.userAttributes.sub}`,
    email: event.request.userAttributes.email,
    phoneNumber: event.request.userAttributes.phone_number,
    startDate: startDate,
    endDate: formattedEndDate,
  };

  const endpoint = new URL(GRAPHQL_ENDPOINT);

  const signer = new SignatureV4({
    credentials: defaultProvider(),
    region: AWS_REGION,
    service: "appsync",
    sha256: Sha256,
  });

  const requestToBeSigned = new HttpRequest({
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      host: endpoint.host,
    },
    hostname: endpoint.host,
    body: JSON.stringify({ query, variables }),
    path: endpoint.pathname,
  });

  const signed = await signer.sign(requestToBeSigned);
  const request = new Request(endpoint, signed);

  let statusCode = 200;
  let body;
  let response;

  try {
    response = await fetch(request);
    body = await response.json();
    if (body.errors) statusCode = 400;
  } catch (error) {
    statusCode = 500;
    body = {
      errors: [
        {
          message: error.message,
        },
      ],
    };
  }

  console.log(`statusCode: ${statusCode}`);
  console.log(`body: ${JSON.stringify(body)}`);

  return {
    statusCode,
    body: JSON.stringify(body),
  };
};
