import AppTextField from "@/components/forms/AppTextField";
import routes from "@/navigation/routes";
import { zodResolver } from "@hookform/resolvers/zod";
import { Button, InputAdornment } from "@mui/material";
import { useState } from "react";
import { useForm } from "react-hook-form";
import { HiEye } from "react-icons/hi";
import { HiEyeSlash } from "react-icons/hi2";
import { Link } from "react-router-dom";
import { z as zod } from "zod";

type SignupProps = {};

const schema = zod
  .object({
    username: zod.string().min(3),
    password: zod.string().min(8),
    confirmPassword: zod.string(),
  })
  .required();

const Signup: React.FC<SignupProps> = ({}) => {
  const {
    control,
    handleSubmit,
    formState: { errors },
  } = useForm({
    defaultValues: {
      username: "",
      password: "",
      confirmPassword: "",
    },
    resolver: zodResolver(schema),
  });
  const [showPassword, setShowPassword] = useState(false);
  return (
    <main className="lg:flex">
      <section
        className="hidden h-[100svh] basis-[36%] lg:block"
        style={{
          background: `linear-gradient(rgba(0,0,0,0.4), rgba(0,0,0,0.4)),url(${"https://minimalistbaker.com/wp-content/uploads/2023/09/Ultimate-Salmon-Burgers-7-500x750.jpg"})`,
          backgroundRepeat: "no-repeat",
          backgroundPosition: "center",
          backgroundSize: "cover",
        }}
      ></section>
      <section className="relative flex h-[100svh] grow items-center justify-center">
        <form
          onSubmit={handleSubmit(() => {})}
          className="w-[90%] max-w-[560px]"
        >
          <div className="py-6 text-center">
            <Link to={routes.HOME_PAGE}>
              <h1 className="font-sansitaSwashed text-3xl font-bold md:text-4xl">
                BudsFormula
              </h1>
            </Link>
          </div>
          <div className="">
            <div className="grid gap-6">
              <AppTextField
                label={"username"}
                color={"success"}
                fullWidth
                control={control as any}
                name="username"
                message={errors?.username?.message}
              />
              <AppTextField
                fullWidth
                label={"password"}
                color={"success"}
                control={control as any}
                name="password"
                type={showPassword ? "text" : "password"}
                InputProps={{
                  endAdornment: (
                    <InputAdornment
                      onClick={setShowPassword.bind(undefined, !showPassword)}
                      sx={{ cursor: "pointer" }}
                      position="end"
                    >
                      <span>{showPassword ? <HiEyeSlash /> : <HiEye />} </span>
                    </InputAdornment>
                  ),
                }}
                message={errors?.password?.message}
              />
              <AppTextField
                fullWidth
                label={"confirm password"}
                color={"success"}
                control={control as any}
                name="confirmPassword"
                type={"password"}
                message={errors.confirmPassword?.message}
              />
            </div>
            <div className="flex items-center justify-between py-3">
              <Link to={routes.LOGIN} className="text-[#1e90ff]">
                already have an account? login instead
              </Link>
            </div>
            <Button
              className="w-full"
              variant="contained"
              size="large"
              disableElevation
              type="submit"
              sx={{
                fontWeight: "bold",
              }}
            >
              Register
            </Button>
          </div>
        </form>
      </section>
    </main>
  );
};

export default Signup;
