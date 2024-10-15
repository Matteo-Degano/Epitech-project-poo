import * as z from "zod"

const noSpecialChars = z.string().refine(
  (value) => {
    return !/[*;]/.test(value)
  },
  {
    message: "Password cannot contain special characters like '*' or ';'"
  }
)

export const formSchema = z.object({
  username: z
    .string()
    .email("Username must be a valid email address")
    .max(50, "Username cannot exceed 50 characters"),

  password: z
    .string()
    .min(6, "Password must be at least 6 characters")
    .max(20, "Password cannot exceed 20 characters")
    .and(noSpecialChars)
})
