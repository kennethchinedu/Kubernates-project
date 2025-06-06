import { SITELINKS } from "@/constants";
import routes from "@/navigation/routes";
import useSideBarStore from "@/store/sidebarStore";
import useAuthStore from "@/store/userStore";
import { NavLink } from "react-router-dom";

type SideBarProps = {};
const LINKS = SITELINKS.concat([
  {
    link: routes.ABOUT,
    text: "about",
  },
]);

const DEFAULT_NAV_STYLES =
  "px-6 capitalize py-4 font-medium hover:bg-[rgba(0,0,0,0.2)]";
const SideBar: React.FC<SideBarProps> = ({}) => {
  const isOpen = useSideBarStore((state) => state.isOpen);
  const username = useAuthStore((state) => state.user?.username);
  return (
    <aside>
      <nav
        className={`fixed -left-[220px] top-[70px] z-[300] flex h-[calc(100svh-70px)] w-[220px] ${isOpen && "!left-0"} flex-col bg-primaryColor py-6 lg:hidden`}
        style={{
          transition: "left 0.2s",
        }}
      >
        {LINKS.map(({ text, link }) => (
          <NavLink
            to={
              username && link === routes.MYRECIPE
                ? link.replace(":u", username)
                : link
            }
            key={link + text}
            className={({ isActive }) =>
              isActive
                ? `${DEFAULT_NAV_STYLES} bg-black font-bold text-white`
                : `${DEFAULT_NAV_STYLES}`
            }
          >
            {text}
          </NavLink>
        ))}
      </nav>
    </aside>
  );
};

export default SideBar;
