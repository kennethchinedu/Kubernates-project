import { SITELINKS } from "@/constants";
import routes from "@/navigation/routes";
import useSideBarStore from "@/store/sidebarStore";
import useAuthStore from "@/store/userStore";
import { IoMenuSharp } from "react-icons/io5";
import { Link, NavLink } from "react-router-dom";

type HeaderProps = {};

const DEFAULT_NAV_STYLES =
  "capitalize font-medium text-md hover:text-errorColor";

const Header: React.FC<HeaderProps> = ({}) => {
  const username = useAuthStore((state) => state.user?.username);
  const toggleBar = useSideBarStore((state) => state.toggle);
  return (
    <header className="fixed left-0 top-0 z-[300] flex h-[70px] w-full items-center bg-white px-4 lg:container md:px-8 lg:relative lg:mx-auto">
      <div className="mb-2 lg:mb-0">
        <Link to="/">
          <h2 className="font-sansitaSwashed text-2xl font-bold md:text-4xl">
            BudsFormula
          </h2>
        </Link>
      </div>

      <nav className="ml-auto hidden items-center gap-8 lg:flex">
        {SITELINKS.map(({ text, link }) => (
          <NavLink
            to={
              username && link === routes.MYRECIPE
                ? link.replace(":u", username)
                : link
            }
            key={text}
            className={({ isActive }) =>
              isActive
                ? `${DEFAULT_NAV_STYLES} font-bold text-errorColor [box-shadow:0px_2px_0px_0px_var(--color-error-main)]`
                : `${DEFAULT_NAV_STYLES}`
            }
          >
            {text}
          </NavLink>
        ))}
      </nav>

      <div className="ml-auto lg:hidden">
        <button className="[appearance:none]" onClick={toggleBar}>
          <IoMenuSharp size={"30"} />
        </button>
      </div>
    </header>
  );
};

export default Header;
