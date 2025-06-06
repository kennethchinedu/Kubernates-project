export class Response<T> {
  constructor(
    public message: string,
    public statusCode: number,
    public data: T
  ) {}

  dump() {
    return {
      message: this.message,
      status: this.statusCode < 400 ? "success" : "error",
      data: this.data,
    };
  }
}
