import { createWithEqualityFn } from "zustand/traditional";

type sideBarStoreI = {
  isOpen: boolean;
  toggle: () => void;
};

const useSideBarStore = createWithEqualityFn<sideBarStoreI>((set) => ({
  isOpen: false,
  toggle: () => {
    set((state) => ({ isOpen: !state.isOpen }));
  },
}));
export default useSideBarStore;
