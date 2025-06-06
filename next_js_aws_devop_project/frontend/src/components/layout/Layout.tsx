import useEnhancedCustomRouterUtilities from "@/navigation/useEnhancedCustomRouterUtilities";
import React from "react";
import { Outlet } from "react-router-dom";
import Header from "./Header";
import SideBar from "./SideBar";

const Layout: React.FC = () => {
  useEnhancedCustomRouterUtilities();
  return (
    <>
      <Header />
      <SideBar />

      <main className="w-full px-4 pt-[68px] lg:container md:px-8 lg:mx-auto lg:pt-0 xl:px-16">
        <Outlet />
      </main>
    </>
  );
};

export default Layout;
