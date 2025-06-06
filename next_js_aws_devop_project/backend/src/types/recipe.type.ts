export type recipeType = {
  title: string;
  instructions: string;
  image: any;
  ingredients: { name: string; amount: string }[];
  username: string;
};
