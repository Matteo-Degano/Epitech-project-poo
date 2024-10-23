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
  
      const response = await fetch(`http://0.0.0.0:4000/api${endpoint}`, {
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
  
      // Parse and return the response JSON
      const json = await response.json()

      console.log(json);

    //   await AsyncStorage.setItem('access_token', data.access_token);
    //   await AsyncStorage.setItem('refresh_token', data.refresh_token);
  
      return {
        data: json,
        status: response.status
      }
    } catch (error) {
      console.error("Fetch error:", error)
      throw error
    }
  }
  