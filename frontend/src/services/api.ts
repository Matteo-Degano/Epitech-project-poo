export async function fetchData(
  method: "GET" | "POST" | "PUT" | "DELETE",
  endpoint: string,
  body?: any
): Promise<any> {
  try {
    // Default headers with optional custom headers merged in
    const headers: HeadersInit = {
      "Content-Type": "application/json"
    }

    const response = await fetch(`/api${endpoint}`, {
      method,
      headers,
      body: method !== "GET" ? JSON.stringify(body) : null,
      credentials: "include" // Important: send cookies with the request
    })

    // Check if the response is successful
    if (!response.ok) {
      const errorData = await response.json()
      throw new Error(errorData.error || "An error occurred")
    }

    // If its a delete request with no content, return null
    if (response.status === 204) {
      return {
        data: null,
        status: response.status
      }
    }

    // Parse and return the response JSON for other status codes
    const json = await response.json()

    return {
      data: json,
      status: response.status
    }
  } catch (error) {
    console.error("Fetch error:", error)
    throw error
  }
}
