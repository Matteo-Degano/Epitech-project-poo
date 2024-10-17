<script setup lang="ts">
import { ref } from "vue"
import { Button } from "@/components/ui/button"
import { FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form"
import { Input } from "@/components/ui/input"
import { signupFormSchema, teams } from "@/lib/formSchemas/signin.form"
import { toTypedSchema } from "@vee-validate/zod"
import { useForm, useField } from "vee-validate"
import { fetchData } from "@/services/api"

const signinHandler = async (body: any) => {
  console.log(body)
  const response = await fetchData("POST", "/users", body)
  console.log(response)
}

// Initialize selectedTeams as a reactive array (best for multiple checkboxes)
const selectedTeams = ref<string[]>([])

// Define the form using vee-validate for single form fields
const { handleSubmit, errors } = useForm({
  validationSchema: toTypedSchema(signupFormSchema)
})

// Hooks for field validation (regular form fields)
const { value: username } = useField<string>("username")
const { value: email } = useField<string>("email")
const { value: password } = useField<string>("password")
const { value: confirmPassword } = useField<string>("confirmPassword")

// Form submission logic
const onSubmit = handleSubmit((values) => {
  const body = {
    username: values.username,
    email: values.email,
    password: values.password,
    team_id: 1,
    role_id: 1
  }
  signinHandler(body)
})
</script>

<template>
  <form class="flex flex-col w-full gap-6 p-2" @submit.prevent="onSubmit">
    <!-- Username Field -->
    <FormField v-slot="{ componentField, errors }" name="username">
      <FormItem>
        <FormLabel>Username</FormLabel>
        <FormControl>
          <Input type="text" placeholder="Username" v-bind="componentField" v-model="username" />
        </FormControl>
        <FormMessage v-if="errors">{{ errors }}</FormMessage>
      </FormItem>
    </FormField>

    <!-- Email Field -->
    <FormField v-slot="{ componentField, errors }" name="email">
      <FormItem>
        <FormLabel>Email</FormLabel>
        <FormControl>
          <Input
            type="email"
            placeholder="email@example.com"
            v-bind="componentField"
            v-model="email"
          />
        </FormControl>
        <FormMessage v-if="errors">{{ errors }}</FormMessage>
      </FormItem>
    </FormField>

    <!-- Password Field -->
    <FormField v-slot="{ componentField, errors }" name="password">
      <FormItem>
        <FormLabel>Password</FormLabel>
        <FormControl>
          <Input
            type="password"
            placeholder="Password"
            v-bind="componentField"
            v-model="password"
          />
        </FormControl>
        <FormMessage v-if="errors">{{ errors }}</FormMessage>
      </FormItem>
    </FormField>

    <!-- Confirm Password Field -->
    <FormField v-slot="{ componentField, errors }" name="confirmPassword">
      <FormItem>
        <FormLabel>Confirm Password</FormLabel>
        <FormControl>
          <Input
            type="password"
            placeholder="Confirm Password"
            v-bind="componentField"
            v-model="confirmPassword"
          />
        </FormControl>
        <FormMessage v-if="errors">{{ errors }}</FormMessage>
      </FormItem>
    </FormField>

    <!-- Teams Selection with Checkboxes -->
    <FormField v-slot="{ errors }" name="teams">
      <FormItem>
        <FormLabel>Select Teams</FormLabel>
        <FormControl>
          <div class="grid grid-cols-2 gap-4">
            <div v-for="team in teams" :key="team" class="flex items-center">
              <!-- Bind to selectedTeams array using v-model -->
              <input type="checkbox" :value="team" v-model="selectedTeams" class="mr-2" />
              <label>{{ team }}</label>
            </div>
          </div>
        </FormControl>
        <FormMessage v-if="errors">{{ errors }}</FormMessage>
      </FormItem>
    </FormField>

    <!-- Submit Button -->
    <Button class="w-auto ml-auto" type="submit"> Signin </Button>
  </form>
</template>
