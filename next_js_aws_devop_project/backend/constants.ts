export const MAX_UPLOAD_SIZE = 1024 * 1024 * 5;
export const ACCEPTED_FILE_TYPES = ["image/png", "image/jpeg", "image/jpg"];
export const PAGE_SIZE = 10;

export const HTTP_STATUS_CODE = {
  200: {
    code: 200,
    name: "OK",
    meaning: "The request has succeeded.",
  },
  201: {
    code: 201,
    name: "Created",
    meaning:
      "The request has been fulfilled and has resulted in one or more new resources being created.",
  },
  204: {
    code: 204,
    meaning:
      "The server successfully processed the request and is not returning any content.",
  },
  400: {
    code: 400,
    name: "Bad Request",
    meaning:
      "The server cannot or will not process the request due to an apparent client error.",
  },
  401: {
    code: 401,
    name: "Unauthorized",
    meaning:
      "The request has not been applied because it lacks valid authentication credentials for the target resource.",
  },
  403: {
    code: 403,
    name: "Forbidden",
    meaning:
      "The server understood the request, but it is refusing to fulfill it.",
  },
  404: {
    code: 404,
    name: "Not Found",
    meaning: "The server cannot find the requested resource.",
  },
  405: {
    code: 405,
    name: "Method Not Allowed",
    meaning:
      "The method received in the request-line is known by the origin server but not supported by the target resource.",
  },
  500: {
    code: 500,
    name: "Internal Server Error",
    meaning:
      "The server encountered an unexpected condition that prevented it from fulfilling the request.",
  },
  503: {
    code: 503,
    name: "Service Unavailable",
    meaning:
      "The server is currently unable to handle the request due to temporary overloading or maintenance of the server.",
  },
};

export const HTTP_STATUS_CODES = {
  200: {
    code: 200,
    name: "OK",
    meaning: "The request has succeeded.",
  },
  201: {
    code: 201,
    name: "Created",
    meaning:
      "The request has been fulfilled and has resulted in one or more new resources being created.",
  },
  204: {
    code: 204,
    name: "No Content",
    meaning:
      "The server successfully processed the request and is not returning any content.",
  },
  400: {
    code: 400,
    name: "Bad Request",
    meaning:
      "The server cannot or will not process the request due to an apparent client error.",
  },
  401: {
    code: 401,
    name: "Unauthorized",
    meaning:
      "The request has not been applied because it lacks valid authentication credentials for the target resource.",
  },
  403: {
    code: 403,
    name: "Forbidden",
    meaning:
      "The server understood the request, but it is refusing to fulfill it.",
  },
  404: {
    code: 404,
    name: "Not Found",
    meaning: "The server cannot find the requested resource.",
  },
  405: {
    code: 405,
    name: "Method Not Allowed",
    meaning:
      "The method received in the request-line is known by the origin server but not supported by the target resource.",
  },
  500: {
    code: 500,
    name: "Internal Server Error",
    meaning:
      "The server encountered an unexpected condition that prevented it from fulfilling the request.",
  },
  503: {
    code: 503,
    name: "Service Unavailable",
    meaning:
      "The server is currently unable to handle the request due to temporary overloading or maintenance of the server.",
  },
};
