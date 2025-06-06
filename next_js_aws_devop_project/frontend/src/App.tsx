import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { Suspense } from "react";
import { Toaster } from "sonner";
import WelcomeLoader from "./components/loaders/WelcomeLoader";
import AppRouter from "./navigation";
import AppThemeProvider from "./theme/AppThemeProvider";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 180_000, //number in milliseconds equals to 5 minutes,
    },
  },
});

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <AppThemeProvider>
        <Suspense fallback={<WelcomeLoader />}>
          <AppRouter />
        </Suspense>
      </AppThemeProvider>
      <Toaster richColors position="top-right" theme="light" />
      {/* <AppModals /> */}
    </QueryClientProvider>
  );
}

export default App;
