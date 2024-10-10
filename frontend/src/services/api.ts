export async function fetchData(
  method: "GET" | "POST" | "PUT" | "DELETE",
  endpoint: string,
  body?: any
): Promise<any> {
  try {
    const response = await fetch(`/api${endpoint}`, {
      method,
      headers: {
        "Content-Type": "application/json"
      },
      body: method !== "GET" ? JSON.stringify(body) : null
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
