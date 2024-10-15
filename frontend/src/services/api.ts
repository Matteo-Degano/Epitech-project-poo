export async function fetchData(
  method: "GET" | "POST" | "PUT" | "DELETE",
  endpoint: string,
  body?: any
): Promise<any> {
  try {
    const headers: HeadersInit = {
      "Content-Type": "application/json"
    }

    const response = await fetch(`/api${endpoint}`, {
      method,
      headers,
      body: method !== "GET" ? JSON.stringify(body) : null,
      credentials: "include" // Important: send cookies with the request
    })

    const json = await response.json()

    return {
      data: json.data,
      status: response.status
    }
  } catch (error) {
    console.error("Fetch error:", error)
    throw error
  }
}
