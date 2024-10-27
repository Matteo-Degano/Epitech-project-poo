<script setup lang="ts">
import { computed, onMounted, ref, watch } from "vue"
import { fetchData } from "@/services/api"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Check, ChevronsUpDown } from "lucide-vue-next"
import { cn } from "@/utils"
import {
    Dialog,
    DialogClose,
    DialogContent,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    DialogTrigger
} from "@/components/ui/dialog"
import {
    Command,
    CommandEmpty,
    CommandGroup,
    CommandInput,
    CommandItem,
    CommandList
} from "@/components/ui/command"
import { Popover, PopoverTrigger, PopoverContent } from "@/components/ui/popover"
import DialogDescription from "../ui/dialog/DialogDescription.vue"
import { useToast } from "../ui/toast/use-toast"
import { CirclePlus } from "lucide-vue-next"
import type { User } from "@/types/api.type"
import { useAuthStore } from "@/stores/auth.store"

const selectedUser = ref("")
const usersList = ref<User[]>([])
const open = ref(false)
const { toast } = useToast()
const authStore = useAuthStore()
const emit = defineEmits(["refresh"])


const props = defineProps({
    data: Array,
    teamId: Number
})

const fetchUsers = async () => {
    try {
        const response = await fetchData("GET", "/users")
        usersList.value = response.data.filter((user: User) => {
            return !props.data.some((teamUser: User) => teamUser.id === user.id) && user.role_id !== 3 && user.role_id !== 4 && user.id !== authStore.user.id
        })
    } catch (err: any) {
        toast({
            variant: "destructive",
            description: "Error fetching data"
        })
    }
}

const submitTeamMember = async () => {
    const user = usersList.value.find((user) => user.username === selectedUser.value)
    if (!user) {
        toast({
            variant: "destructive",
            description: "User not found"
        })
        return
    }

    try {
        await fetchData("PUT", `/users/${user.id}`, {
            team_ids: user.teams.map((team) => team.id).concat(props.teamId)
        })
        toast({
            description: "User added to team"
        })
        await fetchUsers()
        selectedUser.value = ""
        emit("refresh")
    } catch (err: any) {
        toast({
            variant: "destructive",
            description: "Error adding user to team"
        })
    }
}

onMounted(() => {
    fetchUsers()
})
</script>

<template>
    <Dialog>
        <DialogTrigger as-child>
            <Button class="flex gap-2 bg-green-600 hover:bg-green-500">
                <CirclePlus />Add a member
            </Button>
        </DialogTrigger>
        <DialogContent class="max-w-md">
            <DialogHeader>
                <DialogTitle>Add member</DialogTitle>
            </DialogHeader>
            <DialogDescription>Add a member to this team</DialogDescription>
            
            <div class="flex justify-between items-center">
                <Label> User: </Label>
                <Popover v-model:open="open">
                    <PopoverTrigger as-child>
                        <Button
                        variant="outline"
                        role="combobox"
                        :aria-expanded="open"
                        class="w-[200px] justify-between"
                        >
                        {{
                            selectedUser
                            ? usersList.find((user) => user.username === selectedUser)?.username
                            : "Select a user..."
                        }}
                            <ChevronsUpDown class="ml-2 h-4 w-4 shrink-0 opacity-50" />
                        </Button>
                    </PopoverTrigger>
                    <PopoverContent class="w-[200px] p-0">
                        <Command v-model="selectedUser">
                            <CommandInput placeholder="Search user..." />
                            <CommandEmpty>No users found.</CommandEmpty>
                            <CommandList>
                                <CommandGroup>
                                    <CommandItem
                                    v-for="user in usersList"
                                    :key="user.id"
                                    :value="user.username"
                                    @select="open = false"
                                    >
                                    {{ user.username }}
                                        <Check
                                        :class="
                                        cn(
                                        'ml-auto h-4 w-4',
                                        selectedUser.value === user.username ? 'opacity-100' : 'opacity-0'
                                        )
                                        "
                                        />
                                    </CommandItem>
                                </CommandGroup>
                            </CommandList>
                        </Command>
                    </PopoverContent>
                </Popover>
            </div>

            <DialogFooter>
                <DialogClose as-child>
                    <Button type="button" variant="destructive">Cancel</Button>
                </DialogClose>
                <DialogClose as-child>
                    <Button
                    type="button"
                    class="bg-green-600 hover:bg-green-500"
                    @click="submitTeamMember"
                    >
                    Add Member
                    </Button>
                </DialogClose>
            </DialogFooter>
        </DialogContent>
    </Dialog>
</template>