import AppTextField from "@/components/forms/AppTextField";
import FileInput from "@/components/forms/FileInput";
import IngredientFields from "@/components/forms/IngredientFields";
import { ACCEPTED_FILE_TYPES, MAX_UPLOAD_SIZE } from "@/constants";
import routes from "@/navigation/routes";
import { incomingData, recipeType } from "@/types/general";
import { api } from "@/utilities";
import { appToast } from "@/utilities/appToast";
import { appAxios } from "@/utilities/httConfig";
import { zodResolver } from "@hookform/resolvers/zod";
import { Button, LinearProgress } from "@mui/material";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { generateReactHelpers } from "@uploadthing/react";
import { useForm } from "react-hook-form";
import { useNavigate } from "react-router-dom";
import { z as zod } from "zod";

const { uploadFiles } = generateReactHelpers({
  url: import.meta.env.VITE_APP_BACKEND_BASE_URL + "/api/uploadthing",
});

const ingredientSchema = zod.object({
  name: zod.string(),
  amount: zod.string(),
});
const schema = zod
  .object({
    title: zod.string().min(3),
    ingredients: zod
      .array(ingredientSchema)
      .nonempty("add at least one ingredient"),
    instructions: zod.string().min(20),
    image: zod.string().or(
      zod
        .instanceof(FileList)
        .refine((files) => files?.length >= 1, {
          message: "only one file is required",
        })
        .transform((value) => value.item(0))
        .refine((file) => {
          return !file || file.size <= MAX_UPLOAD_SIZE;
        }, "Maximum of 5MB is allowed")
        .refine((file) => {
          return ACCEPTED_FILE_TYPES.indexOf(file?.type ?? "") !== -1;
        }, "File must be in jpeg or png format"),
    ),
  })
  .required();

type formI = Omit<recipeType, "id" | "image"> & {
  image: FileList | string;
};

type CreateRecipeProps = {
  kind?: "create" | "update";
  submitTo?: string;
  defaultValues?: Record<any, any>;
};
const CreateRecipe: React.FC<CreateRecipeProps> = ({
  defaultValues = {},
  kind = "create",
  submitTo = routes.BACKEND.RECIPES,
}) => {
  const {
    control,
    register,
    watch,
    handleSubmit,
    formState: { errors },
  } = useForm<formI>({
    defaultValues: {
      ...defaultValues,
    },
    resolver: zodResolver(schema),
  });

  const queryClient = useQueryClient();

  const navigate = useNavigate();

  const mutation = useMutation({
    mutationFn: async ({
      data,
      src,
    }: {
      data: formI;
      src: string;
    }): Promise<incomingData<recipeType>> => {
      const data_ = {
        title: data.title,
        ingredients: data.ingredients,
        instructions: data.instructions,
        image: src,
      };
      if (kind === "create") {
        return (await appAxios.post(submitTo, data_)).data;
      }
      return (await appAxios.patch(submitTo, data_)).data;
    },

    onSuccess: (data) => {
      appToast.Success(
        `Recipe has been successfully ${kind === "create" ? "created" : "updated"}`,
      );
      if (kind === "update") {
        queryClient.invalidateQueries({
          queryKey: ["recipe-detail", data.data.id.toString()],
          exact: true,
        });
      }
      queryClient.invalidateQueries({
        queryKey: ["recipe-list"],
      });
      navigate(
        `${routes.RECIPE.replace(":slug", data.data.slug ?? "").replace(":id", (data.data.id ?? "").toString())}`,
      );
    },
    onError: () => {
      appToast.Error(
        `recipe ${kind === "create" ? "creation" : "updated"} failed`,
      );
    },
  });

  const fileMutation = useMutation({
    mutationFn: async (data: File) => {
      const fData = new FormData();
      fData.append("image", data);
      delete api.headers["Content-Type"];
      return await uploadFiles("imageUploader", {
        files: [data],
      });
    },
  });

  function submitHandler(data: formI) {
    if (typeof data.image === "string") {
      return mutation.mutate({ data, src: data.image });
    }

    fileMutation
      .mutateAsync(data.image as unknown as File)
      .then((resp) => {
        mutation.mutate({ data, src: resp[0].url });
      })
      .catch(() => {
        appToast.Error(
          `recipe ${kind === "create" ? "creation" : "updated"} failed`,
        );
      });
  }

  const image = watch("image");
  const src = image
    ? typeof image === "string"
      ? image
      : ACCEPTED_FILE_TYPES.includes(image[0]?.type)
        ? URL.createObjectURL(image[0])
        : ""
    : "";

  const isSubmitting = mutation.isPending || fileMutation.isPending;

  return (
    <form
      onSubmit={handleSubmit((data) => submitHandler(data))}
      className="mx-auto grid max-w-[80ch] gap-6 py-8"
    >
      <h1 className="text-lg font-bold">Create Recipe</h1>
      <div>
        <FileInput
          hookFormProps={{ ...register("image") }}
          label="Thumbnail"
          placeholder="Thumbnail"
          autoComplete="given-name"
          name="image"
          errorMessage={(errors?.image?.message as string) ?? undefined}
          src={src}
        />
      </div>
      <AppTextField
        control={control as any}
        name="title"
        label={"title"}
        color="success"
        message={errors?.title?.message as string}
        fullWidth
      />
      <AppTextField
        control={control as any}
        name="instructions"
        label={"instructions"}
        color="success"
        fullWidth
        multiline
        message={errors?.instructions?.message as string}
        rows={5}
      />
      <IngredientFields
        control={control as any}
        register={register}
        name="ingredients"
        message={errors.ingredients?.message}
      />
      <Button
        fullWidth
        disableElevation
        color={"success"}
        size="large"
        type="submit"
        className="!font-bold"
        variant="contained"
        disabled={isSubmitting}
      >
        <span>{isSubmitting ? "Please wait..." : "Submit"}</span>
      </Button>

      {isSubmitting && (
        <LinearProgress
          sx={{
            position: "fixed",
            zIndex: "1000",
            width: "100%",
            top: "0px",
            left: "0px",
          }}
          color="error"
        />
      )}
    </form>
  );
};

export default CreateRecipe;
