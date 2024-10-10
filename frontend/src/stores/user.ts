import { defineStore } from "pinia"

export const useUserStore = defineStore("user", {
  state: () => ({
    userId: 0 as number | null,
    userName: "" as string | null,
    userMail: "" as string | null
  }),
  actions: {
    setUser(id: number, name: string, mail: string) {
      this.userId = id
      this.userName = name
      this.userMail = mail
    },
    setUserId(id: number) {
      this.userId = id
    },
    setUserName(name: string) {
      this.userName = name
    },
    setUserMail(mail: string) {
      this.userMail = mail
    },
    clearUserId() {
      this.userId = null
    }
  }
})
