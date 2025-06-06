import { useEffect } from "react";

const useFetchOnPageEnd = (
  isFetchingNext: boolean,
  hasNext: boolean,
  fetchNext: () => void,
) => {
  useEffect(() => {
    const handleScroll = () => {
      if (
        hasNext &&
        !isFetchingNext &&
        window.innerHeight + document.documentElement.scrollTop >=
          document.documentElement.offsetHeight
      ) {
        fetchNext();
      }
    };
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isFetchingNext, hasNext]);
};

export default useFetchOnPageEnd;
