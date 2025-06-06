import { createWithEqualityFn } from "zustand/traditional";

type userType = {
  username: string;
};

type authStore = {
  user: userType | null;
  is_authenticated: boolean;
  setAuthStore: (user: userType) => void;
  clear: () => void;
};

const useAuthStore = createWithEqualityFn<authStore>((set) => ({
  user: null,
  is_authenticated: false,
  clear: () => {
    set({ user: null, is_authenticated: false });
  },
  setAuthStore: (value) => {
    set(() => ({ user: value, is_authenticated: true }));
  },
}));
export default useAuthStore;
