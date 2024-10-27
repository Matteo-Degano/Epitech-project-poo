export type APIResponse = {
  data: any
  status: number
}

export type User = {
  id: number
  username: string
  email: string
  role_id: number
  teams: Team[]
}

export type Team = {
  id: number
  name: string
}
export type WorkingTimeType = {
  id: number
  start: string
  end: string
  user: {
    id: number
    username: string
    email: string
  }
}
