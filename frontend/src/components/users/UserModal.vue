<script setup lang="ts">
import { reactive, ref } from "vue"
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
  DialogDescription
} from "@/components/ui/dialog"
import { signupFormSchema, teams } from "@/lib/formSchemas/signin.form"
import { useForm, useField } from "vee-validate"
import { toTypedSchema } from "@vee-validate/zod"
import { FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form"
import {fetchData} from "@/services/api"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Select } from "@/components/ui/select"

const isModalOpen = ref(false)

const props = defineProps({
  mode: String, // 'create' or 'update'
  data: Object // UserObject
})

// const teams = await fetchData("GET", "/teams")

type UserType = {
  id: number
  name: string
  email: string
  team_id: number
  role_id: number
}

type TeamType = {
    id: number
    name: string
}

const signinHandler = async (body: any) => {
  console.log(body)
  const response = await fetchData("POST", "/users", body)
  console.log(response)
}

// Define the form using vee-validate for single form fields
const { handleSubmit, errors } = useForm({
  validationSchema: toTypedSchema(signupFormSchema)
})

// Initialize selectedTeams as a reactive array (best for multiple checkboxes)
const selectedTeams = ref<string[]>([])

// Hooks for field validation (regular form fields)
const { value: username } = useField<string>("username")
const { value: email } = useField<string>("email")
const { value: password } = useField<string>("password")
const { value: confirmPassword } = useField<string>("confirmPassword")
const { value : role_id } = useField<string>("role_id")

// Form submission logic
const onSubmit = handleSubmit((values) => {
  const body = {
    username: values.username,
    email: values.email,
    password: values.password,
    team_ids: selectedTeams,
    role_id: 1
  }
  signinHandler(body)
})

</script>

<template>
  <Dialog>
    <DialogTrigger class="space-x-4">
      <Button>
        {{ props.mode === "create" ? "Create user" : "Update" }}
      </Button>
    </DialogTrigger>
    <DialogContent class="max-h-[90dvh] overflow-y-auto">
      <DialogHeader>
        <DialogTitle>
          {{ props.mode === "create" ? "Create user" : "Update user" }}
        </DialogTitle>
        <DialogDescription>
          {{ props.mode === "create" ? "Create an user here. Click save when you're done." : "Make changes to an user here. Click save when you're done." }}
        </DialogDescription>
      </DialogHeader>
      <form class="flex flex-col w-full gap-6 p-2" @submit.prevent="onSubmit">
        <!-- Username Field -->
        <FormField v-slot="{ componentField, errors }" name="username">
          <FormItem>
            <FormLabel>Username</FormLabel>
            <FormControl>
              <Input 
                type="text" 
                placeholder="Username" 
                v-bind="componentField" 
                v-model="username" 
                :defaultValue="props.data.username ? props.data.username : ''" />
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
                :defaultValue="props.data.email ? props.data.email : ''"
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

        <!-- Role Selection -->
        <FormField v-slot="{errors}" name="role">
          <FormItem>
            <FormLabel>Role</FormLabel>
            <FormControl>
              <select>
                <option value="1">Employee</option>
                <option value="2">Manager</option>
              </select>
            </FormControl>
            <FormMessage v-if="errors">{{ errors }}</FormMessage>
          </FormItem>
        </FormField>

        <!-- Submit Button -->
        <Button :disabled="errors" class="w-auto ml-auto" type="submit"> Signin </Button>
      </form>
    </DialogContent>
  </Dialog>
</template>
