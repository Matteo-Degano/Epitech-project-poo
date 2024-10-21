<script setup lang="ts">
import { Button } from "@/components/ui/button"
import { FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form"
import { Input } from "@/components/ui/input"
import { toTypedSchema } from "@vee-validate/zod"
import { useForm, useField } from "vee-validate"
import { formSchema } from "@/lib/formSchemas/login.form"
import { useAuthStore } from "@/stores/auth.store"

const authStore = useAuthStore()

// Define the form and its validation schema using useForm from vee-validate
const { handleSubmit, errors } = useForm({
  validationSchema: toTypedSchema(formSchema)
})

// Form submission logic
const onSubmit = handleSubmit((values) => {
  console.log(values)
  authStore.login(values.email, values.password)
})

// Hook for field validation
const { value: email } = useField<string>("email")
const { value: password } = useField<string>("password")
</script>

<template>
  <form class="flex flex-col w-full gap-6 p-2" @submit.prevent="onSubmit">
    <FormField v-slot="{ componentField, errors }" name="email">
      <FormItem>
        <FormLabel>Email</FormLabel>
        <FormControl>
          <Input type="email" placeholder="email" v-bind="componentField" v-model="email" />
        </FormControl>
        <FormMessage v-if="errors">{{ errors }}</FormMessage>
      </FormItem>
    </FormField>
    <FormField v-slot="{ componentField, errors }" name="password">
      <FormItem>
        <FormLabel>Password</FormLabel>
        <FormControl>
          <Input
            type="password"
            placeholder="********"
            v-bind="componentField"
            v-model="password"
          />
        </FormControl>
        <FormMessage v-if="errors">{{ errors }}</FormMessage>
      </FormItem>
    </FormField>

    <Button class="w-auto ml-auto" type="submit"> Login </Button>
  </form>
</template>
