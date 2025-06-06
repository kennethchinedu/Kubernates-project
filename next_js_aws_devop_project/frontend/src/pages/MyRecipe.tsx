import RecipeCard from "@/components/cards/RecipeCard";
import LoadingComponent from "@/components/loaders/LoadingComponent";
import useFetchOnPageEnd from "@/hooks/scrollPaginate";
import routes from "@/navigation/routes";
import { RecipeList } from "@/types/general";
import { appAxios } from "@/utilities/httConfig";
import { useInfiniteQuery } from "@tanstack/react-query";

type MyRecipeProps = {};
const MyRecipe: React.FC<MyRecipeProps> = ({}) => {
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
    <>
      <section
        aria-labelledby="recipe-header"
        className="grid-col-12 grid gap-y-4"
      >
        <div className="col-span-12 flex items-center justify-between py-6">
          <h1 id="recipe-header" className="text-xl font-bold">
            My Recipes
          </h1>
        </div>
        <LoadingComponent
          className="col-span-12"
          isLoading={isLoading}
          isEmpty={cards.length < 1}
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
    </>
  );
};

export default MyRecipe;
