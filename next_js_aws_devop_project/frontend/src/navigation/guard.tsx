import { type ReactElement } from "react";
// import useAuthUser from "../hooks/useAuthUser";

interface AuthGuardProps {
  component: ReactElement;
  route: any;
}

// PS: This can be extended as we see fit
function AuthGuard({ component }: AuthGuardProps): ReactElement {
  // if (!is_authenticated) {
  //   //TODO:  add search params also if any exists
  //   return (
  //     <Navigate
  //       to={routes.LOGIN + (locationInfo?.search ? locationInfo.search : "")}
  //       state={locationInfo?.state}
  //       replace
  //     />
  //   );
  // }

  return component;
}

export default AuthGuard;
