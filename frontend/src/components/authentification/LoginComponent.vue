<script setup lang="ts">
import { Button } from "@/components/ui/button"
import { FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form"
import { Input } from "@/components/ui/input"
import { toast } from "@/components/ui/toast"
import { toTypedSchema } from "@vee-validate/zod"
import { useForm, useField } from "vee-validate"
import { h } from "vue"
import { formSchema } from "@/lib/formSchemas/login.form"

// Define the form and its validation schema using useForm from vee-validate
const { handleSubmit, errors } = useForm({
  validationSchema: toTypedSchema(formSchema)
})

// Form submission logic
const onSubmit = handleSubmit((values) => {
  // Display form values in a toast message upon successful submission
  toast({
    title: "You submitted the following values:",
    description: h(
      "pre",
      { class: "mt-2 w-[340px] rounded-md bg-slate-950 p-4" },
      h("code", { class: "text-white" }, JSON.stringify(values, null, 2))
    )
  })
})

// Hook for field validation
const { value: username } = useField<string>("username")
const { value: password } = useField<string>("password")
</script>

<template>
  <form class="flex flex-col w-full gap-6 p-2" @submit.prevent="onSubmit">
    <FormField v-slot="{ componentField, errors }" name="username">
      <FormItem>
        <FormLabel>Email</FormLabel>
        <FormControl>
          <Input type="email" placeholder="email" v-bind="componentField" v-model="username" />
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
