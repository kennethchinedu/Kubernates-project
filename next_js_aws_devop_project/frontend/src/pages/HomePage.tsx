import RecipeCard from "@/components/cards/RecipeCard";
import LoadingComponent from "@/components/loaders/LoadingComponent";
import useFetchOnPageEnd from "@/hooks/scrollPaginate";
import routes from "@/navigation/routes";
import { RecipeList } from "@/types/general";
import { appAxios } from "@/utilities/httConfig";
import { Button } from "@mui/material";
import { useInfiniteQuery } from "@tanstack/react-query";
import { BsArrowRight } from "react-icons/bs";
import { Link } from "react-router-dom";

type HomePageProps = {};

const HomePage: React.FC<HomePageProps> = ({}) => {
  const { data, hasNextPage, fetchNextPage, isFetchingNextPage, isLoading } =
    useInfiniteQuery({
      queryKey: ["recipe-list"],
      queryFn: async ({
        pageParam,
      }: {
        pageParam: number;
      }): Promise<RecipeList> => {
        return (
          await appAxios.get(routes.BACKEND.RECIPES, {
            params: { page: pageParam },
          })
        ).data;
      },
      getNextPageParam: (lastPage) => {
        const currentPage = lastPage.data?.currentPage ?? 0;
        const total = lastPage.data?.totalPages ?? 0;
        return total > currentPage ? currentPage + 1 : undefined;
      },
      initialPageParam: 1,
    });

  const cards = (data?.pages ?? []).map((page) => {
    return page.data.results.map((item) => {
      return <RecipeCard key={item.id} {...item} src={item.image} />;
    });
  });

  useFetchOnPageEnd(isFetchingNextPage, hasNextPage, fetchNextPage);

  return (
    <section
      aria-labelledby="recipe-header"
      className="grid-col-12 grid gap-y-4"
    >
      <div className="col-span-12 flex items-center justify-between py-6">
        <h1 id="recipe-header" className="text-xl font-bold">
          Recipes
        </h1>
        <Link to={routes.CREATE}>
          <Button
            variant="text"
            sx={{
              color: "black",
              fontSize: "1rem",
              display: "flex",
              fontWeight: "bold",
            }}
            className="items-center justify-center gap-2"
          >
            <span>Create One</span>
            <span>
              <BsArrowRight size={20} />
            </span>
          </Button>
        </Link>
      </div>

      <LoadingComponent
        className="col-span-12"
        isEmpty={cards.length < 1}
        isLoading={isLoading}
        isFetching={isFetchingNextPage}
      >
        <section
          aria-label="recipe list"
          className="col-span-12 grid gap-4"
          style={{
            gridTemplateColumns: "repeat(auto-fill,  minmax(300px,  1fr))",
          }}
        >
          {cards}
        </section>
      </LoadingComponent>
    </section>
  );
};

export default HomePage;
