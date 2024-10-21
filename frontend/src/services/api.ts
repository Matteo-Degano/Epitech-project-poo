// Helper function to get a cookie value by name
function getCookieValue(name: string): string | null {
  const value = `; ${document.cookie}`
  const parts = value.split(`; ${name}=`)
  if (parts.length === 2) {
    const cookie = parts.pop()?.split(";").shift() || null
    return cookie
  }
  return null
}

export async function fetchData(
  method: "GET" | "POST" | "PUT" | "DELETE",
  endpoint: string,
  body?: any
): Promise<any> {
  try {
    // Extract the access_token cookie
    const accessToken = getCookieValue("access_token")

    // Default headers with optional custom headers merged in
    const headers: HeadersInit = {
      "Content-Type": "application/json",
      // Add Bearer token if access_token exists
      ...(accessToken && { Authorization: `Bearer ${accessToken}` })
    }

    const response = await fetch(`/api${endpoint}`, {
      method,
      headers,
      body: method !== "GET" ? JSON.stringify(body) : null
      // credentials: "include" // Important: send cookies with the request
    })

    // Check if the response is successful
    if (!response.ok) {
      const errorData = await response.json()
      throw new Error(errorData.error || "An error occurred")
    }

    // Parse and return the response JSON
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
