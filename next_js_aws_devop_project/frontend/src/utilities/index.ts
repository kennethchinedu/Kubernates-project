import { create } from "apisauce";
import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export const api = create({
  baseURL: import.meta.env.VITE_APP_BACKEND_BASE_URL,
  headers: { Accept: "application/json" },
});

export const imageSrc = (src: string) => {
  return import.meta.env.VITE_APP_BACKEND_BASE_URL + "/images/" + src;
};
