import axios from "axios";

export const appAxios = axios.create({
  baseURL: import.meta.env.VITE_APP_BACKEND_BASE_URL,
});
