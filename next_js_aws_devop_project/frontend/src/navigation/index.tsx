import AppErrorBoundary from "@/components/errorComponents/AppErrorBoundary";
import Layout from "@/components/layout/Layout";
import WelcomeLoader from "@/components/loaders/WelcomeLoader";
import EditPage from "@/pages/EditPage";
import PageNotFound from "@/pages/PageNotFound";
import { lazy } from "react";
import {
  createBrowserRouter,
  RouteObject,
  RouterProvider,
} from "react-router-dom";
import routes from "./routes";

type ExtendedRouteObject = RouteObject & {
  protected?: boolean;
  anonymousOnly?: boolean;
};

const CreateRecipe = lazy(() => import("@/pages/CreateRecipe"));
const HomePage = lazy(() => import("@/pages/HomePage"));
const RecipeDetails = lazy(() => import("@/pages/RecipeDetails"));
const MyRecipe = lazy(() => import("@/pages/MyRecipe"));

const protectedRoutes: ExtendedRouteObject[] = [
  {
    path: "/",
    hasErrorBoundary: true,
    element: <Layout />,
    errorElement: <AppErrorBoundary />,
    protected: true,
    children: [
      {
        path: routes.CREATE,
        element: <CreateRecipe />,
      },
      {
        path: routes.MYRECIPE,
        element: <MyRecipe />,
      },
      {
        path: routes.EDIT,
        element: <EditPage />,
      },
    ],
  },
];

const unAuthenticatedOnlyRoute: ExtendedRouteObject[] = [
  // {
  //   path: routes.LOGIN,
  //   element: <Login />,
  //   anonymousOnly: true,
  //   // errorElement: <ErrorBoundary />,
  // },
  // {
  //   path: routes.REGISTER_PAGE,
  //   element: <Signup />,
  //   anonymousOnly: true,
  //   // errorElement: <ErrorBoundary />,
  // },
];

const unProtectedRoute: ExtendedRouteObject[] = [
  {
    path: "/",
    hasErrorBoundary: true,
    element: <Layout />,
    errorElement: <AppErrorBoundary />,
    children: [
      {
        path: routes.HOME_PAGE,
        element: <HomePage />,
      },
      {
        path: routes.RECIPE,
        element: <RecipeDetails />,
      },
    ],
  },
];

const allRoutes: ExtendedRouteObject[] = [
  ...unProtectedRoute,
  ...unAuthenticatedOnlyRoute,
  ...protectedRoutes,
  {
    path: "*",

    element: <Layout />,
    children: [
      {
        path: "*",
        index: true,
        element: <PageNotFound />,
      },
    ],
  },
];

const appRoutes = allRoutes.map((route) => {
  // if (route?.protected && route?.element) {
  //   route.element = (
  //     <AuthGuard route={route} component={route.element as ReactElement} />
  //   );
  // } else if (route?.anonymousOnly) {
  // }

  return route;
});

const router = createBrowserRouter(appRoutes);
export default function AppRouter() {
  return (
    <>
      <RouterProvider router={router} fallbackElement={<WelcomeLoader />} />
    </>
  );
}
