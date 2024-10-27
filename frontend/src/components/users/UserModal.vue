<script setup lang="ts">
import { ref } from "vue"
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
  DialogDescription
} from "@/components/ui/dialog"
import { CirclePlus } from "lucide-vue-next"
import { signupFormSchema } from "@/lib/formSchemas/signin.form"
import { updateFormSchema } from "@/lib/formSchemas/update.form"
import { Form, Field, ErrorMessage } from "vee-validate"
import { toTypedSchema } from "@vee-validate/zod"
import {fetchData} from "@/services/api"
import { Button } from "@/components/ui/button"
import { useAuthStore } from "@/stores/auth.store"
import { useToast } from "@/components/ui/toast/use-toast"
import { User, Team } from "@/types/api.type"

const { toast } = useToast()
const authStore = useAuthStore()
const emit = defineEmits(["close", "refresh"])

const props = defineProps<{
  mode: string 
  data: User
  teams: Team[]
}>()

const submitForm = async (body: any) => {
  if (props.mode === "create") {
    try{
      const response = await fetchData("POST", "/users", body)
      if (response.status === 201) {
        toast({
          description: `User successfully created !`
        })
        emit("refresh")
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
    try{
      const response = await fetchData("PUT", `/users/${props.data.id}`, body)
      if (response.status === 200) {
        toast({
          description: `User successfully updated !`
        })
        emit("refresh")
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

const selectedTeams = ref<string[]>([])

const initialValues = {
  username: props.mode === "update" ? props.data.username : "",
  email: props.mode === "update" ? props.data.email : "",
  password: "",
  confirmPassword: "",
  teams: props.mode === "update" ? props.data.teams.map(team => team.id.toString()) : [],
  role: props.mode === "update" ? props.data.role_id : 1
}

const onSubmit = (values) => {
  const body = {
    username: values.username,
    email: values.email,
    password: values.password,
    team_ids: values.teams,
    role_id: values.role
  }
  submitForm(body)
}

const validationSchema = props.mode === "create" ? signupFormSchema : updateFormSchema

const inputStyle="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"

</script>

<template>
  <Dialog>
    <DialogTrigger class="space-x-4">
      <Button v-if="props.mode === 'create'" class="flex gap-2 bg-green-600 hover:bg-green-500">
        <CirclePlus />Add a new user
      </Button>
      <Button v-if="props.mode === 'update'">Update</Button>
    </DialogTrigger>
    <DialogContent class="max-h-[90dvh] overflow-y-auto">
      <DialogHeader>
        <DialogTitle>
          {{ props.mode === "create" ? "Create user" : "Update user" }}
        </DialogTitle>
        <DialogDescription>
          {{
            props.mode === "create"
            ? "Create an user here. Click save when you're done."
            : "Make changes to an user here. Click save when you're done."
          }}
        </DialogDescription>
      </DialogHeader>
      
      <Form v-slot="{errors}" :validation-schema="toTypedSchema(validationSchema)" @submit="onSubmit" class="flex flex-col w-full gap-6 p-2" :initialValues="initialValues" :validateOnMount="true">
        <label for="username" class="font-medium">Username</label>
        <Field type="text" name="username" :class="inputStyle"/>
        <ErrorMessage name="username" class="text-[#ef4444] font-medium"/>
        
        <label for="email" class="font-medium">Email</label>
        <Field type="email" name="email" :class="inputStyle"/>
        <ErrorMessage name="email" class="text-[#ef4444] font-medium"/>
        
        <label for="password" class="font-medium">Password</label>
        <Field type="password" name="password" :class="inputStyle"/>
        <ErrorMessage name="password" class="text-[#ef4444] font-medium"/>
        
        <label for="confirmPassword" class="font-medium">Confirm password</label>
        <Field type="password" name="confirmPassword" :class="inputStyle"/>
        <ErrorMessage name="confirmPassword" class="text-[#ef4444] font-medium"/>
        
        <label for="teams" class="font-medium">Select Teams</label>
        <div class="grid grid-cols-2 gap-4">
          <div v-for="team in props.teams" :key="team.id" class="flex items-center">
            <Field type="checkbox" :value="team.id" v-model="selectedTeams" name="teams" class="mr-2" />
            <label>{{ team.name }}</label>
          </div>
        </div>
        <ErrorMessage name="teams" class="text-[#ef4444] font-medium"/>
        
        <label for="role" class="font-medium">Role</label>
        <Field as="select" name="role" :class="inputStyle">
          <option value="1">Employee</option>
          <option value="2">Manager</option>
          <option value="3" v-if="authStore.user.role_id === 4">General manager</option>
          <option value="4" v-if="authStore.user.role_id === 4">Admin</option>
        </Field>
        <ErrorMessage name="role" class="text-[#ef4444] font-medium"/>
        
        <DialogClose as-child>
          <Button class="w-auto ml-auto" type="submit" :disabled="Object.keys(errors).length > 0"> {{ props.mode === "create" ? "Create": "Update" }} </Button>
        </DialogClose>
      </Form>
    </DialogContent>
  </Dialog>
</template>
