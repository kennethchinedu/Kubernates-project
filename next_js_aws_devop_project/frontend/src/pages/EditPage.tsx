import LoadingComponent from "@/components/loaders/LoadingComponent";
import routes from "@/navigation/routes";
import { incomingData, recipeType } from "@/types/general";
import { appAxios } from "@/utilities/httConfig";
import { useQuery } from "@tanstack/react-query";
import { useParams } from "react-router-dom";
import CreateRecipe from "./CreateRecipe";

type EditPageProps = {};
const EditPage: React.FC<EditPageProps> = ({}) => {
  const { id } = useParams();
  const url = routes.BACKEND.RECIPE_DETAIL.replace(":id", id ?? "");
  const { data, status } = useQuery({
    queryKey: ["recipe-detail", id],
    queryFn: async (): Promise<incomingData<recipeType>> => {
      return (await appAxios.get(url)).data;
    },
  });

  return (
    <div>
      <LoadingComponent isLoading={status === "pending"}>
        <CreateRecipe
          kind="update"
          defaultValues={data?.data ? data.data : {}}
          submitTo={`${routes.BACKEND.RECIPE_DETAIL.replace(":id", id?.toString() ?? "")}`}
        />
      </LoadingComponent>
    </div>
  );
};

export default EditPage;
