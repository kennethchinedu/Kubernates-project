import { Response } from "./response";

export class ErrorResponse extends Error {
  private response: Response<null>;

  constructor(
    message: any,
    public statusCode: number,
    public error: any = message
  ) {
    super(message);
    // this.name = "ErrorResponse"; // Optional
    this.response = new Response(message, statusCode, null);
  }

  dump() {
    return this.response.dump();
  }
}
