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
import { signupFormSchema } from "@/lib/formSchemas/signin.form"
import { useForm, useField } from "vee-validate"
import { toTypedSchema } from "@vee-validate/zod"
import { FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form"
import {fetchData} from "@/services/api"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { useAuthStore } from "@/stores/auth.store"
import { useToast } from "@/components/ui/toast/use-toast"

const { toast } = useToast()
const authStore = useAuthStore()

type Team = {
  id: number;
  name: string;
}

type User = {
    id: number
    username: string
    email: string
    role: number
}

const props = defineProps<{
  mode: string; // 'create' or 'update'
  data: User; // UserObject
  teams: Team[];
}>()

const submitForm = async (body: any) => {
  if (props.mode === "create") {
    // POST request for creating a new user
    try{
      const response = await fetchData("POST", "/users", body)
      if (response.status === 201) {
        toast({
          description: `User successfully created !`
        })
      } else {
        toast({
          description: `An error occured.`,
          variant: "destructive"
        })
      }
    } catch (error) {
      toast({
        description: `An error occured.`,
        variant: "destructive"
      })
      console.log(error)
    }
  } else {
    // PUT request for updating an existing user
    try{
      const response = await fetchData("PUT", `/users/${props.data.id}`, body)
      if (response.status === 200) {
        toast({
          description: `User successfully updated !`
        })
      } else {
        toast({
          description: `An error occured.`,
          variant: "destructive"
        })
      }
    } catch (error) {
      toast({
        description: `An error occured.`,
        variant: "destructive"
      })
      console.log(error)
    }
  }
}

// Define the form using vee-validate for single form fields
const { handleSubmit, errors } = useForm({
  validationSchema: toTypedSchema(signupFormSchema)
})

// Initialize selectedTeams as a reactive array (best for multiple checkboxes)
const selectedTeams = ref<string[]>([])
const selectedRole = ref<number>()

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
    team_ids: selectedTeams.value,
    role_id: selectedRole.value
  }
  submitForm(body)
})

if(props.mode === "update") {
  selectedRole.value = props.data.role
  username.value = props.data.username
  email.value = props.data.email
}

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
                />
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
                <div v-for="team in props.teams" :key="team.id" class="flex items-center">
                  <!-- Bind to selectedTeams array using v-model -->
                  <input type="checkbox" :value="team.id" v-model="selectedTeams" class="mr-2" />
                  <label>{{ team.name }}</label>
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
              <select v-model="selectedRole" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50">
                <option value="1">Employee</option>
                <option value="2">Manager</option>
                <option value="3" v-if="authStore.user.role_id === 4">General manager</option>
                <option value="4" v-if="authStore.user.role_id === 4">Admin</option>
              </select>
            </FormControl>
            <FormMessage v-if="errors">{{ errors }}</FormMessage>
          </FormItem>
        </FormField>

        <!-- Submit Button -->
        <DialogClose as-child>
          <Button class="w-auto ml-auto" type="submit"> Save </Button>
        </DialogClose>
      </form>
    </DialogContent>
  </Dialog>
</template>
