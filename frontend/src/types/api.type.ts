export type APIResponse = {
  data: any
  status: number
}

export type Team = {
  id: number
  name: string
}

export type User = {
  id: number
  username: string
  email: string
  role_id: number
  teams: Team[]
}
