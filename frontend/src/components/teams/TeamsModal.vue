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
import { Form, Field, ErrorMessage } from "vee-validate"
import { z } from "zod"
import { toTypedSchema } from "@vee-validate/zod"
import { fetchData } from "@/services/api"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/toast/use-toast"

const { toast } = useToast()
const emit = defineEmits(["close", "refresh"])

type Team = {
  id: number
  name: string
}

const props = defineProps<{
  mode: string 
  data: Team
}>()

const teamFormSchema = z.object({
  name: z.string().min(1, "Name is required")
})

const submitForm = async (body: any) => {
  if (props.mode === "create") {
    try {
      const response = await fetchData("POST", "/teams", body)
      if (response.status === 201) {
        toast({
          description: `Team successfully created!`
        })
        emit("refresh")
      } else {
        toast({
          description: `An error occurred.`,
          variant: "destructive"
        })
      }
    } catch (error) {
      toast({
        description: `An error occurred.`,
        variant: "destructive"
      })
      console.log(error)
    }
  } else {
    try {
      const response = await fetchData("PUT", `/teams/${props.data.id}`, body)
      if (response.status === 200) {
        toast({
          description: `Team successfully updated!`
        })
        emit("refresh")
      } else {
        toast({
          description: `An error occurred.`,
          variant: "destructive"
        })
      }
    } catch (error) {
      toast({
        description: `An error occurred.`,
        variant: "destructive"
      })
      console.log(error)
    }
  }
}

const initialValues = {
  name: props.mode === "update" ? props.data.name : ""
}

const inputStyle = "flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"

</script>

<template>
  <Dialog>
    <DialogTrigger>
      <Button>
        {{ props.mode === "create" ? "Create Team" : "Update" }}
      </Button>
    </DialogTrigger>
    <DialogContent class="max-h-[90dvh] overflow-y-auto">
      <DialogHeader>
        <DialogTitle>
          {{ props.mode === "create" ? "Create Team" : "Update Team" }}
        </DialogTitle>
        <DialogDescription>
          {{
            props.mode === "create"
              ? "Create a team here. Click save when you're done."
              : "Make changes to the team here. Click save when you're done."
          }}
        </DialogDescription>
      </DialogHeader>

      <Form :validation-schema="toTypedSchema(teamFormSchema)" @submit="submitForm" :initialValues="initialValues" class="flex flex-col w-full gap-6 p-2">
        <label for="name" class="font-medium">Team Name</label>
        <Field type="text" name="name" :class="inputStyle" />
        <ErrorMessage name="name" class="text-[#FF0000]" />

        <DialogClose as-child>
          <Button class="w-auto ml-auto" type="submit"> {{ props.mode === "create" ? "Create" : "Update" }} </Button>
        </DialogClose>
      </Form>
    </DialogContent>
  </Dialog>
</template>
