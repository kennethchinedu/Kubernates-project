import { PAGE_SIZE } from "../../constants";
import { Response } from "./response";

type paginatedType<U> = {
  totalPages: number;
  currentPage: number;
  results: U[];
};

export class PaginatedResponse<T> {
  private response: Response<paginatedType<T>>;
  constructor(
    public message: string,
    public statusCode: number,
    public totalItems: number,
    public currentPage: number,
    public data: T[]
  ) {
    this.response = new Response(message, statusCode, {
      totalPages: Math.ceil(totalItems / PAGE_SIZE),
      currentPage,
      results: data,
    });
  }

  dump() {
    return this.response.dump();
  }

  public static getPaginationProps(page: number = 1) {
    return {
      skip: (page - 1) * PAGE_SIZE,
      take: page * PAGE_SIZE,
    };
  }
}
