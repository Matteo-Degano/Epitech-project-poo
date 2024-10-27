import * as z from "zod"

export const teams = ["Engineering", "Marketing", "Sales", "Design"]

const noSpecialChars = z.string().refine(
  (value) => {
    return !/[*;]/.test(value)
  },
  {
    message: "Cannot contain special characters like '*' or ';'"
  }
)

export const signupFormSchema = z
  .object({
    username: z
      .string()
      .min(2, "Username must be at least 2 characters")
      .max(30, "Username cannot exceed 30 characters")
      .and(noSpecialChars),
    email: z
      .string()
      .email("Must be a valid email address")
      .max(50, "Email cannot exceed 50 characters")
      .and(noSpecialChars),
    password: z
      .string()
      .min(6, "Password must be at least 6 characters")
      .max(20, "Password cannot exceed 20 characters")
      .and(noSpecialChars),
    confirmPassword: z
      .string()
      .min(6, "Confirm password must be at least 6 characters")
      .max(20, "Confirm password cannot exceed 20 characters")
      .and(noSpecialChars),
    role: z.union([z.string(), z.number()]),
    teams: z
        .array(z.number())
        .min(1, "You must select at least one team"),
  })
  .refine((data) => data.password === data.confirmPassword, {
    message: "Passwords do not match",
    path: ["confirmPassword"]
  })
